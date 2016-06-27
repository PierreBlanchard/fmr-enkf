% function [dx, A] = assimilate(prm, A, HA, pos, dy, stats)
%
% Calculates correction of the ensemble mean and updates the ensemble anomalies.
%
% @param prm - system parameters
% @param A - ensemble anomalies (n x m)
% @param HA - ensemble observations (p x m)
% @param pos - coordinates of observations (p x 1)
% @param dy - vector of increments, dy = y - Hx (p x 1)
% @param stats - system statistics
% @return dx - correction of the mean dx = K dy
% @return A - updated ensemble anomalies

% File:           assimilate.m
%
% Created:        23/03/2009
%
% Last modified:  13/05/2011
%
% Author:         Pavel Sakov
%                 NERSC
%
% Purpose:        Contains core code for asynchronous data assimilation with the
%                 EnKF.
%
% Description:    This procedure calculates the analysis correction and updates
%                 the ensemble by applying scheme specified by prm.method.
%                 It assumes that the system runs in the asynchronous regime,
%                 i.e. that both increments `dy' and ensemble observations `HA'
%                 contain values recorded at the time of observations.
%                 There are some differences with the assimilate.m that handles
%                 synchronous observations:
%                 (i) There are no batches of observations anymore. If there
%                     are too many observations - one can always use LA 
%                     localisation and conduct analysis in the ensemble space
%                 (ii) Not all schemes are available for every localisation
%                     method. Following are the lists of available schemes for 
%                     each method.
%                     * With no localisation or with LA:
%                       EnKF
%                       DEnKF
%                       ETKF
%                       Potter
%                       EnOI
%                     * With CF:
%                       EnKF
%                       DEnKF
%                       EnOI
%
% Revisions:      1.10.2009 PS:
%                   -- Fixed a defect in the EnKF scheme (an extra division by
%                      sqrt(r) for D)
%                   -- Introduced CF localisation, with only three schemes at
%                      the moment: EnKF, DEnKF and EnOI
%                 19.11.2009 PS:
%                   -- Updated description in the file header
%                 5.8.2010 PS:
%                   -- Modified LA part to accommodate "rfactor"
%                 25/08/2010 PS:
%                   - This file, formerly known as assimilate_a.m, now replaced
%                     the previous (synchronous) version of assimilate.m
%                 20.04.2011 PS:
%                   - Replaced "rfactor" by "rfactor2"; also introduced
%                     "rfactor1"
%                 2.5.2011 PS:
%                   - Put wrappers around lines with generation of perturbed
%                     obs to save/restore the state of the generator
%                 2.13.2011 PS:
%                   - Added adaptive observation prescreening ("kfactor")

