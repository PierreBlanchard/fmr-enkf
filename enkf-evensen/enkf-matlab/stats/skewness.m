% function[k] = skewness(X)
%
% Calculates skewness, similar to Matlab function from the statictical toolbox.
%
% @param X - a vector or a matrix considered as a set of column vectors
% @return k - skewness (a single value if X is a vector; a vector if X is a 
%             matrix)

% File:           skewness.m
%
% Created:        15/09/2009
%
% Last modified:  15/09/2009
%
% Author:         Pavel Sakov
%                 NERSC
%
% Purpose:        Calculates skewness
%
% Description:    Calculates skewness similar to Matlab function from the
%                 statictical toolbox.
%
% Revisions:

%% Copyright (C) 2009 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function[k] = skewness(X)
    
    if length(X) == 0
        k = NaN;
    elseif sum(size(X) > 1) == 1
        k = sum(a .^ 3) / sum(a .^ 2) ^ 1.5 * length(X) ^ 0.5;
    else
        A = X - repmat(mean(X), size(X, 1), 1);
        k = sum(A .^ 3) ./ sum(A .^ 2) .^ 1.5 * size(X, 1) ^ 0.5;
    end
    
    return
