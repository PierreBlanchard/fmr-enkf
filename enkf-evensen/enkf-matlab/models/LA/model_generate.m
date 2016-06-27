% function [x_true, E, t] = model_generate(prm)
%
% Generates the initial true field and ensemble for LA model
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
%
% Purpose:        Generates the initial true field and ensemble for LA model
%
% Description:    
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [x_true, E, t] = model_generate(prm)
  
    OFFSET = 6;

    n = prm.n;
    m = prm.m;

    %
    % reference field
    %
    climatology = LA_generate_sample(prm, prm.customprm.kstart_model, prm.customprm.kstep_model, prm.customprm.kend_model);
    climatology = climatology + OFFSET;

    %
    % true field
    %
    x_true = LA_generate_sample(prm, prm.customprm.kstart_true, prm.customprm.kstep_true, prm.customprm.kend_true);
    x_true = x_true + climatology;

    %
    % ensemble
    %
    E = zeros(n, m);
    for i = 1 : m
        E(:, i) = LA_generate_sample(prm, prm.customprm.kstart_model, prm.customprm.kstep_model, prm.customprm.kend_model);
    end
    if prm.verbose
        fprintf('\n');
    end
  
    if m > 1
        x = mean(E')';
    else
        x = E(:, 1);
    end
    E = E - repmat(x, 1, m);
  
    E = E + repmat(climatology, 1, m);
  
    t = 0;
  
    return
