% function [R] = calc_r(prm)
%
% Calculates observation error covariance matrix R
%
% @param prm - system parameters
% @param H - observation matrix
% @return R - observation error covariance matrix (p x p)

% File:           calc_r.m
%
% Created:        31/08/2007
%
% Last modified:  18/08/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%
% Purpose:        Calculates observation error covariance matrix R.
%
% Description:    Returns I * prm.obs_variance.
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [R] = calc_r(prm, H)

    p = size(H, 1);
    
    R = speye(p) * prm.obs_variance;
  
    return
