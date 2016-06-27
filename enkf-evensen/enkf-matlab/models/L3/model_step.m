% function [x, t] = model_step(prm, x, t, true_field)
%
% Performs one step of L3 model.
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
% Last modified:  08/02/2007
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Performs one step of L3 model
%
% Description:    Set the flag prm.customprm.use_compiled to 0 or 1, to
%                 call the Matlab code or the compiled C code, respectively.
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [x, t] = model_step(prm, x, t, true_field)

    dt = prm.customprm.dt;

    if prm.customprm.use_compiled
        x = L3_step_c(dt, x);
    else
        switch prm.customprm.integrator
          case 'dp5'
            x = dp5step(@L3, dt, x);
          case 'rk4'
            x = rk4step(@L3, dt, x);
          otherwise
            error(sprintf('\n  L3: error: unknown integrator: \"%s\"', prm.customprm.integrator));
        end
    end
    
    t = t + dt;
    
    return