%% Copyright (C) 2009 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [dx, A] = assimilate(prm, A, HA, pos, dy, stats)
    
    m = prm.m;
    n = prm.n;
    r = prm.obs_variance * prm.rfactor1;
    rfactor = prm.rfactor2;
    kfactor = prm.kfactor;
    p = size(HA, 1);
    np = prm.nprm;
    ns = n - np;

    if p < 1
        dx = zeros(n, 1);
        return
    end
    
    % We now follow
    %
    %   Sakov, P., G. Evensen, and L. Bertino (2010): Asynchronous data
    %   assimilation with the EnKF. Tellus 62A, 24-29.
    %
    % We start with calculating standardised innovation and ensemble anomalies 
    %
    if kfactor == 0 | isnan(kfactor) % normal case; no adaptive pre-screening
        s = dy / sqrt(r * (m - 1));
        S = HA / sqrt(r * (m - 1));
    else
        obsvar = zeros(p, 1) + r;
        ensvar = var(HA')';
        r = sqrt((obsvar + ensvar) .^ 2 + (ensvar .* dy .^ 2 / kfactor ^ 2)) - ensvar;
        s = dy ./ sqrt(r) / sqrt(m - 1);
        S = HA ./ repmat(sqrt(r), 1, m) / sqrt(m - 1);
    end
    
    % calculate global perturbations of observations for the EnKF
    %
    if strcmp(prm.method, 'EnKF')
        %
        % (save and then restore the state of the gaussian random number
        % generator, so that using the traditional EnKF does not affect
        % anything else)
        %
        randn_obsstate = randn('state');
        D = randn(p, m) / (rfactor * sqrt(m - 1));
        randn('state', randn_obsstate);        
        d = mean(D')';
        D = sqrt(m / (m - 1)) * (D - repmat(d, 1, m));
    end
        
    % Following are 3 main branches:
    %   - no localisation (global analysis)
    %   - local analysis
    %   - covariance localisation (also known as covariance filtering)

    % no localisation (global analysis)
    %
    if prm.loc_len == 0 | isnan(prm.loc_len)
        if strcmp(prm.method, 'ETKF')
            M = inv(speye(m) + S' * S);
            G = M * S';
        elseif m <= p
            G = inv(speye(m) + S' * S) * S';
        else
            G = S' * inv(speye(p) + S * S');
        end
        
        dx = A * G * s;
        
        if rfactor ~= 1 & ~strcmp(prm.method, 'EnOI')
            S = S / sqrt(rfactor);
            if strcmp(prm.method, 'ETKF')
                M = inv(speye(m) + S' * S);
                G = M * S';
            elseif m <= p
                G = inv(speye(m) + S' * S) * S';
            else
                G = S' * inv(speye(p) + S * S');
            end
        end
        
        switch prm.method
          case 'EnKF'
            A = A * (speye(m) + G * (D - S));
          case 'DEnKF'
            A = A * (speye(m)- 0.5 * G * S);
          case 'ETKF'
            A = A * sqrtm(M);
          case 'Potter'
            T = eye(m);
            for o = 1 : p
                So = S(o, :);
                SSo = So * So' + 1;
                To = So' * (So / (SSo + sqrt(SSo)));
                S = S - S * To;
                T = T - T * To;
            end
            A = A * T;
          case 'EnOI'
            % do nothing
          otherwise
            error(sprintf('\n  EnKF: error: assimilate(): method \"%s\" is not defined for the asyncronous EnKF', prm.method));
        end

    % local analysis
    %
    elseif strcmp(prm.loc_method, 'LA')
        %
        % Note that we only have to pass A in the arguments because of the local
        % analysis... In practice, with a large-scale system... this can perhaps
        % be avoided by reading, updating, and then writing back slabs from
        % NetCDF data files.
        %
        dx = zeros(n, 1);
        for i = 1 : n
            [localobs, coeffs] = find_localobs(prm, i, pos);
            ploc = length(localobs);
            if ploc == 0
                continue
            end
            
            Sloc = S(localobs, :) .* repmat(coeffs, 1, m);
            
            if strcmp(prm.method, 'ETKF')
                M = inv(speye(m) + Sloc' * Sloc);
                Gloc = M * Sloc';
            elseif m <= ploc
                Gloc = inv(speye(m) + Sloc' * Sloc) * Sloc';
            else
                Gloc = Sloc' * inv(speye(ploc) + Sloc * Sloc');
            end
            
            dx(i) = A(i, :) * Gloc * (s(localobs) .* coeffs);
            
            if strcmp(prm.method, 'EnOI')
                continue
            end

            if rfactor ~= 1
                Sloc = Sloc / sqrt(rfactor);
                if strcmp(prm.method, 'ETKF')
                    M = inv(speye(m) + Sloc' * Sloc);
                elseif m <= ploc
                    Gloc = inv(speye(m) + Sloc' * Sloc) * Sloc';
                else
                    Gloc = Sloc' * inv(speye(ploc) + Sloc * Sloc');
                end
            end
            
            switch prm.method
              case 'EnKF'
                Dloc = D(localobs, :) .* repmat(coeffs, 1, m);
                A(i, :) = A(i, :) + A(i, :) * Gloc * (Dloc - Sloc);
              case 'DEnKF'
                A(i, :) = A(i, :) - A(i, :) * 0.5 * Gloc * Sloc;
              case 'ETKF'
                A(i, :) = A(i, :) * sqrtm(M);
              case 'Potter'
                %
                % Using the Potter scheme with local analysis makes little sense
                % perhaps because we now have two cycles: over the state vector
                % elements and within it - over observations; and this is
                % expensive. So it is here just for completeness or research
                % purposes.
                %
                for o = 1 : ploc
                    So = Sloc(o, :);
                    SSo = So * So' + 1;
                    To = So' * (So / (SSo + sqrt(SSo)));
                    Sloc = Sloc - Sloc * To;
                    A(i, :) = A(i, :) - A(i, :) * To;
                end
                %
                % operationally it may be better to use the following code
                % instead, but it performs marginally slower with this package
                %
                % T = eye(m);
                % for o = 1 : ploc
                %    So = Sloc(o, :);
                %    SSo = So * So' + 1;
                %    To = So' * (So / (SSo + sqrt(SSo)));
                %    Sloc = Sloc - Sloc * To;
                %    T = T - T * To;
                % end
                % A(i, :) = A(i, :) * T;

              otherwise
                error(sprintf('\n  EnKF: error: assimilate(): method \"%s\" is not supported for the asynchronous EnKF with prm.loc_method = \"%s\"', prm.method, prm.loc_method));
            end
        end
        
    % covariance filtering (covariance localisation)
    %
    elseif strcmp(prm.loc_method, 'CL') | strcmp(prm.loc_method, 'CF')

        K = calc_k(prm, A, HA, r, pos);
        dx = K * dy;
        
        if rfactor ~= 1 & ~strcmp(prm.method, 'EnOI')
            K = calc_k(prm, A, HA, r * rfactor, pos);
        end

        switch prm.method
          case 'EnKF'

            % (save and then restore the state of the gaussian random number
            % generator,  so that using the traditional EnKF does not affect
            % anything else)
            %
            randn_obsstate = randn('state');
            D = randn(p, m) * sqrt(r * rfactor);
            randn('state', randn_obsstate);        

            % Subtract the ensemble mean from D to ensure that update of the
            % anomalies does not perturb the ensemble mean. This reduces the
            % variance of each sample by a factor of 1 - 1/m (I think).
            %
            d = mean(D')';
            D = sqrt(m / (m - 1)) * (D - repmat(d, 1, m));
            
            A = A + K * (D - HA);
          
          case 'DEnKF'
            %
            % DEnKF - "Deterministic EnKF", do not confuse with "Double
            % EnKF". No perturbed observations, half gain.

            A = A - 0.5 * K * HA;
            
          % case 'Potter'
          
            % Oops! After modifying this code to handle asynchronous
            % observations I have found no good way to do Potter ("EnSRF")
            % scheme with CF so far...
          
          % case 'ESRF'
          
            % ditto left-multiplied ESRF
            
          case 'EnOI'
      
            % do nothing
      
          otherwise
            
            error(sprintf('\n  EnKF: error: assimilate(): method \"%s\" is not handled with asynchronous observations', prm.method));
            
        end % switch method
            
    else
        error(sprintf('\n  EnKF: error: assimilate(): prm.loc_method = \"%s\" is not suported', prm.loc_method));
    end
    
    if ~strcmp(prm.method, 'EnOI')

        % inflate "normal" (observed) elements
        %
        if prm.inflation ~= 1
            A(1 : ns, :) = A(1 : ns, :) * prm.inflation;
        end

        % inflate unobserved elements ("parameters")
        %
        if prm.inflation_prm ~= 1
            A(ns + 1 : end, :) = A(ns + 1 : end, :) * prm.inflation_prm;
        end

        % randomly rotate the ensemble every prm.rotate steps
        %
        if prm.rotate & mod(stats.step(end), prm.rotate) == 0 & prm.rotate_ampl ~= 0
            if prm.rotate_ampl == 1
                A(1 : ns, :) = A(1 : ns, :) * genU(m);
            else
                A(1 : ns, :) = A(1 : ns, :) * genUeps(m, prm.rotate_ampl);
            end
        end
    end

    return
