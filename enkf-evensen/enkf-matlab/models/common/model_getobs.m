% function [y] = model_getobs(prm, t, x, H)
%
% "Generates" observations with specified variance at a given location from a
% given true field.
%
% @param prm - system parameters (structure)
% @param x - true field (n x 1)
% @param H - observation sensitivity matrix (p x n)
% @return y - vector of observations (p x 1)

% File:           model_getobs.m
%
% Created:        31/08/2007
%
% Last modified:  25/08/2010
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Last modified:
%
% Purpose:        "Generates" observations with specified variance at a given
%                 location from a given true field.
%
% Description:    
%
% Revisions:      25/08/2010 PS: Made it model dependent and moved to
%                   models/common directory

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [y] = model_getobs(prm, t, x, H)

    p = size(H, 1);
    variance = prm.obs_variance;
  
    y = H * x + randn(p, 1) * sqrt(variance);
  
    return
