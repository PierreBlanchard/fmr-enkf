% function [x, t] = model_step(prm, x, t, true_field)
%
% Performs one step of L40b model.
%
% @param prm - system parameters
% @param x - state vector
% @param t - time
% @param true_field - flag, not used
% @return x - state vector
% @return t - time

% File:           model_step.m
%
% Created:        25/08/2010
%
% Last modified:  25/08/2010
%
% Author:         Pavel Sakov
%                 NERSC
%
% Purpose:        Performs one step of L40b model
%
% Description:    Set the flag prm.customprm.use_compiled to 0 or 1, to
%                 call the Matlab code or the compiled C code, respectively.
%
% Revisions:

%% Copyright (C) 2010 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [x, t] = model_step(prm, x, t, true_field);
  
    dt = prm.customprm.dt;
    F = prm.customprm.F;
    
    if true_field
        x(end) = sin(2 * pi * t / prm.customprm.T);
        % (this is the true value of model bias, entered here to communicate to
        % the plotting and diagnostic procedures)
    end
    
    if prm.customprm.use_compiled
        x(1 : end - 1) = L40_step_c(dt, x(1 : end - 1), F);
    else
        switch  prm.customprm.integrator
          case 'dp5'
            x(1 : end - 1) = dp5step(@L40, dt, x(1 : end - 1), F);
          case 'rk4'
            x(1 : end - 1) = rk4step(@L40, dt, x(1 : end - 1), F);
          otherwise
            error(sprintf('\n  error: unknown integrator: \"%s\"', prm.customprm.integrator));
        end
    end
    
    t = t + dt;
    
    return;
