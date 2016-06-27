% function [] = plotspectrum(A, N, color, filled, merged, putdots)
%
% Plots ensemble average power spectrum
%
% @param A - ensemble
% @param N - number of components to plot (optional, default = n / 2)
% @param color - plot color (optional, 'b')
% @param filled - whether to fill the plot (optional, 1)
% @param merged - whether to merge the scale with the existing plot (optional, 0)
% @param putdots - whether to separate columns vertically with a dotted line
%                  (optional, 1)

% File:           plot_ensspectrum.m
%
% Created:        2005
%
% Last modified:  15/08/2008
%
% Author:         Pavel Sakov
%                 NERSC
%                 CSIRO Marine and Atmospheric Research
%
% Purpose:        Plots ensemble average power spectrum
% 
% Description:
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [] = plot_ensspectrum(A, N, color, filled, merged, putdots)
  
    [n, m] = size(A);
    
    if ~exist('N', 'var')
        N = ceil(n / 2);
    end
    
    if ~exist('color', 'var')
        color = 'b';
    end
    
    if ~exist('filled', 'var')
        filled = 1;
    end
    
    if ~exist('merged', 'var')
        merged = 0;
    end
    
    if ~exist('putdots', 'var')
        putdots = 1;
    end
    
    psd_sum = zeros(n, 1);
    for e = 1 : m
        psd = fft_pwr(A(:, e));
        psd_sum = psd_sum + psd;
    end
    psd_ave = sqrt(psd_sum / m);
    
    ymax = max(psd_ave);
    N = min(N, ceil(n / 2));
    xmax = max([N max(find(psd_ave > ymax / 1e+2))]);

    psd_ave = psd_ave(1 : xmax);
    plot_steps(psd_ave, color, filled, 0, merged, putdots);

    return
