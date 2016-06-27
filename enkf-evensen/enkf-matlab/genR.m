% function [R] = genR(m)
%
% Generates a random orthonormal matrix R:
%   R * R' = eye(m)
%
% @param m - matrix dimension
% @return R - a random orthonormal matrix R (m x m)

% File:           genR.m
%
% Created:        21/08/2007
%
% Last modified:  21/02/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%
% Purpose:        Generates a random orthonormal mean-preserving matrix U:
%                   R * R' = eye(m)
%
% Description:    
%
% Revisions:      25.10.2011 PS:
%                   Save and restore the randn() state.

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [R] = genR(m)
    
    randn_state =  randn('state');

    [R, R1] = qr(randn(m, m));
    for i = 1 : m
        if R1(i, i) < 0
            R(:, i) = -R(:, i);
        end
    end
    
    randn('state', randn_state); 

    return
