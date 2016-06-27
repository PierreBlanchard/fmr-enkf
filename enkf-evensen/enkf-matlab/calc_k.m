% function [K] = calc_k(prm, A, H, R, pos)
%
% Calculates the gain matrix K.
%
% @param prm - system parameters
% @param A - ensemble anomalies (n x m)
% @param H - observation interpolation matrix (p x n)
% @param R - observation error covariance matrix (p x p)
% @return K - gain matrix

% File:           calc_k.m
%
% Created:        31/08/2007
%
% Last modified:  01/10/2009
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Calculates the gain matrix K.
%
% Description:    Calculates the gain matrix K. When the localisation length
%                 prm.loc_len is specified (~= 0; ~isnan), uses gaussian
%                 localisation
% Revisions:      18/02/2008 PS: Changed interpretation of prm.mult. Was: number
%                   of model variables, with prm.n being the size of one
%                   variable; became: number of model variables, with prm.n
%                   being the size of the model state vector.
%                 24/04/2008 PS: Added second method of localisation based on
%                   scaling of observation error variance (like in LETKF)
%                 14/08/2008 PS: 
%                   - Calculate weights by calling calc_loccoeffs()
%                   - Now use "periodic" parameter for 1D models
%                 9/12/2008 PS:
%                   - Got rid of "observation scaling" localisation method.
%                     It is not consistent with localisation in a global
%                     framework, handled by this code (opposed to local
%                     framework, e.g. with LETKF)
%                 1/10/2009 PS:
%                   - Changed arguments to make possible the use with the 
%                     asyncronous DA

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [K] = calc_k(prm, A, HA, r, pos)

    [n, m] = size(A);
    p = size(HA, 1);

    np = prm.nprm;
    ns = n - np;
    mult = prm.mult;
    nv = ns / mult;
    nx = prm.nx;
    loclen = prm.loc_len;
  
    HPHT = HA * HA' / (m - 1);
    PHT = A * HA' / (m - 1);
    R = speye(size(HA, 1)) * r;
    
    if loclen == 0 | isnan(loclen) % no localisation

        K = PHT / (HPHT + R);
        
    else % localisation
        
        % masking HPH^T
        %
        if p > 1
            S = zeros(p, p);
            if nx <= 1 % 1D case
                pos = mod(pos - 1, nv) + 1; % to handle prm.observe = 'A&B' and 'B'
                for o = 1 : p
                    xo = pos(o);
                    dist = abs(pos(o : end) - xo);
                    if prm.periodic
                        dist = min(dist, nv - dist);
                    end
                    coeffs = calc_loccoeffs(loclen, prm.loc_function, dist);
                    S(o, o : end) = coeffs;
                    S(o, 1 : o - 1) = S(1 : o - 1, o);
                end
            else  % 2D case
                for o = 1 : p
                    xo = pos(o, 1);
                    yo = pos(o, 2);
                    dist = hypot(pos(o : end, 1) - xo, pos(o : end, 2) - yo);
                    coeffs = calc_loccoeffs(loclen, prm.loc_function, dist);
                    S(o, o : end) = coeffs;
                    S(o, 1 : o - 1) = S(1 : o - 1, o);
                end
            end
            HPHT = S .* HPHT;
        end % if p > 1
    
        % now masking PH^T
        %
        if nx <= 1 % 1D case
            grid = 1 : nv;
            if ~prm.periodic
                dist = grid - 1;
            else
                dist = min(grid - 1, nv + 1 - grid);
            end
            coeffs = calc_loccoeffs(loclen, prm.loc_function, dist);

            v = zeros(nv, 1);
            for o = 1 : p
                xo = round(pos(o));
                offset = 0;
                for k = 1 : mult
                    v(xo + offset : nv + offset) = coeffs(1 : nv + 1 - xo);
                    v(1 + offset : xo - 1 + offset) = coeffs(nv + 2 - xo : nv);
                    offset = offset + nv;
                end
                PHT(:, o) = PHT(:, o) .* v;
            end
        else % 2D case
            ny = nv / nx;
            if floor(ny) ~= nx
                error(sprintf('\n  EnKF: error: calc_k(): only square domains are currently handled in 2D cases\n'));
            end

            I = zeros(nx, ny);
            for i = 1 : nx
                I(i, :) = i;
            end
            J = zeros(nx, ny);
            for j = 1 : ny
                J(:, j) = j;
            end

            for o = 1 : p
                xo = pos(o, 1);
                yo = pos(o, 2);
                D = hypot(I - xo, J - yo);
                dist = reshape(D, nv, 1);
                coeffs = calc_loccoeffs(loclen, prm.loc_function, dist);
                PHT(:, o) = PHT(:, o) .* coeffs;
            end
        end

        K = PHT / (HPHT + R);
    end
  
    return
