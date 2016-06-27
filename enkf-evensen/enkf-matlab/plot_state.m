% function [f] = plot_state(prm, x_true, x, v, pos, y, stats)
%
% Plots the state vector of the system.
%
% @param prm - system parameters
% @param x_true - true field
% @param x - model field
% @param v - ensemble variance
% @param pos - observation locations (optional)
% @param y - observations (optional)
% @param stats - assimilation statistics
% @return - handle to figure (optional)

% File:           plot_state.m
%
% Created:        31/08/2007
%
% Last modified:  13/08/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Plots the state vector of the system.
%
% Description:    Plots the current state of the system. First time should
%                 be called with empty f0, second and following times - with 
%                 the f0 set to the handle returned during the first call.
%
% Revisions:      13082008 PS: added ensemble variance to the arguments
%                 28.10.2010 PS: got rid of the last (8th) argument

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [f] = plot_state(prm, x_true, x, v, pos, y, stats)
  
    firsttime = ~isfield(stats, 'f_state');

    if firsttime
        f = figure;
    else
        set(0, 'CurrentFigure', stats.f_state);
        f = stats.f_state;
    end
  
    model_plotstate(prm, x_true, x, v, pos, y, stats, f, firsttime)
    
    return
