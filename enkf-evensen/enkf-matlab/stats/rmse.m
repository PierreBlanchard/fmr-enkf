% function[y] = rmse(x)
%
% For a vector, calculates root mean square error (deviation from zero). For
% a matrix, returns row vector of RMSE for each column.
%
% @param x - a vector or a matrix
% @return y - rmse (for a vector) or a row vector of RMSE for each column (for
%             a matrix

% File:           rmse.m
%
% Created:        30/07/2010
%
% Last modified:  30/07/2010
%
% Author:         Pavel Sakov
%                 NERSC
%
% Purpose:        Calculates RMSE.
%
% Description:    For a vector, calculates root mean square error (deviation
%                 from zero). For a matrix, returns row vector of RMSE for each
%                 column.Calculates RMSE.
%
% Revisions:      none

%% Copyright (C) 2010 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [y] = rmse(x)
    [n, m] = size(x);
    
    if n == 1 | m == 1
        y = sqrt(sum(x .^ 2) / length(x));
    else
        y = zeros(m, 1);
        for i = 1 : m
            y(i) = sqrt(sum(x(:, i) .^ 2) / n);
        end
    end
    
    return
