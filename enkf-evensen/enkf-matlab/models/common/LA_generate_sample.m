% function [x] = LA_generate_sample(prm, kstart, kstep, kend)
%
% Generates an instance of the state vector for LA model.
%
% @param prm - system parameters
% @param kstart - smallest wave number
% @param kstep - wave number step
% @param kend - largest wave number
% @return x - an instance state vector

% File :          LA.m
%
% Created:        31/08/2007
%
% Last modified:  08/02/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Generates an instance of the state vector for LA model.
%
% Description:
%
% Revisions:      PS 18/02/2008 Changed interpretation of prm.mult. Was: number
%                 of model variables, with prm.n being the size of one
%                 variable; became: number of model variables, with prm.n
%                 being the size of the model state vector.

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [x] = LA_generate_sample(prm, kstart, kstep, kend)

    nv = prm.n / prm.mult;
    xx = (1 : nv)';
    x = zeros(nv, 1);
    for k1 = kstart : kstart + floor((kstep - 1) / 2)
        for k = k1 : kstep : kend
            kk = k * 2.0 * pi / nv; % wave number
            a = rand; % amplitude
            ph = rand * 2.0 * pi; % phase
            x = x + a * sin(kk * xx + ph);
        end
    end

    xstd = std(x);
    x = x / xstd;
  
    if prm.verbose == 2
        fprintf('.');
    end
  
    return
