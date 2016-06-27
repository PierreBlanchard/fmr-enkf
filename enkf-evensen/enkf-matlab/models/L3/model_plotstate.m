% function [] = model_plotstate(prm, x_true, x, v, pos, y, stats, f, firsttime)
%
% Plots the state vector for the L3 model
%
% @param prm - system parameters
% @param x_true - true field
% @param x - model field
% @param v - ensemble variance
% @param pos - observation locations (optional)
% @param y - observations (optional)
% @param stats - assimilation statistics
% @param f - handle to graphic window
% @param firsttime - whether is called for the first time

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

    if prm.plot_state == 1
        for var = [1 : prm.n]
            a = subplot(3, 1, var);
            lines = findobj(a, 'type', 'line', 'marker', 'none');
            if length(lines) == 0
                hold on
                plot(stats.step(end), x_true(var), 'color', [1 0 1]); % truth is magenta
                plot(stats.step(end), x(var), 'color', [0 0 1]); % forecast is blue
            elseif length(lines) == 2
                xdata = get(lines(1), 'xdata');
                xdata = [xdata stats.step(end) + 1];
                for l = 1 : 2
                    ll = lines(l);
                    col = get(ll, 'color');
                    ydata = get(ll, 'ydata');
                    if col(1) == 1 %truth
                        ydata = [ydata x_true(var)];
                    else
                        ydata = [ydata x(var)];
                    end
                    set(ll, 'xdata', xdata, 'ydata', ydata);
                end
            else
                error(sprintf('\n  L3: error: model_plotstate: length(lines) = %d (expected 2)\n', length(lines)));
            end
            
            pos_var = find(pos == var);
            
            if ~isempty(pos_var)
                lines = findobj(a, 'type', 'line', 'marker', '.');
                if length(lines) == 0
                    plot(stats.step(end), y(pos_var(1)), '.', 'color', 'k');
                    for o = 2 : length(pos_var)
                        xdata = get(lines(1), 'xdata');
                        xdata = [xdata xdata(end) + 1];
                        ydata = get(lines(1), 'ydata');
                        ydata = [ydata y(pos_var(o))];
                        set(lines(1), 'xdata', xdata, 'ydata', ydata)
                    end
                elseif length(lines) == 1
                    for o = 1 : length(pos_var)
                        xdata = get(lines(1), 'xdata');
                        % TODO: account for asynchronous observations
                        xdata = [xdata xdata(end) + prm.assim_step];
                        ydata = get(lines(1), 'ydata');
                        ydata = [ydata y(pos_var(o))];
                        set(lines(1), 'xdata', xdata, 'ydata', ydata)
                    end
                else
                    error(sprintf('\n  L3: error: model_plotstate: length(lines) = %d (expected 1)\n', length(lines)));
                end
            end
            if stats.lasttime & var == 1
                legend('true field', 'analysis');
            end
        end
    elseif prm.plot_state == 2
        plot_x(prm, x_true, 1, [1 0 1], f); % truth is magenta
        plot_x(prm, x, 1, [0 0 1], f); % forecast is blue
        if ~isempty(pos)
            plot(pos, y, 'kx');
        end
        if stats.lasttime
            legend('true field', 'analysis');
        end
        hold off;
    elseif prm.plot_state == 3
        for sp = 1 : 2
            a = subplot(1, 2, sp);
            lines = findobj(a, 'type', 'line', 'marker', 'none');
            if length(lines) == 0
                hold on;
                plot(x_true(sp), x_true(sp + 1), 'color', [1 0 1]);
                plot(x(sp), x(sp + 1), 'color', [0 0 1]);
                xlabel(sprintf('x_%d', sp));
                ylabel(sprintf('x_%d', sp + 1));
            elseif length(lines) == 2
                xdata = get(lines(1), 'xdata');
                xdata = [xdata x_true(sp)];
                ydata = get(lines(1), 'ydata');
                ydata = [ydata x_true(sp + 1)];
                if length(xdata) > 100
                    xdata = xdata(end - 100 : end);
                    ydata = ydata(end - 100 : end);
                end
                set(lines(1), 'xdata', xdata, 'ydata', ydata);
                    
                xdata = get(lines(2), 'xdata');
                xdata = [xdata x(sp)];
                ydata = get(lines(2), 'ydata');
                ydata = [ydata x(sp + 1)];
                if length(xdata) > 100
                    xdata = xdata(end - 100 : end);
                    ydata = ydata(end - 100 : end);
                end
                set(lines(2), 'xdata', xdata, 'ydata', ydata);
            else
                error(sprintf('\n  L3: error: model_plotstate: length(lines) = %d (expected 2)\n', length(lines)));
            end
        end
        if stats.lasttime
            subplot(1, 2, 1);
            legend('true field', 'analysis');
        end
    end
    
    return
