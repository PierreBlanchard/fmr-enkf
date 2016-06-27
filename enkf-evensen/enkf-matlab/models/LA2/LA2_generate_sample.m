% function [x] = LA2_generate_sample(prm, kstart, kstep, kend)
%
% Generates an instance of the state vector for LA2 model.
%
% @param prm - system parameters
% @param kstart - smallest wave number
% @param kstep - wave number step
% @param kend - largest wave number
% @return x - an instance of a state vector

% File:           LA2_generate_sample.m
%
% Created:        31/08/2007
%
% Created:        08/02/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%
% Purpose:        Calculates a sample field for the LA2 model
%
% Description:    Is based on LA_generate_sample().
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [x] = LA2_generate_sample(prm, kstart, kstep, kend)
  
    x = LA_generate_sample(prm, kstart, kstep, kend);
    y = calc_derivative(x);
  
    x = [x; y];

    return

function [y] = calc_derivative(x)
    n = length(x);
    y = zeros(n, 1);
    y(1 : n - 1) = x(2 : n);
    y(n) = x(1);
    y(2 : n) = y(2 : n) - x(1 : n - 1);
    y(1) = y(1) - x(n);
    y = y / 2.0;

    return
