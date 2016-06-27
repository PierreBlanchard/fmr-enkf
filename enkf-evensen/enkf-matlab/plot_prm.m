% function [f] = plot_prm(prm, stats, f0)
%
% Plots diagnostics of the parameter estimation.
%
% @param prm - system parameters
% @param stats - system statistics
% @param f0 - handle to figure (optional)
% @return - handle to figure

% File:           plot_diag.m
%
% Created:        17/01/2008
%
% Last modified:  08/02/2008
%
% Author:         Pavel Sakov
%                 NERSC
%
% Purpose:        Plots diagnostics of the parameter estimation.
%
% Description:    Plots diagnostics of the parameter estimation. First time
%                 should be called with empty f0, second and following times
%                 - with the f0 set to the handle returned during the first
%                 call.
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [f] = plot_prm(prm, stats, f0)
    
    NPOUTMAX = 4;
    
    if prm.nprm == 0
        f = [];
        return
    end
    
    prm_t = stats.prm_t;
    prm_f = stats.prm_f;
    prm_a = stats.prm_a;
    rmse_p_a = stats.rmse_p_a;
    spread_p_a = stats.spread_p_a;
    step = stats.step;
    
    firsttime = ~exist('f0', 'var') | isempty(f0);
    lasttime = stats.lasttime;
    
    nr = prm.plot_diag_np * 2;
    if lasttime
        nr = length(stats.step);
    end
    nr = min(nr, length(stats.step));

    np = min(prm.nprm, NPOUTMAX);

    if firsttime
        f = figure;
        firsttime = 1;
    else
        set(0, 'CurrentFigure', f0);
    end

    for par = 1 : np
        subplot(np, 2, par * 2 - 1);
        plot(step(end + 1 - nr : end), prm_t(par, end + 1 - nr : end), 'b-', step(end + 1 - nr : end), prm_a(par, end + 1 - nr : end), 'g-');
        title(sprintf('Parameter %d, analysis vs. true', par));
        if lasttime
            legend('truth', 'analysis');
        end
        
        subplot(np, 2, par * 2);
        plot(step(end + 1 - nr : end), rmse_p_a(par, end + 1 - nr : end), 'b-', step(end + 1 - nr : end), spread_p_a(par, end + 1 - nr : end), 'b:');
        title(sprintf('Parameter %d, rmse and spread', par));
        if lasttime
            legend('rmse', 'spread');
        end
    end

    pause(0.01);
    
    return
