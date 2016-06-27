% function [] = model_plotstate(prm, x_true, x, v, pos, y, stats, f, firsttime)
%
% Plots the state vector for the QG model
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
% Created:        14/01/2008
%
% Last modified:  13/08/2008
%
% Author:         Pavel Sakov
%                 NERSC
%
% Purpose:        Plots the state vector for the QG model
%
% Description:    
%
% Revisions:     13082008 PS:
%                  -- fixed range calculation
%                  -- added variance to the arguments

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [] = model_plotstate(prm, x_true, x, v, pos, y, stats, f, firsttime)
    
    PSI_TRUE = reshape(x_true, prm.nx, prm.n / prm.nx);
    PSI = reshape(x, prm.nx, prm.n / prm.nx);
    if ~stats.lasttime
        PSI_DIFF = reshape(x - x_true, prm.nx, prm.n / prm.nx);
    else
        PSI_DIFF = stats.sum_diff_sq_a / length(stats.step) - stats.sum_diff_a .^ 2;
        PSI_DIFF = reshape(PSI_DIFF, prm.nx, prm.n / prm.nx);
    end
    
    r = max(abs([x_true]));
    r = [-r r];
    
    subplot(2, 2, 1);
    imagesc(PSI_TRUE, r);
    title(sprintf('True Field, t = %.1f', stats.t(end)));
    if ~isempty(pos)
        xpos = pos(:, 2); 
        ypos = pos(:, 1);
        hold on;
        plot(xpos, ypos, 'kx', 'markersize', 4);
        hold off;
    end
    axis image;
    
    subplot(2, 2, 2);
    imagesc(PSI, r);
    title('Analysis');
    axis image;
    
    subplot(2, 2, 3);
    if ~stats.lasttime
        imagesc(PSI_DIFF, r / 2);
        title('Difference (x 2)');
    else
        imagesc(-PSI_DIFF);
        title('average RMSE');
    end
    axis image;
    
    subplot(2, 2, 4);
    imagesc(reshape(v, prm.nx, prm.n / prm.nx));
    title('Variance');
    axis image;
    
    set_colormap;

    pause(0.1);
    
    return
