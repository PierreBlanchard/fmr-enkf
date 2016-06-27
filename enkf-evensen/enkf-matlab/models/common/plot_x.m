% function [] = plot_x(prm, x, k, color, h)
%
% Plots the state vector to a specified figure.
%
% @param prm - system parameters
% @param x - state vector
% @param k - time step; used for LA, LA2 and S models to sync initial and 
%            current fields
% @param color - color in RGB format, e.g. [0 1 0] 
% @param h - output handle

% File:          plot_x.m
%
% Created:       31/08/2007
%
% Last modified: 18/02/2008
%
% Author:        Pavel Sakov
%                CSIRO Marine and Atmospheric Research
%                NERSC
%
% Purpose:       Plots the state vector to a specified figure.
%
% Description: 
%
% Revisions:    PS 18/02/2008 Changed interpretation of prm.mult. Was: number
%                 of model variables, with prm.n being the size of one
%                 variable; became: number of model variables, with prm.n
%                 being the size of the model state vector.

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [] = plot_x(prm, x, k, color, h)
  
    nx = (prm.n - prm.nprm) / prm.mult;
    if ~exist('k','var')
        k = 1;
    end
    k = mod(k - 1, nx) + 1;

    if prm.mult > 1
        xx = zeros(nx, 1);
        if strcmp(prm.model, 'LA2') | strcmp(prm.model, 'S')
            xx(1 : nx - k + 1) = x(k : nx);
            xx(nx - k + 2 : nx) = x(1 : k - 1);
        else
            xx(1 : nx) = x(1 : nx);
        end
        if exist('h', 'var')
            subplot(h(1));
            if prm.mult > 1
                title('variable A');
            end
        end
        if exist('color', 'var')
            plot(xx, 'color', color);
        else
            plot(xx, 'b-');
        end
        hold on;
        xx = zeros(nx, 1);
        if strcmp(prm.model, 'LA2')
            xx(1 : nx - k + 1) = x(nx + k : 2 * nx);
            xx(nx - k + 2 : nx) = x(nx + 1 : nx + k - 1);
        elseif strcmp(prm.model, 'S')
            xx(k : nx) = x(nx + 1 : 2 * nx - k + 1);
            xx(1 : k - 1) = x(2 * nx - k + 2 : 2 * nx);
        else
            xx(nx + 1 : nx + nx) = x(nx + 1 : nx + nx);
        end
        ls = ':';
        if exist('h', 'var')
            subplot(h(2));
            if prm.mult > 1
                title('variable B');
            end
            ls = '-';
        end
        if exist('color', 'var')
            plot(xx, 'color', color, 'linestyle', ls);
        else
            plot(xx, 'b-', 'linestyle', ls);
        end
        hold on;
    else
        xx = zeros(nx, 1);
        if strcmp(prm.model, 'LA')
            xx(1 : nx - k + 1) = x(k : nx);
            if (k ~= 1)
                xx(nx - k + 2 : nx) = x(1 : k - 1);
            end
        else
            xx = x;
        end
    
        if exist('color', 'var')
            plot(xx, 'color', color);
        else
            plot(xx, 'b-');
        end
        hold on;
    end
  
    return
