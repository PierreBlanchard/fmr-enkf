% function [y] = get_obs(prm, x, H)
%
% "Generates" observations with specified variance at a given location from a
% given true field.
%
% @param prm - system parameters (structure)
% @param x - true field (n x 1)
% @param H - interpolation matrix (p x n)
% @return y - vector of observations (p x 1)

% File:           get_obs.m
%
% Created:        31/08/2007
%
% Last modified:  08/02/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%
% Last modified:
%
% Purpose:        "Generates" observations with specified variance at a given
%                 location from a given true field.
%
% Description:    
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [y] = get_obs(prm, x, H, sqrt_of_R)

    p = size(sqrt_of_R, 1);

	% Compute perturbation 
	% ... apply SQRT of covariance matrix to white noise
	epsilon_y = sqrt_of_R * randn(p, 1);			
	
	% Add perturbation
    y = H * x + epsilon_y;
  
    return
