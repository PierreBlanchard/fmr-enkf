% function [y] = model_getobs(prm, t, x, H)
%
% Generates biased observations for L40b model. The bias value is supposed to 
% be stored in the last (additional) element of the state of the "true" field.
%
% @param prm - system parameters (structure)
% @param x - true field (n x 1)
% @param H - observation sensitivity matrix (p x n)
% @return y - vector of observations (p x 1)

% File:           get_obs.m
%
% Created:        25/08/2010
%
% Last modified:  25/08/2010
%
% Author:         Pavel Sakov
%                 NERSC
%
% Last modified:
%
% Purpose:        Generates biased observations for L40b model.
%
% Description:    
%
% Revisions:      None.

%% Copyright (C) 2010 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [y] = model_getobs(prm, t, x, H)

    p = size(H, 1);
    variance = prm.obs_variance;
  
    y = H * x + randn(p, 1) * sqrt(variance) + x(end);
  
    return
