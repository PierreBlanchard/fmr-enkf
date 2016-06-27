% function [bins] = plot_rankhistogram(x, m, nbins, f)
%
% Given series x such that 0 <= x <= m, plots the rank histogram for x.
%
% @param x - timeseries; it is assumed but not critical that 0 <= x <= m
% @param m - number of ensemble members (or range of the time series)
%            (optional, default = max(x))
% @param nbins - number of bins (optional, sqrt(m))
% @param f - handle to graphic window to plot in (optional)
% @return bins - array of number events for each bin
%
% File:           plot_rankhistogram.m
%
% Created:        2006 or 2007
%
% Last modified:  15/08/2008
%
% Author:         Pavel Sakov
%                 NERSC
%                 CSIRO Marine and Atmospheric Research
%
% Purpose:        Plots rank histogram for a given timeseries.
% 
% Description:
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [bins] = plot_rankhistogram(x, m, nbins, f)
  
    if ~exist('m', 'var')
        m = max(x);
    end
    
    if ~exist('nbins', 'var')
        nbins = floor(sqrt(m));
    end
    
    if exist('f', 'var')
        if isempty(f)
            f = figure;
        else
            figure(f);
        end
    end
    
    bins = bin(x, m, nbins);
    plot_steps(bins, 'b', 0, 0, 0, 1);

    return
