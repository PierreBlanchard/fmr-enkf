% function [f] = plot_ens(prm, A, f0, tag)
%
% Plots ensemble anomalies.
%
% @param prm - system parameters
% @param A - ensemble
% @param f0 - handle to figure (optional)
% @param tag - plot title
% @return f - handle to figure

% File:           plot_ens.m
%
% Created:        11/02/2008
%
% Last modified:  08/09/2008
%
% Author:         Pavel Sakov
%                 NERSC
%
% Purpose:        Plots ensemble anomalies.
%
% Description:    This function is supposed to be used when a detailed tracking
%                 of the ensemble behaviour is needed. It is pretty basic right
%                 now, just calls plot(A).
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [f] = plot_ens(prm, A, f0, tag)
    
    firsttime = ~exist('f0', 'var') | isempty(f0);

    if firsttime
        f = figure;
        firsttime = 1;
        r = 0;
    else
        set(0, 'CurrentFigure', f0);
        r = max(abs(ylim)');
    end

    plot(A);
    r = max(r, max(abs(ylim)));
    rr = max(max(abs(A)));
    if rr < r / 2
        r = r / 2;
    end
    ylim([-r r]);
    title(tag);
    
    pause;
    
    return
