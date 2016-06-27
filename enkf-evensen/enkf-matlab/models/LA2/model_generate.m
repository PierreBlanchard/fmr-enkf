% function [x_true, E, t] = model_generate(prm)
%
% Generates the initial true field and ensemble for LA2 model
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
% Purpose:        Generates the initial true field and ensemble for LA2 model
%
% Description:    
%
% Revisions:      PS 18/02/2008 Changed interpretation of prm.mult. Was: number
%                 of model variables, with prm.n being the size of one
%                 variable; became: number of model variables, with prm.n
%                 being the size of the model state vector.

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [x_true, E, t] = model_generate(prm)

    OFFSET_A = 6;
    OFFSET_B = 0.5;
    MULT_B = 10;
  
    n = prm.n;
    nv = n / 2;
    m = prm.m;

    %
    % true field
    % (generate sample here to ensure that the true field would not depend on
    % settings for the model fields; set addref = 0 if you want this feature)
    %
    x_true = LA2_generate_sample(prm, prm.customprm.kstart_true, prm.customprm.kstep_true, prm.customprm.kend_true);

    %
    % reference field
    %
    climatology = LA2_generate_sample(prm, prm.customprm.kstart_model, prm.customprm.kstep_model, prm.customprm.kend_model);
    climatology(1 : nv) = climatology(1 : nv) + OFFSET_A;
    climatology(nv + 1 : n) = climatology(nv + 1 : n) * MULT_B + OFFSET_B;

    %
    % true field
    %
    if prm.customprm.addref
        x_true(nv + 1 : n) = x_true(nv + 1 : n) * MULT_B;
        x_true = x_true + climatology;
    else
        x_true(1 : nv) = x_true(1 : nv) + OFFSET_A;
        x_true(nv + 1 : n) = x_true(nv + 1 : n) * MULT_B + OFFSET_B;
    end

    E = zeros(n, m);
  
    for i = 1 : m
        E(:, i) = LA2_generate_sample(prm, prm.customprm.kstart_model, prm.customprm.kstep_model, prm.customprm.kend_model);
    end

    E(nv + 1 : n, :) = E(nv + 1 : n, :) * MULT_B;
  
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
