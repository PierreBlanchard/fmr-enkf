% function [f] = plot_diag(prm, stats)
%
% Plots the current diagnostics of the filter.
%
% @param prm - system parameters
% @param stats - system statistics
% @return f - handle to figure

% File:           plot_diag.m
%
% Created:        31/08/2007
%
% Last modified:  08/02/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Plots the current diagnostics of the filter.
%
% Description:    Plots the current diagnostics of the filter. First time
%                 should be called with empty f0, second and following times
%                 - with the f0 set to the handle returned during the first
%                 call.
%
% Revisions:     28.10.2010 PS: got rid of the 3rd argument

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [f] = plot_diag(prm, stats)
  
    firsttime = ~isfield(stats, 'f_diag');
    lasttime = stats.lasttime;
    
    step = stats.step;
    rmse = stats.rmse_a;
    spread = stats.spread_a;
    corr = stats.corr_a;
    corr(find(corr <= 0)) = NaN;
    skew = stats.skewness_a;
    kurt = stats.kurtosis_a;
    var95 = stats.var95_a;
  
    nr = prm.plot_diag_np;
    if lasttime
        nr = length(step);
    end
    nr = min(nr, length(step));

    if firsttime
        f = figure;
    else
        set(0, 'CurrentFigure', stats.f_diag);
    end

    % plot 1 -- rmse and spread, linear
    %
    subplot(3, 2, 1);
    plot(step(end + 1 - nr : end), rmse(1, end + 1 - nr : end), 'b-', step(end + 1 - nr : end), spread(1, end + 1 - nr : end), 'b:');
    if prm.mult == 2
        hold on;
        plot(step(end + 1 - nr : end), rmse(2, end + 1 - nr : end), 'g-', step(end + 1 - nr : end), spread(2, end + 1 - nr : end), 'g:');
        hold off;
    end
    if ~isempty(stats.bestrmse)
        hold on;
        plot([step(end + 1 - nr) step(end)], [stats.bestrmse(1) stats.bestrmse(1)], 'r:');
        hold off;
    end
    title('RMSE and spread');
    if lasttime
        if prm.mult == 1
            legend('RMSE', 'spread');
        elseif prm.mult == 2
            legend('RMSE', 'spread', 'RMSE', 'spread');
        end
    end
  
    % plot 2 -- rmse and spread, log
    %
    subplot(3, 2, 2);
    semilogy(step(end + 1 - nr : end), rmse(1, end + 1 - nr : end), 'b-', step(end + 1 - nr : end), spread(1, end + 1 - nr : end), 'b:');
    if prm.mult == 2
        hold on;
        semilogy(step(end + 1 - nr : end), rmse(2, end + 1 - nr : end), 'g-', step(end + 1 - nr : end), spread(2, end + 1 - nr : end), 'g:');
        hold off;
    end
    title('RMSE and spread');
    if lasttime
        if prm.mult == 1
            legend('RMSE', 'spread');
        elseif prm.mult == 2
            legend('RMSE', 'spread', 'RMSE', 'spread');
        end
    end
  
    % plot 3 -- correlation, mean(abs(skewness)) and mean(kurtosis)
    %
    subplot(3, 2, 3)
    semilogy(step(end + 1 - nr : end), corr(1, end + 1 - nr : end), 'b-');
    hold on;
    semilogy(step(end + 1 - nr : end), skew(1, end + 1 - nr : end), 'g-');
    semilogy(step(end + 1 - nr : end), kurt(1, end + 1 - nr : end), 'r-');
    semilogy(step(end + 1 - nr : end), var95(1, end + 1 - nr : end) / prm.m, 'c-');
    if prm.mult == 2
        hold on;
        semilogy(step(end + 1 - nr : end), corr(2, end + 1 - nr : end), 'b.');
        semilogy(step(end + 1 - nr : end), skew(2, end + 1 - nr : end), 'g.');
        semilogy(step(end + 1 - nr : end), kurt(2, end + 1 - nr : end), 'r.');
        semilogy(step(end + 1 - nr : end), var95(2, end + 1 - nr : end) / prm.m, 'c.');
    end
    rmin = min(min(skew));
    rmax = max(1, max(max(kurt)));
    if ~isnan(rmin) & ~isnan(rmax) & rmin > 0 & rmax > 0 & rmax > rmin
        ylim([rmin rmax]);
    end
    hold off;
    title('correlation coefficient, skewness and kurtosis');
    if lasttime
        if prm.mult == 1
            legend('correlation', 'skewness', 'kurtosis', '95% energy', 'Location', 'NorthWest');
        elseif prm.mult == 2
            legend('correlation', 'skewness', 'kurtosis', 'correlation', 'skewness', 'kurtosis', '95% energy', 'Location', 'NorthWest');
        end
    end
  
    % plot 4 -- SVD spectrum
    %
    if firsttime
        subplot(3, 2, 4);
        plot(stats.svdspectrum_start, 'b.-');
        title('normalised SVD spectrum')
    end
    if lasttime
        subplot(3, 2, 4);
        hold on;
        plot(stats.svdspectrum_end, 'g.-');
        hold off;
        legend('initial spectrum', 'final spectrum', 'Location', 'NorthEast');
    end
  
    % plot 5 -- info
    %
    if firsttime
        h = subplot(3, 2, 5);
        set(h, 'AlimMode', 'manual', 'Visible', 'off');
        str = prm2info(prm);
        text(0, 0.5, str, 'interpreter', 'none', 'FontSize', 6);
    end
  
    % plot 6 -- stats
    %
    if lasttime
        nr = min(prm.plot_diag_np, length(step));
        mean_rmse = mean(stats.rmse_a(1, end + 1 - nr : end));
        mean_spread = mean(stats.spread_a(1, end + 1 - nr : end));
        mean_skew = mean(stats.skewness_a(1, end + 1 - nr : end));
        mean_kurt = mean(stats.kurtosis_a(1, end + 1 - nr : end));
        
        str = sprintf('at start:\n');
        str = [str sprintf('  rmse = %.3g\n', rmse(1, 1))];
        str = [str sprintf('  spread = %.3g\n', spread(1, 1))];
        str = [str sprintf('at last %d steps (analysis):\n', nr)];
        str = [str sprintf('  rmse = %.3g\n', mean_rmse)];
        str = [str sprintf('  spread = %.3g\n', mean_spread)];
        str = [str sprintf('  skewness = %.3g\n', mean_skew)];
        str = [str sprintf('  kurtosis = %.3g\n', mean_kurt)];

        mean_rmse = mean(stats.rmse_f(1, end + 1 - nr : end));
        mean_spread = mean(stats.spread_f(1, end + 1 - nr : end));
        mean_skew = mean(stats.skewness_f(1, end + 1 - nr : end));
        mean_kurt = mean(stats.kurtosis_f(1, end + 1 - nr : end));

        str = [str sprintf('at last %d steps (forecast):\n', nr)];
        str = [str sprintf('  rmse = %.3g\n', mean_rmse)];
        str = [str sprintf('  spread = %.3g\n', mean_spread)];
        str = [str sprintf('  skewness = %.3g\n', mean_skew)];
        str = [str sprintf('  kurtosis = %.3g\n', mean_kurt)];
        if ~isempty(stats.bestrmse)
            str = [str sprintf('bestrmse = %.3g\n', stats.bestrmse)];
        end

        h = subplot(3, 2, 6);
        set(h, 'AlimMode', 'manual', 'Visible', 'off');
        text(0, 0.5, str, 'interpreter', 'none', 'FontSize', 6);
    end
    
    pause(0.02);
  
    return
