%
% function [yend] = dp5step(f, h, y, prm)
%
% Conducts one integration step by Dorman-Prince method of 4(5) order.
%
% @param f - function for calculating derivatives, y1 = feval(f, y, prm)
% @param h - time step
% @param y - state vector (n x 1)
% @param F - a model parameter

% File:           dp5_step.m
%
% Created:        31/08/2007
%
% Last modified:  26/08/201
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Conducts one integration step by Dorman-Prince method of 4(5)
%                 order.
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

function [yend] = dp5step(f, h, y, F)

    if ~exist('F', 'var')
        F = NaN;
    end
    
    k1 = feval(f, y, F);
    k2 = feval(f, y + h * 0.2 * k1, F);
    k3 = feval(f, y + h * ((3 / 40) * k1 + (9 / 40) * k2), F);
    k4 = feval(f, y + h * ((44 / 45) * k1 - (56 / 15) * k2 + (32 / 9) * k3), F);
    k5 = feval(f, y + h * ((19372 / 6561) * k1 - (25360 / 2187) * k2 + (64448 / 6561) * k3 -(212 / 729) * k4), F);
    k2 = feval(f, y + h * ((9017 / 3168) * k1 - (355 / 33) * k2 + (46732 / 5247) * k3 + (49 / 176) * k4 - (5103 / 18656) * k5), F);
    yend = y + h * ((35 / 384) * k1 + (500 / 1113) * k3 + (125 / 192) * k4 - (2187 / 6784) * k5 + (11 / 84) * k2);
    
    return
