% function [x] = S_step(prm, x)
%
% Conducts a step of S model.
%
% @param prm - model parameters
% @param x - state vector
% @return x - state vector

% File :          S_step.m
%
% Created:        31/08/2007
%
% Last modified:  18/01/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Conducts a step of S model.
%
% Description:    The state vector is consedered to contain two profiles
%                 (waves); this function propagates one profile by one node to
%                 the right, and another by one node to the left.
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [x1, t] = S_step(prm, x, t)
  
    n = prm.n;
    nv = n / prm.mult;
    
    x1 = zeros(n, 1);
  
    x1(2 : nv) = x(1 : nv - 1);
    x1(1) = x(nv, 1);

    x1(nv + 1 : n - 1) = x(nv + 2 : n);
    x1(n) = x(nv + 1);
  
    if exist('t', 'var')
        t = t + 1;
    end
  
    return
