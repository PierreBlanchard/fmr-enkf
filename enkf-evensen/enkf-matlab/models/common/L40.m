% function [y1] = L40(t, y, prm)
%
% Calculates derivative for L40 model.
%
% @param y - state vector
% @param F - magnitude of forcing
% @return y1 - vector of derivatives

% File :          L40.m
%
% Created:        31/08/2007
%
% Last modified:  26/08/2010
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Calculates derivative for L40 model.
%
% Description:
%
% Revisions:      26/08/2010 PS:
%                   - changed interface to make it also useable with L40p and
%                     L40b models

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [y1] = L40(y, F)

    n = length(y);
    y1 = zeros(n, 1);
    yp1 = zeros(n, 1);
    ym1 = zeros(n, 1);
    ym2 = zeros(n, 1);
  
    yp1(1 : n - 1) = y(2 : n);
    yp1(n) = y(1);
    ym1(2 : n) = y(1 : n - 1);
    ym1(1) = y(n);
    ym2(3 : n) = y(1 : n - 2);
    ym2(1 : 2) = y(n - 1 : n);
  
    y1 = (yp1 - ym2) .* ym1 - y + F;
  
    return
