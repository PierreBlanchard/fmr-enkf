% function [x_true, E, t, prm] = generate(prm)
%
% Generates (reads) the initial true field and ensemble.
%
% @param prm - system parameters
% @return x_true - true field
% @return E - ensemble
% @return t - time
% @return prm - updated system parameters

% File:           generate.m
%
% Created:        31/08/2007
%
% Last modified:  16/09/2009
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%
% Purpose:        Generates (reads) the initial true field and ensemble.
%
% Description:    If prm.randomise = 0 and prm.read_ens = 1, this function
%                 first tries to read the ensemble from "samples/ens.mat". If
%                 unsuccessfull, starts generating ensemble in honest.
%                 If prm.randomise = 0, initialises RAND and RANDN to prm.seed.
%
% Revisions:      16/09/2009 PS: made `savefname' absolute using
%                   `prm.enkfmatlabdir'
%                 25/08/2010 PS: added the model tag to the saved parameters to
%                   trigger re-generation of "ens.mat" after switching between
%                   L40p and L40b (that have the same state size).

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [x_true, E, t, prm] = generate(prm)
    
    savefname = sprintf('%s/samples/ens.mat', prm.enkfmatlabdir);
  
    if ~prm.randomise & prm.read_ens & exist(savefname, 'file')
        if prm.verbose
            fprintf('  reading ensemble from \"%s\"...', savefname);
        end
        load(savefname, 'model', 'seed', 'x_true',  'E', 't', '-mat');
        [n, m] = size(E);
        if exist('model', 'var') & strcmp(model, prm.model) & n == prm.n & m >= prm.m & seed == prm.seed
            E = E(:, 1 : prm.m); % just in case
            if prm.verbose
                fprintf('done\n');
            end
            rand('state', prm.seed); % initialise to seed
            randn('state', prm.seed); % initialise to seed
            return;
        end
        if prm.verbose
            fprintf('\n  warning: ensemble in \"%s\" does not match parameters, regenerating...\n', savefname);
        end
    end
    
    if ~prm.randomise
        rand('state', prm.seed); % initialise to seed
        randn('state', prm.seed); % initialise to seed
        if prm.verbose
            fprintf('  seed = %d\n', prm.seed);
        end
    else
        seed = floor(rand * 1e+5);
        rand('state', seed); % initialise to seed
        randn('state', seed); % initialise to seed
        if prm.verbose
            fprintf('  seed = %d\n', seed);
        end
    end

    if prm.verbose == 1
        fprintf('  generating ensemble...');
    elseif prm.verbose == 2
        fprintf('  generating ensemble:');
    end
  
    [x_true, E, t] = model_generate(prm);

    if ~prm.randomise & prm.read_ens
        model = prm.model;
        seed = prm.seed;
        if prm.verbose
            fprintf('  saving ensemble to \"%s\"...', savefname);
        end
        save(savefname, 'model', 'seed', 'x_true', 'E', 't', '-mat');
        if prm.verbose
            fprintf('done\n');
        end
    end
  
    if ~prm.randomise
        rand('state', prm.seed); % initialise to seed
        randn('state', prm.seed); % initialise to seed
    else
        rand('state', seed); % initialise to seed
        randn('state', seed); % initialise to seed
    end

    return
