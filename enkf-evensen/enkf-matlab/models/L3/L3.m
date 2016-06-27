% function [y1] = L3(y, dummy)
%
% Calculates derivative for L3 model.
%
% @param y - state vector
% @param dummy - dummy parameter
% @return y1 - vector of derivatives

% File :          L3.m
%
% Created:        31/08/2007
%
% Last modified:  08/02/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%
% Purpose:        Calculates derivative for L3 model.
%
% Description:
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [y1] = L3(y, dummy)
    y1 = [0; 0; 0];

    y1(1) = 10.0 * (y(2) - y(1));
    y1(2) = (28.0 - y(3)) * y(1) - y(2);
    y1(3) = y(1) * y(2) - (8.0 / 3.0) * y(3);

    return
