% function [H] = calc_h(prm, pos)
%
% Calculates observation interpolation matrix H from observation coordinates.
%
% @param prm - system parameters
% @param pos - vector (p x 1) of coordinates of p observations in grid space
% @return H - observation interpolation matrix (p x n)

% File:           calc_h.m
%
% Created:        31/08/2007
%
% Last modified:  19/08/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Given the coordinates of observations, calculates matrix 
%                 H that maps the system state x to the vector of observations
%                 O: O = H * x
%
% Description:
%
% Revisions:      18/02/2008 PS: Changed interpretation of prm.mult. Was: number
%                 of model variables, with prm.n being the size of one
%                 variable; became: number of model variables, with prm.n
%                 being the size of the model state vector.

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [H] = calc_h(prm, pos)
  
    n = prm.n;
    np = prm.nprm;
    mult = prm.mult;
    nv = (n - np) / mult;
    p = size(pos, 1);
    nx = prm.nx;
  
    H = spalloc(p, n, p * 4);
    %
    % '* 4' - to handle bilinear 2D interpolation
    % (should be expanded if a need to handle 2D cases observing A&B occurs)
  
    if prm.mult == 1 | strcmp(prm.observe, 'A') | strcmp(prm.observe, 'B') | strcmp(prm.observe, 'A&B')
        for i = 1 : p
            pp = pos(i, :);
            if (nx <= 1) % 1D case
                if (pp == floor(pp))
                    H(i, pp) = 1;
                else
                    frac = pp - floor(pp);
                    pp = floor(pp);
                    offset = floor((pp - 1) / nv) * nv; % to handle pp > nv
                    pp1 = mod(pp, nv) + 1 + offset;
                    H(i, pp) = 1 - frac;
                    H(i, pp1) = frac;
                end
            else % 2D case
                px = floor(pp(1));
                py = floor(pp(2));
                fx = pp(1) - px;
                fy = pp(2) - py;
                py = py - 1; % for convenience
                if fx ~= 0 & fy ~= 0
                    H(i, px + py * nx) = (1 - fx) * (1 - fy);
                    H(i, px + 1 + py * nx) = fx * (1 - fy);
                    H(i, px + (py + 1) * nx) = ( 1 - fx) * fy;
                    H(i, px + 1 + (py + 1) * nx) = fx * fy;
                elseif fx == 0 & fy == 0
                    H(i, px + py * nx) = 1;
                elseif fx == 0
                    H(i, px + py * nx) = (1 - fy);
                    H(i, px + (py + 1) * nx) = fy;
                elseif fy == 0
                    H(i, px + py * nx) = 1 - fx;
                    H(i, px + 1 + py * nx) = fx;
                end
            end
        end
        
    elseif strcmp(prm.observe, 'A+B')

        if (nx > 1) % 1D case
            error(sprintf('\n  EnKF: error: calc_h(): prm.observe = A+B is not implemented for 2D geometry'));
        end
        
        for i = 1 : p
            pp = pos(i);
            if (pp == floor(pp))
                H(i, pp) = 0.5;
                H(i, pp + nv) = 0.5;
            else
                frac = pp - floor(pp);
                pp = floor(pp);
                offset = floor((pp - 1) / nv) * nv;  % to handle pp > nv
                pp1 = mod(pp, nv) + 1 + offset;
                H(i, pp) = (1 - frac) / 2.0;
                H(i, pp + nv) = (1 - frac) / 2.0;
                H(i, pp1) = frac / 2.0;
                H(i, pp1 + nv) = frac / 2.0;
            end
        end
  
    else
        error(sprintf('\n  EnKF: error: calc_h(): no code to observe \"%s\"', prm.observe));
    end
  
    return;
