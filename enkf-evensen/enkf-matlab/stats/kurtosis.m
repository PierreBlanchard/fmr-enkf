% function[k] = kurtosis(X)
%
% Calculates kurtosis, similar to Matlab function from the statictical toolbox.
%
% @param X - a vector or a matrix considered as a set of column vectors
% @return k - kurtosis (a single value if X is a vector; a vector if X is a 
%             matrix)

% File:           kurtosis.m
%
% Created:        15/09/2009
%
% Last modified:  15/09/2009
%
% Author:         Pavel Sakov
%                 NERSC
%
% Purpose:        Calculates kurtosis
%
% Description:    Calculates kurtosis similar to Matlab function from the
%                 statictical toolbox.
%
% Revisions:

%% Copyright (C) 2009 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function[k] = kurtosis(X)
    
    if length(X) == 0
        k = NaN;
    elseif sum(size(X) > 1) == 1
        a = X - mean(X);
        k = sum(a .^ 4) / sum(a .^ 2) ^ 2 * length(X);
    else
        A = X - repmat(mean(X), size(X, 1), 1);
        k = sum(A .^ 4) ./ sum(A .^ 2) .^ 2 * size(X, 1);
    end
    
    return
