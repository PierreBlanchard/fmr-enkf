% function [bins] = bin(x, m, nbins)
%
% Bins a given timesries.
%
% @param x - timeseries; it is assumed but not critical that 0 <= x <= m
% @param m - ensemble size (or the range of the time series)
% @param nbins - number of bins
% @return bins - array with the number of events for each bin

% File:           bin.m
%
% Created:        2006 or 2007
%
% Last modified:  13/03/2008
%
% Author:         Pavel Sakov
%                 NERSC
%                 CSIRO Marine and Atmospheric Research
%
% Purpose:        Bins a given timeseries.
% 
% Description:
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [bins] = bin(x, m, nbins)
  
    bins = zeros(nbins, 1);
    step = (m + 1) / nbins;
    nx = length(x);
    for i = 1 : nx
        index = floor(x(i) / step) + 1;
        bins(index) = bins(index) + 1;
    end

    return
