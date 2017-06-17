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
%                 Pierre  Blanchard
%                 Inria Bordeaux, FRANCE
% Purpose:        Calculates observation error covariance matrix R.
%
% Description:    Returns I * prm.obs_variance, 
%                         if no correlation function specified.
%                 Returns a kernel matrix computed from pairwise distances of obs points
%                         if a correlation function is specified (Gauss, Expo,...)
%                 Use same routine as covariance localization for evaluation of correlation functions.
%
% Revisions:
%            07/06/2016 PB: Allow specifying correlation function for more realistic covariance matrix 
%                           The resulting obs error covariance is dense.

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [R] = calc_r(prm)

	% Get information on measurement error covariance
    n = prm.n;
    p = prm.p;
	obs_corr_function = prm.obs_correlation_function;
	obs_corr_length = prm.obs_correlation_length;

	% Get position of the observations
	pos=get_pos(prm);

	% Compute matrix of pairwise distances
	pair_dist=zeros(p,p);
    for i = 1 : p
        for j = 1 : p
        	dij=pos(i,:)-pos(j,:);
			pair_dist(i,j)=sqrt(dij*dij');
		end
	end

	% Evaluate correlation function on pairwise distances
	switch prm.obs_correlation_function
		case {'Gauss','Expo'}
            R = calc_loccoeffs(prm.obs_correlation_length,prm.obs_correlation_function,pair_dist);
		case 'None'
		    R = speye(p) * prm.obs_variance;
		otherwise
			disp('Please, provide a valid name for the correlation function!')
	end

	% Display RS
	R

    return
