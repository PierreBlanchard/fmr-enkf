% function [x_true, E, t] = model_generate(prm)
%
% Loads the initial ensemble for the L40b model
%
% @param prm - system parameters
% @return x_true - true field
% @return E - ensemble
% @return t - time

% File:           model_generate.m
%
% Created:        25/08/2010
%
% Last modified:  01/10/2009
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%
% Purpose:        Loads the initial ensemble for L40p model
%
% Description:    A copy of similar code from L40p.
%
% Revisions:      None

%% Copyright (C) 2010 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [x_true, E, t] = model_generate(prm)
  
    m = prm.m;
    fname = prm.customprm.fname_samples;
    if ~exist(fname, 'file')
        fname = sprintf('%s/%s', prm.enkfmatlabdir, fname);
    end
    if ~exist(fname, 'file')
        error(sprintf('\n  error: could not find sample file \"%s\" or \"%s\"\n', prm.customprm.fname_samples, fname));
    end

    load(fname, 'n', 'n_sample', 'S', '-mat');
  
    if prm.n ~= n
        error(sprintf('\n  L40b: error: prm.n = %d; \"%s\": n = %d', prm.n, fname, n));
    end
  
    if prm.m > n_sample
        error(sprintf('\n  L40b: error: prm.m = %d; \"%s\": n_sample = %d', prm.m, fname, n_sample));
    end
  
    if ~prm.randomise
        rand('state', prm.seed); % initialise to seed
    end    
  
    E = zeros(n, m);
    pool = shuffle(n_sample);

    x_true = S(:, pool(1));

    for i = 1 : m
        E(:, i) = S(:, pool(i + 1));
    end
    
    % Calculate the initial time to get the correct phase for the true field
    %
    T = prm.customprm.T;
    t = 0;
    
    x_true(end) = 0;
    E(end, :) = randn(1, m); % initial ensemble for the bias estimate
  
    if prm.verbose
        fprintf('\n');
    end

    return
