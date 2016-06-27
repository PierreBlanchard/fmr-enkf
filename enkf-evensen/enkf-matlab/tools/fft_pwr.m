% function [f] = fft_pwr(x)
%
% Calculates the power spectrum of a series
%
% @param x - input series
% @return f - power spectrum

% File:           fft_pwr.m
%
% Created:        2005, perhaps
%
% Last modified:  13/03/2008
%
% Author:         Pavel Sakov
%                 NERSC
%                 CSIRO Marine and Atmospheric Research
%
% Purpose:        Calculates the power spectrum of a series
% 
% Description:
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [f] = fft_pwr(x)
    n = length(x);
    f = fft(x);
    n2 = ceil(n / 2);
    n3 = n2 + mod(n + 1, 2);
    f = abs(f);
    f = f .* f / n;
    f(2 : n2) = f(2 : n2) * 2;
    f(n3 + 1 : n) = 0;
    maxf = max(f);
    small = find(f < maxf * 1.0e-8);
    f(small) = 0;

  return
