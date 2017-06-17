% function [x, x_true, E, stats] = main(prm, x_true0, E0, stats0)
%
% Runs the system using parameters contained in a structure variable.
%
% @param prm - system parametes (structure, see get_prmstruct.m)
% @param x_true0 - initial true field (n x 1, optional)
% @param E0 - initial ensemble (n x m, optional)
% @param stats0 - initial statistics (structure, optional)
% @return x - final analysis (n x 1)
% @return x_true - final true field (n x 1)
% @return E - final ensemble (n x m)
% @return stats - final statistics (structure)
%
% Usage:
%
% [x, x_true, E, stats] = main(prm)
%   - conduct a run with a freshly generated ensemble
% [x, x_true, E, stats] = main(prm, x_true0)
%   - conduct a run with a freshly generated ensemble and specified true field
% [x, x_true, E, stats] = main(prm, x_true0, E0)
%   - conduct a run with specified true field and ensemble
% [x, x_true, E, stats] = main(prm, x_true0, E0, stats0)
%   - conduct a run with specified true field and ensemble; and append the 
%     existing statics rather than start it from scratch

% File:           main.m
%
% Created:        23/03/2009
%
% Last modified:  02/05/2011
%
% Author:         Pavel Sakov
%                 NERSC
%
% Purpose:        Runs the system using parameters contained in a structure
%                 variable.
%
% Description:    Main file of the data assimilation system.
%
% Revisions:      29.10.09 PS: 
%                   - Swapped integration and observation+assimilation in the
%                     main cycle. Replaced (step - 1) by (step) in tests on
%                     whether observation or assimilation should be conducted.
%                     Introduced reporting of accumulated time spent on
%                     integration and assimilation.
%                 1.11.2009 PS:
%                   - added measurement of total time for assimilation and
%                     propagation
%                 25/08/2010 PS:
%                   - This file, formerly known as main_a.m, now replaced the
%                     previous (synchronous) version of main.m
%                 02.05.2011 PS:
%                   - Minor changes, to accommodate prm.noasynchronous = 1.

