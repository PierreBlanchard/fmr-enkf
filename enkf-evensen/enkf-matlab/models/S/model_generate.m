% function [x_true, E, t] = model_generate(prm)
%
% Generates the initial ensemble for S model
%
% @param prm - system parameters
% @return x_true - true field
% @return E - ensemble
% @return t - time

% File:           model_generate.m
%
% Created:        31/08/2007
%
% Last modified:  18/02/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%
% Purpose:        Generates the initial ensemble for S model
%
% Description:    
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [x_true, E, t] = model_generate(prm)

    n = prm.n;
    nv = prm.n / prm.mult;
    m = prm.m;

    climatology = S_generate_sample(prm, prm.customprm.kstart_model, prm.customprm.kstep_model, prm.customprm.kend_model);
    x_true = S_generate_sample(prm, prm.customprm.kstart_true, prm.customprm.kstep_true, prm.customprm.kend_true);
    if prm.customprm.addref
        x_true = x_true + climatology;
    end
  
    %
    % ensemble
    %
    E = zeros(n, m);
    for i = 1 : m
        E(:, i) = S_generate_sample(prm, prm.customprm.kstart_model, prm.customprm.kstep_model, prm.customprm.kend_model);
    end
  
    if m > 1
        x = mean(E')';
    else
        x = E(:, 1);
    end
    E = E - repmat(x, 1, m);

    E = E + repmat(climatology, 1, m);
  
    t = 0;
  
    if prm.verbose
        fprintf('\n');
    end

    return
