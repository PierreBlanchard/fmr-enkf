% function [x_true, E, t] = model_generate(prm)
%
% Loads the initial ensemble for the QG model
%
% @param prm - system parameters
% @return x_true - true field
% @return E - ensemble
% @return t - time

% File:           model_generate.m
%
% Created:        31/08/2007
%
% Last modified:  08/02/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Loads the initial ensemble for the QG model
%
% Description:    Reads the true field and the ensemble from .mat files with
%                 dumps from a long model run. Those two can be different files
%                 (and that is how we usually run the system).
%
% Revisions:      01/10/2009 PS: 
%                 - added a check for the presence of sample file in the
%                   prm.enkfmatlabdir directory

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [x_true, E, t] = model_generate(prm)
  
    m = prm.m;
    fname_true = prm.customprm.fname_samples_true;
    if ~exist(fname_true, 'file')
        fname_true = sprintf('%s/%s', prm.enkfmatlabdir, fname_true);
    end
    if ~exist(fname_true, 'file')
        error(sprintf('\n  error: could not find sample file \"%s\" or \"%s\"\n', prm.customprm.fname_samples, fname_true));
    end
    fname_ens = prm.customprm.fname_samples_ens;
    if ~exist(fname_ens, 'file')
        fname_ens = sprintf('%s/%s', prm.enkfmatlabdir, fname_ens);
    end
    if ~exist(fname_ens, 'file')
        error(sprintf('\n  error: could not find sample file \"%s\" or \"%s\"\n', prm.customprm.fname_samples, fname_ens));
    end
  
    %
    % load the true field
    %
    load(fname_true, 'n', 'n_sample', 'S', '-mat');
    % S = S * 1e+4; % when working with older runs of the QG model
  
    if prm.n ~= n
        error(sprintf('\n  QG: error: %s: prm.n = %d; \"%s\": n = %d', fname_true, prm.n, fname, n));
    end
  
    if ~prm.randomise
        rand('state', prm.seed); % initialise to seed
    end
  
    pool = shuffle(n_sample);
    x_true = S(:, pool(1));
    if prm.verbose > 1
        fprintf('  taking sample #%d as the true field\n', pool(1));
    end

    %
    % load the ensemble
    %
    load(fname_ens, 'n', 'n_sample', 'S', '-mat');
    % S = S * 1e+4; % when working with older runs of the QG model
    
    if prm.n ~= n
        error(sprintf('\n  QG: error: %s: prm.n = %d; \"%s\": n = %d', fname_ens, prm.n, fname, n));
    end
  
    if prm.m > n_sample
        error(sprintf('\n  QG: error: prm.m = %d; \"%s\": n_sample = %d', prm.m, fname_ens, n_sample));
    end
    
    pool = shuffle(n_sample);
    E = zeros(n, m);
    for i = 1 : m
        E(:, i) = S(:, pool(i));
    end

    t = 0;
  
    return
