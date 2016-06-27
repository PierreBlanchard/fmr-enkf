% function [] = model_plotstate(prm, x_true, x, v, pos, y, stats, f, firsttime)
%
% Plots the state vector for the S model
%
% @param prm - system parameters
% @param x_true - true field
% @param x - model field
% @param v - ensemble variance
% @param pos - observation locations (optional)
% @param y - observations (optional)
% @param stats - assimilation statistics
% @param f - handle to graphic window
% @firsttime - wether is called for the first time

% File:           model_plotstate.m
%
% Created:        31/08/2007
%
% Last modified:  13/08/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Plots the state vector for the L3 model
%
% Description:
%
% Revisions:      13082008 PS: added variance to the arguments

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [] = model_plotstate(prm, x_true, x, v, pos, y, stats, f, firsttime)

    if (firsttime)
        h = [subplot(2, 1, 1) subplot(2, 1, 2)];
        plot_x(prm, x_true, 1, [1 0 1], h); % initial truth is magenta
        plot_x(prm, x, 1, [0 0 1], h); % initial forecast is blue
        subplot(2, 1, 1);
        legend('true field', 'initial guess');
        subplot(2, 1, 2);
        legend('true field', 'initial guess');
    end
    if (stats.lasttime)
        h = [subplot(2, 1, 1) subplot(2, 1, 2)];
        plot_x(prm, x, stats.step(end), [0 1 0], h); % final analysis is green
        subplot(2, 1, 1);
        legend('true field', 'initial guess', 'final analysis');
        subplot(2, 1, 2);
        legend('true field', 'initial guess', 'final analysis');
    end
    
    return