%% Copyright (C) 2009 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [x, x_true, E, stats] = main(prm, x_true0, E0, stats0)

    m = prm.m;
    resumed = 0;

    prm = setpath(prm);

    %
    % Precomputation
    %   

    % Compute square root of covariance matrices
    % 1) Obs error covariance 
    R=calc_r(prm);


    % 2) Init state error covariance

    rand('state', prm.seed); % initialise to seed
    randn('state', prm.seed); % initialise to seed
    
    if ~exist('E0', 'var') | isempty(E0)
        %
        % generate ensemble
        %
        [x_true, E, t, prm] = generate(prm);
        if exist('x_true0', 'var') & ~isempty(x_true0)
            x_true = x_true0;
        end
    else
        resumed = 1;
        x_true = x_true0;
        E = E0(:, 1 : m);
        if exist('stats0', 'var') & ~isempty(stats0)
            rand('state', stats0.rand_finalstate);
            randn('state', stats0.randn_finalstate);
        end
    end
    
    if exist('stats0', 'var') & ~isempty(stats0)
        t = stats0.t(end);
        step0 = stats0.step(end) + 1;
    else 
        stats0 = [];
        step0 = 1;
        if exist('E0', 'var')
            t = 0;
        end
    end
    step1 = step0 + prm.nstep - 1;
  
    % calculate ensemble anomalies
    %
    x = mean(E')';
    A = E - repmat(x, 1, m);

    if ~resumed
        if strcmp(prm.method, 'EnOI')
            %
            % for EnOI -- scale anomalies (once and forever)
            %
            A = prm.alpha * A;
            E = A + repmat(x, 1, m);
        end
    end

    if resumed & ~isempty(stats0)
        stats = stats0;

        % if this is a resumed run, stats.lasttime will have the value of 1 
        % perhaps, which may need to be corrected
        %
        stats.lasttime = floor(step1 / prm.assim_step) == floor(step0 / prm.assim_step);
    else
        %
        % calculate first forecast and analysis stats from the initial state
        %
        stats = calc_stats(prm, x_true, x, A, step0, step1, t, stats0);
        stats = calc_stats(prm, x_true, x, A, step0, step1, t, stats);
    end

    % store the restart step number and parameters for this restart
    %
    stats.prm = [stats.prm prm];
    stats.restart = [stats.restart step0];

    if prm.plot_diag
        stats.f_diag = plot_diag(prm, stats);
    end
    if prm.plot_prm
        f_prm = plot_prm(prm, stats, []);
    end
    if prm.plot_state
        stats.f_state = plot_state(prm, x_true, x, var(A'), [], [], stats);
    end
    if prm.plot_ens
        f_ens = plot_ens(prm, A, [], sprintf('Start-up, step = %d', stats.step(end)));
    end
  
    y = [];
    HE = [];
    pos = [];
    if prm.noasynchronous
        H = [];
    end
    
    % in case of permanent observation locations -- calculate H
    %
    if strcmp(prm.obs_spacing, 'regular')
        pos_now = get_pos(prm);
        H_now = calc_h(prm, pos_now);
    end
    
    % main cycle
    %
    if prm.verbose > 1
        fprintf('  main cycle:');
    end
    
    t_assim = 0;
    t_prop = 0;
    for step = step0 : step1

        % (i) propagate
        %
        switch prm.method
            
          case 'EnOI'
            % Sometimes "1" seems to work substantially better than "0",
            % sometimes the other way. Only "0" is consistent if we estimate
            % parameters.
            %
            tic;
            x = model_step(prm, x, t, 0);
            t_prop = t_prop + toc;
          
          otherwise
            % for other filters -- integrate the ensemble
            %
            tic;
            %x = (mean(E'))';
            %A = E - repmat(x, 1, m);
            %E = repmat(x, 1, m) + A / 10000;
            for e = 1 : m
                E(:, e) = model_step(prm, E(:, e), t, 0);
            end
            %x = (mean(E'))';
            %A = E - repmat(x, 1, m);
            %E = repmat(x, 1, m) + A * 10000;
            t_prop = t_prop + toc;
            
            if prm.plot_ens
                x = mean(E')';
                A = E - repmat(x, 1, m);
                plot_ens(prm, A, f_ens, sprintf('Model step, step = %d', stats.step(end)));
            end
        end
        
        % check the mean field
        %
        r = max(abs(x));
        if isnan(r) | r > 1e3
            if prm.verbose
                fprintf('\n    warning: main(): mean field: invalid magnitude at t = %f, step = %d\n', t, step);
                fprintf('    max(|x|) = %.3g\n', r);
                fprintf('    bailing out...\n');
            end
            break;
        end

        % integrate the true field; advance the time
        %
        [x_true, t] = model_step(prm, x_true, t, 1);
        
        % check the true field
        %
        r = max(abs(x_true(1 : prm.n - prm.nprm)));
        if isnan(r) | r > 1e3
            if prm.verbose
                fprintf('\n    warning: main(): true field: invalid magnitude at t = %f, step = %d\n', t, step);
                fprintf('    max(|x_true|) = %.3g\n', r);
                fprintf('    bailing out...\n');
            end
            break;
        end

        % (ii) make observations every prm.obs_step steps
        %
        % do not observe at the very first step when resuming the run because
        % there was an assimilation at the end of the previous run
        %
        if mod(step, prm.obs_step) == 0
            %
            % in case of time varying obs locations -- calculate H
            %
            if ~strcmp(prm.obs_spacing, 'regular')
                pos_now = get_pos(prm);
                H_now = calc_h(prm, pos_now);
            end
  
            % Restore the state of randn() after the previous call to get_obs().
            % The idea is to get the same observations regardless of other
            % differences between runs, e.g. regardless of the scheme used.
            %
            if ~isempty(stats.randn_obsstate)
                randn('state', stats.randn_obsstate);
            end

            % Normally y = H * x_true + noise. But if we want to model a biased
            % model behaviour, we need to add the bias to the model output... or
            % subtract it from the observations. The latter is simpler 
            % programatically. Also, making observations model dependent permits
            % easy tweaking of observations in a particular system, for example,
            % by making it non-uniform.
            %
            y_now = model_getobs(prm, t, x_true, H_now);
            
            % save the state of randn()
            %
            stats.randn_obsstate = randn('state');

            if strcmp(prm.method, 'EnOI')
                E = A + repmat(x, 1, m);
            end
            
            y = [y; y_now];

            if ~prm.noasynchronous
                %
                % Normally HE = H * E, but if we do bias correction, we may
                % need to modify the ensemble observations. Hence, getting
                % ensemble observations is made model dependent.
                %
                HE_now = model_getHE(prm, H_now, E);
                HE = [HE; HE_now];
            else
                H = [H; H_now];
            end
            pos = [pos; pos_now];
        end
        
        % (iii) assimilate every prm.assim_step model steps;
        %
        % do not assimilate at the very first step when resuming the run because
        % there was an assimilation at the end of the previous run
        %
        if mod(step, prm.assim_step) == 0
            
            if prm.noasynchronous
                %
                % all observations are assumed to be made right now, at the
                % analysis time
                %
                HE = model_getHE(prm, H, E);
                H = [];
            end
                
            % calculate ensemble anomalies if necessary
            %
            if ~strcmp(prm.method, 'EnOI')
                %
                % if not EnOI - calculate mean and anomalies
                %
                x = (mean(E'))';
                A = E - repmat(x, 1, m);
            end
            
            % calculate forecast stats
            %
            stats = calc_stats(prm, x_true, x, A, step, step1, t, stats);
            
            tic;
            if ~isempty(y) % there are obs
                %
                % assimilate
                %
                Hx = mean(HE')';
                dy = y - Hx;
                HA = HE - repmat(Hx, 1, m);
                
                [dx, A] = assimilate(prm, A, HA, pos, dy, stats);
            
                x = x + dx;
                if ~strcmp(prm.method, 'EnOI')
                    E = A + repmat(x, 1, m);
                end
            end
            t_assim = t_assim + toc;
            
            % calculate analysis stats
            %
            stats = calc_stats(prm, x_true, x, A, step, step1, t, stats);
            %
            % plot
            %
            if prm.plot_diag
                plot_diag(prm, stats);
            end
            if prm.plot_prm
                plot_prm(prm, stats, f_prm);
            end
            if prm.plot_state
                plot_state(prm, x_true, x, var(A'), pos, y, stats);
            end
            if prm.plot_ens
                plot_ens(prm, A, f_ens, sprintf('Analysis, step = %d', stats.step(end)));
            end
            
            % check for crash or "unrecoverable" divergence
            %
            if isnan(stats.rmse_a(1, end)) | (prm.rmse_max > 0 & stats.rmse_a(1, end) > prm.rmse_max)
                if prm.verbose
                    fprintf('\n    warning: main(): rmse = %.3g > rmse_max = %.3g at t = %f, step = %d\n', stats.rmse_a(1, end), prm.rmse_max, t, step);
                    fprintf('    bailing out...\n');
                end
                break;
            end
            
            y = [];
            HE = [];
            pos = [];
      
            if prm.verbose > 1
                fprintf('.');
            end
        end % assimilate
    end % step = step0 : step1
    
    if prm.verbose
        if prm.verbose > 1
            fprintf('\n');
        end

        % a fingerprint
        %
        i2 = length(stats.step);
        i1 = max(1, i2 - prm.plot_diag_np + 1);
        fprintf('  a fingerprint:\n', i2 - i1 + 1);
        fprintf('    <analysis rmse, step=%d-%d> = %.10g\n', stats.step(i1), stats.step(i2), mean(stats.rmse_a(1, i1 : i2)));
        fprintf('    <analysis spread, step=%d-%d> = %.10g\n', stats.step(i1), stats.step(i2), mean(stats.spread_a(1, i1 : i2)));
        fprintf('    <last analysis rmse> = %.10g\n', stats.rmse_a(end));
        fprintf('    <last analysis spread> = %.10g\n', stats.spread_a(end));
        fprintf('  assimilation time = %.3g\n', t_assim);
        fprintf('  propagation time = %.3g\n', t_prop);
    end
    
    % final state estimate
    %
    x = mean(E')';
    
    stats.rand_finalstate = rand('state');
    stats.randn_finalstate = randn('state');

    return
