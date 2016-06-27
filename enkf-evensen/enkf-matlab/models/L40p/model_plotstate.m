% function [] = model_plotstate(prm, x_true, x, v, pos, y, stats, f, firsttime)
%
% Plots the state vector for the L40p model
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
% Purpose:        Plots the state vector for the L40p model
%
% Description:     
%
% Revisions:      13082008 PS: added variance to the arguments

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [] = model_plotstate(prm, x_true, x, v, pos, y, stats, f, firsttime)
    
    plot_x(prm, x_true(1 : end - 1), 1, [1 0 1], f); % truth is magenta
    plot_x(prm, x(1 : end - 1), 1, [0 0 1], f); % forecast is blue
    if ~isempty(pos)
        plot(pos, y, 'kx');
    end
    if stats.lasttime
        legend('true field', 'analysis');
    end
    hold off;
    
    return
