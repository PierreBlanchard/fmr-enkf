% function [x] = LA_step(prm, x)
%
% Conducts a step of LA2 model.
%
% @param prm - model parameters
% @param x - state vector
% @return x - state vector

% File :          LA2_step.m
%
% Created:        31/08/2007
%
% Last modified:  18/02/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Conducts a step of LA2 model.
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

function [x1] = LA2_step(prm, x)
  
    n = prm.n;
    ns = n / 2;
    
    x1 = zeros(n, 1);
    x1(2 : ns) = x(1 : ns - 1);
    x1(1) = x(ns);
    x1(ns + 2 : n) = x(ns + 1 : n - 1);
    x1(ns + 1) = x(n);
  
    return
