% function [x] = LA_step(prm, x)
%
% Conducts a step of LA model.
%
% @param prm - model parameters
% @param x - state vector
% @return x - state vector

% File :          LA_step.m
%
% Created:        31/08/2007
%
% Last modified:  08/02/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Conducts a step of LA model.
%
% Description:
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [x1] = LA_step(prm, x)
  
    n = prm.n;
    x1 = zeros(n, 1);
    x1(2 : n) = x(1 : n - 1);
    x1(1) = x(n);
  
    return
