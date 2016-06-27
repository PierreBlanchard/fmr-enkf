% function [x, t] = model_step(prm, x, t, true_field)
%
% Performs one step of S model.
%
% @param prm - system parameters
% @param x - state vector
% @param t - time
% @param true_field - flag, not used
% @return x - state vector
% @return t - time

% File:           model_step.m
%
% Created:        31/08/2007
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Performs one step of S model
%
% Description:    
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [x, t] = model_step(prm, x, t, true_field);

    x = S_step(prm, x, t);
    
    return
