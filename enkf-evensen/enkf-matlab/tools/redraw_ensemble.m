% function [Anew] = redraw_ensemble(A, mnew, random)
%
% Redraws ensemble from size `m' to size `mnew' in the best possible way to
% preserve the covariance associated with the ensemble.
% This is a lossless (in terms of the associated covariance) transformation if
% mnew > m; and lossy (generally) if mnew < m.
%
% n = size(P, 1);
% A = redraw_ensemble(sqrtm(P * (n - 1)), rank(P) + 1, 0);
%
% @param A - old ensemble
% @param mnew - new ensemble size
% @param random - a flag, whether to use a deterministic or randomised
%                 transformation (default = 1)
% @return Anew - new ensemble

% File:           trancate_ensemble.m
%
% Created:        2006 or 2007
%
% Last modified:  13/08/2008
%
% Author:         Pavel Sakov
%                 NERSC
%                 CSIRO Marine and Atmospheric Research
%
% Purpose:         Redraws ensemble from size `m' to size `mnew' in the best
%                  possible way to preserve the covariance associated with the
%                  ensemble _and_ to ensure/preserve zero ensemble mean.
%
%                  Can be used to generate a zero-centered ensemble from a
%                  non-zero-centered ensemble (for a full rank ensemble,
%                  increase the ensemble size by 1). E.g., given A:
%                    [n, m] = size(A);
%                    A1 = redraw_ensemble(A, m + 1);
%                  then
%                    || A * A' / (m - 1) - A1 * A1' / m || = 0
%                  and
%                    || A1 * ones(m, 1) || = 0
%
%                  Also can be used to generate a zero-centered ensemble from
%                  a given covariance. E.g., given P:
%                    n = size(P, 1);
%                    m = rank(P);
%                    [U, L] = svd(P * (m - 1));
%                    Atmp = U(:, 1 : m) * sqrt(L(1 : m, 1 : m));
%                    A = redraw_ensemble(Atmp, m + 1);
%                  Or:
%                    A = redraw_ensemble(sqrtm(P * (n - 1)), m + 1, 0);
%                  then
%                    || A * A' / m - P || = 0
%                    || A * ones(m + 1, 1) || = 0
%
% Description:     
%
% Revisions:       17/03/2008 PS changed name from "truncate_ensemble" to
%                    "redraw_ensemble".

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [Anew] = redraw_ensemble(A, mnew, random)
  
    [n, m] = size(A);
    
    if ~exist('random', 'var')
        random = 1;
    end
  
    m_sqrt = sqrt(mnew);
    Q = eye(mnew - 1) - ones(mnew - 1, mnew - 1) / (m_sqrt * (m_sqrt + 1));
    Q = [Q, -ones(mnew - 1, 1) / m_sqrt];
    if random
        [R, TMP] = qr(randn(mnew - 1, mnew - 1));
        Q = R * Q;
    end
    Q = [Q; -ones(1, mnew) / m_sqrt]; 

    [U, L] = svd(A, 0);
  
    mnmin = min([mnew, n, m]);
    if mnmin == mnew
        L(mnmin, mnmin) = 0; % to ensure that Anew iz zero-centered
    end
  
    L = diag(diag(L) * sqrt((mnew - 1) / (m - 1)));
  
    if 0
        s1 = size(U(:, 1 : mnmin));
        s2 = size([L(1 : mnmin, 1 : mnmin), zeros(mnmin, mnew - mnmin)]);
        s3 = size(Q);
        fprintf('  we multiply (%d x %d) x (%d x %d) x (%d x %d)\n', s1(1), s1(2), s2(1), s2(2), s3(1), s3(2));
    end

    Anew = U(:, 1 : mnmin) * [L(1 : mnmin, 1 : mnmin), zeros(mnmin, mnew - mnmin)] * Q;
 
    return
