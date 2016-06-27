% function [x_true, E, t] = model_generate(prm)
%
% Loads the initial ensemble for the L40p model
%
% @param prm - system parameters
% @return x_true - true field
% @return E - ensemble
% @return t - time

% File:           model_generate.m
%
% Created:        31/08/2007
%
% Last modified:  01/10/2009
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%
% Purpose:        Loads the initial ensemble for L40p model
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
    fname = prm.customprm.fname_samples;
    if ~exist(fname, 'file')
        fname = sprintf('%s/%s', prm.enkfmatlabdir, fname);
    end
    if ~exist(fname, 'file')
        error(sprintf('\n  error: could not find sample file \"%s\" or \"%s\"\n', prm.customprm.fname_samples, fname));
    end

    load(fname, 'n', 'n_sample', 'S', '-mat');
  
    if prm.n ~= n
        error(sprintf('\n  L40p: error: prm.n = %d; \"%s\": n = %d', prm.n, fname, n));
    end
  
    if prm.m > n_sample
        error(sprintf('\n  L40p: error: prm.m = %d; \"%s\": n_sample = %d', prm.m, fname, n_sample));
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
    Fmax = prm.customprm.Fmax;
    Fmin = prm.customprm.Fmin;
    T = prm.customprm.T;
    level = (Fmax + Fmin) / 2.0;
    ampl = (Fmax - Fmin) / 2.0;
    phase = asin((x_true(end) - level) / ampl);
    t = T * phase / 2 / pi;
  
    if prm.verbose
        fprintf('\n');
    end

    return
