% function [x, t] = model_step(prm, x, t, true_field)
%
% Performs one step of L40 model.
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
% Last modified:  08/02/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Performs one step of L40 model
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
    F = prm.customprm.F;
    
    if prm.customprm.use_compiled
        x = L40_step_c(dt, x, F);
    else
        switch  prm.customprm.integrator
          case 'dp5'
            x = dp5step(@L40, dt, x, F);
          case 'rk4'
            x = rk4step(@L40, dt, x, F);
          otherwise
            error(sprintf('\n  error: unknown integrator: \"%s\"', prm.customprm.integrator));
        end
    end
    
    t = t + dt;
    
    return;
