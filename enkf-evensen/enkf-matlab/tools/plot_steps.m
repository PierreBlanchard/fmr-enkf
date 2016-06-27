% function [] = plot_steps(x, color, filled, dotted, merged, putdots)
%
% Plots a vector as a step function.
%
% @param x - the vector to plot
% @param color - the color to use, e.g. 'r' (optional, default = 'b')
% @param filled - whether to fill the plot (optional, 1)
% @param dotted - whether to use dotted line (optional, 0)
% @param merged - whether to merge the scale with the existing plot (optional, 0)
% @param putdots - whether to separate columns vertically with a dotted line
%                  (optional, default = 0)

% File:           plot_steps.m
%
% Created:        2006 or 2007
%
% Last modified:  15/08/2008
%
% Author:         Pavel Sakov
%                 NERSC
%                 CSIRO Marine and Atmospheric Research
%
% Purpose:        Plots a vector as a step function.
% 
% Description:
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [] = plot_steps(x, color, filled, dotted, merged, putdots)

    if ~exist('color', 'var')
        color = 'b';
    end
  
    if ~exist('filled', 'var')
        filled = 1;
    end

    if ~exist('dotted', 'var')
        dotted = 0;
    end
    
    if ~exist('merged', 'var')
        merged = 0;
    end
    
    if ~exist('putdots', 'var')
        putdots = 0;
    end

    if filled
        switch color
          case 'g'
            fillcolor = [0.75 1 0.75];
          case 'r'
            fillcolor = [1 0.75 0.75];
          case 'b'
            fillcolor = [0.75 0.75 1];
          otherwise
            fillcolor = [0.85 0.85 0.85];
        end
    end

    n = length(x);
    [xx, yy] = steppoly(x);
    
    if filled
        fill(xx, yy, fillcolor);
    end
    hold on;

    if ~dotted
        plot(xx, yy, color);
    else
        plot(xx, yy, ['-.' color]);
    end
    hold off;
  
    if putdots
        hold on;
        for i = 1 : n
            plot([xx(2 * i - 1) xx(2 * i - 1)], [yy(2 * i - 1) 0], ':', 'color', color);
        end
        hold off;
    end
  
    return

function [xx, yy] = steppoly(x)

    n = length(x);

    xx = zeros(n * 2 + 3, 1);
    yy = zeros(n * 2 + 3, 1);
  
    for i = 1 : n
        xx(i * 2 - 1) = i - 1;
        xx(i * 2) = i;
        yy(i * 2 - 1) = x(i);
        yy(i * 2) = x(i);
    end
  
    xx(n * 2 + 1) = xx(n * 2);
    xx(n * 2 + 2) = xx(1);
    xx(n * 2 + 3) = xx(1);
    yy(n * 2 + 3) = yy(1);
    xx = xx + 0.5;
  
    return
