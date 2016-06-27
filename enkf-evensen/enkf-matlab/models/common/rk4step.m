% function [yend] = rk4step(f, h, y, F)
%
% Performs one integration step of ODE system by Runge-Kutta method of the 4th
% order.
%
% @param f - function: y' = f(x, y).
% @param h - time step
% @param y - initial state vector
% @param F - a model parmater
% @return yend - final state vector

% File:           rk4step.m
%
% Created:        31/08/2007
%
% Last modified:  26/08/2010
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Performs one integration step of ODE system by Runge-Kutta
%                 method of the 4th order.
%
% Description:
%
% Revisions:      26/08/2010 PS:
%                   - simplified interface to f (now taylored to L40 and its
%                     modifications)

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [yend] = rk4step(f, h, y, F)
  
    if ~exist('F', 'var')
        F = NaN;
    end
    
    k1 = h * feval(f, y, F);
    k2 = h * feval(f, y + 0.5 * k1, F);
    k3 = h * feval(f, y + 0.5 * k2, F);
    k4 = h * feval(f, y + k3, F);

    yend = y + (k1 + 2 * (k2 + k3) + k4) / 6;
  
    return
