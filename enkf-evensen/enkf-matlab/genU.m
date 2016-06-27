% function [U] = genU(m)
%
% Generates a random orthonormal mean-preserving matrix U:
%   U * U' = eye(m)
%   U * ones(m, 1) = zeros(m, 1)
%
% @param m - matrix dimension
% @return U - a random orthonormal mean-preserving matrix U (m x m)

% File:           genU.m
%
% Created:        31/08/2007
%
% Last modified:  08/02/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%
% Purpose:        Generates a random orthonormal mean-preserving matrix U:
%                   U * U' = eye(m)
%                   U * ones(m, 1) = zeros(m, 1)
%
% Description:    
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [U] = genU(m)
  
    v = ones(m, 1);
    [V, TMP] = svd(v);
    Rm1 = genR(m - 1);
    U = V * blkdiag(1, Rm1) * V';
  
    return
