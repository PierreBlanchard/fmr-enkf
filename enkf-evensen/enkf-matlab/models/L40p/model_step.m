% function [x, t] = model_step(prm, x, t, true_field)
%
% Performs one step of L40p model.
%
% @param prm - system parameters
% @param x - state vector
% @param t - time
% @param true_field - flag, not used
% @return x - state vector
% @return t - time

% File:           model_step.m
%
% Created:        15/01/2008
%
% Last modified:  08/02/2008
%
% Author:         Pavel Sakov
%                 NERSC
%
% Purpose:        Performs one step of L40p model
%
% Description:    Set the flag prm.customprm.use_compiled to 0 or 1, to
%                 call the Matlab code or the compiled C code, respectively.
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [x, t] = model_step(prm, x, t, true_field);
  
    dt = prm.customprm.dt;
    
    if true_field
        Fmax = prm.customprm.Fmax;
        Fmin = prm.customprm.Fmin;
        T = prm.customprm.T;
        x(end) = (Fmax + Fmin) / 2.0 + (Fmax - Fmin) / 2.0 * sin(2 * pi * t / T);
    end
    
    if prm.customprm.use_compiled
        x(1 : end - 1) = L40_step_c(dt, x(1 : end - 1), x(end));
    else
        switch  prm.customprm.integrator
          case 'dp5'
            x(1 : end - 1) = dp5step(@L40, dt, x(1 : end - 1), x(end));
          case 'rk4'
            x(1 : end - 1) = rk4step(@L40, dt, x(1 : end - 1), x(end));
          otherwise
            error(sprintf('\n  error: unknown integrator: \"%s\"', prm.customprm.integrator));
        end
    end
    
    t = t + dt;
    
    return;
