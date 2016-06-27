% function [obs, coeffs] = find_localobs(prm, i, pos, eps)
%
% Finds local observations and taper coefficients.
%
% @param prm - system parameters
% @param i - index of state vector element
% @param pos - positions of all observations
% @param eps - (optional) discrepancy: observations is local if its localisation
%              coefficient is greater than eps
% @return obs - indices of local observations
% @return coeffs - localisation coefficients for the local observations

% File:           find_localobs.m
% 
% Created:        18/03/2008
%
% Last modified:  3/8/2009
%
% Author:         Pavel Sakov
%                 NERSC
%
% Description:    Finds local observations and taper coefficients.
%
% Revisions:      16/06/2008 PS A bug fix: became z = 0.5 * dist2 / loc2
%                   instead of z = 0.5 * dist2 / loc.
%                 20/12/2009 PS Changed the interface: now returns not only
%                   the local observations but also the weights for ensemble
%                   tapering.
%                 3/8/2009 PS: Synced description with reality.

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [obs, coeffs] = find_localobs(prm, i, pos, eps)
    
    if ~exist('eps', 'var')
        eps = 1.0e-3;
    end
    
    nv = (prm.n - prm.nprm) / prm.mult;
    nx = prm.nx;
    ns = prm.n - prm.nprm;
    
    % Assume that mult = 1 and np = 0 for now
    %
    if prm.mult ~= 1
        error(sprintf('\n  find_localobs(): mult = %d: mult > 1 is not handled yet', prm.mult));
    end
    
    if prm.loc_len ~= 0 & ~isnan(prm.loc_len) & i <= ns
        if nx <= 1 % 1D case
            dist = abs(pos - i);
            if prm.periodic
                dist = min(dist, nv - dist);
            end
            coeffs = calc_loccoeffs(prm.loc_len, prm.loc_function, dist);
        else  % 2D case
            ii = mod(i - 1, nx) + 1;
            jj = floor((i - 1) / nx) + 1;
            dist = hypot(ii - pos(:, 1), jj - pos(:, 2));
            coeffs = calc_loccoeffs(prm.loc_len, prm.loc_function, dist);
            end
            obs = find(coeffs > eps);
            coeffs = coeffs(obs);
    else
        obs = [1 : prm.p]';
        coeffs = ones(size(obs));
    end
    
    return
