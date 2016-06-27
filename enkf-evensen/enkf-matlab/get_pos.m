% function [pos] = get_pos(prm)
%
% Generates a vector with fractional indices for observation locations
%
% @param prm  - system parameters
% @return pos - a vector with fractional indices for the locations of
%               observations
%
% Depending on the value of prm.obs_spacing it generates:
%
% random  - complitely random locations
% regular - regular locations, the same at successive calls
% urandom - regularly distrubuted locations, with a random offset

% File:           get_pos.m
%
% Created:        31/08/2007
%
% Last modifiied: 18/02/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Generates a vector with fractional indices for observation
%                 locations
%
% Description:    PS 18/02/2008 Changed interpretation of prm.mult. Was: number
%                 of model variables, with prm.n being the size of one
%                 variable; became: number of model variables, with prm.n
%                 being the size of the model state vector.

%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [pos] = get_pos(prm)
  
    n = prm.n;
    np = prm.nprm;
    ns = n - np;
    nv = ns / prm.mult;
    p = prm.p;
  
    if prm.nx <= 1 % 1D case
        pos = zeros(p, 1);
    else % 2D case
        pos = zeros(p, 2);
        nx = prm.nx;
        ny = nv / prm.nx;
    end
    
    if strcmp(prm.obs_spacing, 'random')
        if prm.nx <= 1 % 1D case
            for i = 1 : p
                pos(i) = rand * (nv - 1) + 1;
            end
        else % 2D case
            for i = 1 : p
                pos(i, 1) = rand * (nx - 2) + 1; % 1 <= px <= nx
                pos(i, 2) = rand * (ny - 2) + 1; % 1 <= py <= ny
            end
        end
    elseif strcmp(prm.obs_spacing, 'regular')
        if prm.nx <= 1 % 1D case
            for i = 1 : p
                pos(i) = ceil(nv / p * (i - 0.5));
            end
        else % 2D case
            nn = (nx - 1) * (ny - 1);
            dn = nn / p;
            for i = 1 : p
                pp = dn * (i - 0.5);
                pos(i, 1) = mod(pp, nx - 1) + 1;
                pos(i, 2) = pp / (nx - 1) + 1;
            end
        end
    elseif strcmp(prm.obs_spacing, 'urandom')
        if prm.nx <= 1 % 1D case
            offset = rand * nv;
            for i = 1 : p
                pp = ceil((nv - 1) / p * (i - 1));
                pos(i) = mod(pp + offset, nv) + 1;
            end
        else % 2D case
            nn = (nx - 1) * (ny - 1);
            offset = rand * nn;
            dn = nn / p;
            for i = 1 : p
                pp = mod(dn * i + offset, nn);
                pos(i, 1) = mod(pp, nx - 1) + 1;
                pos(i, 2) = pp / (nx - 1) + 1;
            end
        end
    else
        error(sprintf('\n  EnKF: error: get_pos(): unknown obs_spacing \"%s\"', prm.obs_spacing));
    end
  
    if strcmp(prm.observe, 'B')
        if prm.mult < 2
            error(sprintf('\n  error: getpos(): prm.observe = B is only allowed for models with more than one variable'));
        else
            pos = pos + nv;
        end
    end
    if strcmp(prm.observe, 'A&B')
        if prm.mult < 2
            error(sprintf('\n  error: getpos(): prm.observe = A&B is only allowed for models with more than one variable'));
        else
            pos = [pos; pos + nv];
        end
    end

    if prm.p_inverse
        pos = pos(end : -1 : 1);
    end
    
    return
