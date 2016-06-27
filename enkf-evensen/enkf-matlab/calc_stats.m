% function [stats] = calc_stats(prm, x_true, x, A, step, step1, t, stats)
%
% Updates filter statistics.
%
% @param prm - system parameters
% @param x_true - true field
% @param x - analysis
% @param A - ensemble anomalies
% @param step - step number
% @param step1 - last step number
% @param t - time
% @param stats - filter statistics (empty if not exists yet)
% @return stats - updated filter statistics

% File:           calc_stats.m
%
% Created:        31/08/2007
%
% Last modified:  02/05/2011
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%
% Purpose:        Updates filter statistics.
%
% Description:    The fields of the statistics structure:
%                   wdir
%                     - work directory
%                   prm
%                     - system parameters
%                   step
%                     - a vector (nassim + 1) with values of the model step
%                       number
%                   t
%                     - a vector (nassim + 1) with values of the model time
%                   rmse_f
%                     - a matrix (prm.mult x (nassim + 1)) with forecast RMS
%                       error
%                   spread_f
%                     - a matrix (prm.mult x (nassim + 1)) with forecast
%                       ensemble spread
%                   rmse_a
%                     - a matrix (prm.mult x (nassim + 1)) with analysis RMS
%                       error
%                   spread_a
%                     - a matrix (prm.mult x (nassim + 1)) with analysis
%                       ensemble spread
%                   rmse_p_f
%                     - a matrix (prm.nprm x (nassim + 1)) with forecast RMS
%                       error for parameters
%                   spread_p_f
%                     - a matrix (prm.nprm x (nassim + 1)) with forecast
%                       ensemble spread for the parameters
%                   rmse_p_a
%                     - a matrix (prm.nprm x (nassim + 1)) with analysis RMS
%                       error for parameters
%                   spread_p_a
%                     - a matrix (prm.nprm x (nassim + 1)) with analysis
%                       ensemble spread for parameters
%                   prm_t
%                     - a matrix (prm.nprm x (nassim + 1)) with true parameter
%                       values
%                   prm_f
%                     - a matrix (prm.nprm x (nassim + 1)) with forecast
%                       parameter values
%                   prm_a
%                     - a matrix (prm.nprm x (nassim + 1)) with analysis
%                       parameter values
%                   rank_true_f
%                     - a vector (nassim + 1) with forecast rank values for
%                       specified element relative to the true field
%                   rank_mean_f
%                     - a vector (nassim + 1) with forecast rank values for
%                       specified element relative to the ensemble mean
%                   rank_true_a
%                     - a vector (nassim + 1) with analysis rank values for
%                       specified element relative to the true field
%                   rank_mean_a
%                     - a vector (nassim + 1) with analysis rank values for
%                       specified element relative to the ensemble mean
%                   corr_f
%                     - a matrix (prm.mult x (nassim + 1)) with correlation
%                       coefficients between the forecast and the true field
%                   corr_a
%                     - a matrix (prm.mult x (nassim + 1)) with correlation
%                       coefficients between the analysis and the true field
%                   var95_f
%                     - minimal number of forecast ensemble anomalies
%                       containing 95% of the perturbation variance
%                   var95_a
%                     - minimal number of analysed ensemble anomalies
%                       containing 95% of the perturbation variance
%                   bestrmse
%                   svdspectrum_start
%                   svdspectrum_end
%                   sum_diff_f
%                   sum_diff_sq_f
%                   sum_diff_a
%                   sum_diff_sq_a
%                   lasttime
%
% Revisions:        22/02/2008 PS: added the fileds "wdir" and "prm" to the
%                     stats structure.
%                   22/07/2009 PS: 
%                     -- replaced "energy_95" field by "var95"
%                     -- added fields "rand_finalstate" and "randn_finalstate"
%                     -- corrected condition of diistinguishing the forecast and
%                        analysis to work with asynchronous assimilation
%                   01/09/2009 PS:
%                     -- do not fill parameters (stats.prm) any more, this is
%                        now done in main.m
%                   30/07/2010 PS:
%                     -- fixed calculation of RMSE
%                   02.05.2011 PS:
%                     -- changed how stats,lasttime is calculated (removed
%                        subtractions of 1)

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [stats] = calc_stats(prm, x_true, x, A, step, step1, t, stats)
  
    [n, m] = size(A);
    np = prm.nprm;
    mult = prm.mult;
    ns = n - np;
    nv = ns / mult;
    elem = prm.rank_elem;
    
    E = A + repmat(x, 1, m);
  
    if ~exist('stats', 'var') | isempty(stats)
        stats = struct(                  ...
            'wdir',               {pwd}, ...
            'prm',                {[]},  ...
            'step',               {[]},  ...
            't',                  {[]},  ...
            'rmse_f',             {[]},  ...
            'spread_f',           {[]},  ...
            'rmse_a',             {[]},  ...
            'spread_a',           {[]},  ...
            'rmse_p_f',           {[]},  ...
            'spread_p_f',         {[]},  ...
            'rmse_p_a',           {[]},  ...
            'spread_p_a',         {[]},  ...
            'skewness_f',         {[]},  ...
            'skewness_a',         {[]},  ...
            'kurtosis_f',         {[]},  ...
            'kurtosis_a',         {[]},  ...
            'prm_t',              {[]},  ...
            'prm_f',              {[]},  ...
            'prm_a',              {[]},  ...
            'rank_true_f',        {[]},  ...
            'rank_mean_f',        {[]},  ...
            'rank_true_a',        {[]},  ...
            'rank_mean_a',        {[]},  ...
            'corr_f',             {[]},  ...
            'corr_a',             {[]},  ...
            'var95_f',            {[]},  ...
            'var95_a',            {[]},  ...
            'bestrmse',           {[]},  ...
            'svdspectrum_start',  {[]},  ...
            'svdspectrum_end',    {[]},  ...
            'sum_diff_f',         {[]},  ...
            'sum_diff_sq_f',      {[]},  ...
            'sum_diff_a',         {[]},  ...
            'sum_diff_sq_a',      {[]},  ...
            'lasttime',           {[]},  ...
            'rand_finalstate',    {[]},  ...
            'randn_finalstate',   {[]},  ...
            'randn_obsstate',     {[]},  ...
            'restart',            {[]}   ...
            );
    end
    
    forecast = size(stats.rmse_f, 2) == size(stats.rmse_a, 2);
    analysis = ~forecast;
    
    rms = zeros(mult, 1);
    spread = zeros(mult, 1);
    corr = zeros(mult, 1);
    skew = zeros(mult, 1);
    kurt = zeros(mult, 1);
    var95 = zeros(mult, 1);
    if np > 0
        rmse_p = zeros(np, 1);
        spread_p = zeros(np, 1);
    end
  
    for mm = 1 : mult
        i1 = (mm - 1) * nv + 1;
        i2 = mm * nv;
        % This is how it used to be. Wrong! (Subtracs the sample mean.)
        % rms(mm) = std(x(i1 : i2) - x_true(i1 : i2), 1);
        rms(mm) = rmse(x(i1 : i2) - x_true(i1 : i2));
        spread(mm) = mean(std(A(i1 : i2, :), 1));
        tmp = corrcoef([x(i1 : i2) x_true(i1 : i2)]);
        corr(mm) = tmp(1, 2);
        sumabs = sum(abs(A(i1 : i2, :)'));
        good = find(sumabs > 0) + i1 - 1;
        skew(mm) = sum(abs(skewness(A(good, :)'))) / length(good);
        kurt(mm) = sum(kurtosis(A(good, :)')) / length(good);
        energy = sum(A .* A);
        if isnan(sum(energy))
            if prm.fatalnan
                error(sprintf('\n  error: A contains NaNs'));
            else
                var95(mm) = NaN;
            end
        else
            energy = sort(energy);
            energy = energy(end : -1 : 1);
            var95(mm) = min(find(cumsum(energy) >= 0.95 * sum(energy)));
        end
    end
    for par = 1 : np
        rmse_p(par) = rmse(x(ns + par) - x_true(ns + par));
        spread_p(par) = mean(std(A(ns + par, :), 1));
    end
  
    if elem ~= 0
        rank_true = 0;
        rank_mean = 0;
        for i = 1 : m
            if E(elem, i) < x_true(elem)
                rank_true = rank_true + 1;
            end
            if A(elem, i) < 0
                rank_mean = rank_mean + 1;
            end
        end
    end
    
    if analysis & prm.calc_bestrmse & isempty(stats.bestrmse)
        if prm.verbose
            fprintf('  calculating bestrmse...');
        end
        if strcmp(prm.model, 'L40') | ns <= m
            bestrmse = 0;
        elseif strcmp(prm.model, 'S')
            bestrmse = calc_bestrmse(x_true(1 : ns), E(1 : ns, :));
        else
            bestrmse = calc_bestrmse(x_true(1 : ns), E(1 : ns, :));
        end
        if bestrmse < 1.0e-10
            bestrmse = 0;
        end
        if prm.verbose
            fprintf('%g\n', bestrmse);
        end
        stats.bestrmse = [bestrmse];
    end
  
    if forecast & isempty(stats.svdspectrum_start)
        [U, S, V] = svd(A(1 : nv, :), 0);
        s = diag(S);
        stats.svdspectrum_start = s / s(1);
    end
  
    %
    % if last assimilation
    %
    step1 = floor(step1 / prm.assim_step) *  prm.assim_step;
    stats.lasttime = analysis & floor(step1 / prm.assim_step) == floor(step / prm.assim_step);
    
    if stats.lasttime
        [U, S, V] = svd(A(1 : nv, :), 0);
        s = diag(S);
        stats.svdspectrum_end = s / s(1);
    end
  
    %
    % store the results
    %
    if analysis
        stats.step = [stats.step step];
        stats.t = [stats.t t];
    end
    if forecast
        stats.rmse_f = [stats.rmse_f rms];
        stats.spread_f = [stats.spread_f spread];
        stats.skewness_f = [stats.skewness_f skew];
        stats.kurtosis_f = [stats.kurtosis_f kurt];
        if np > 0
            stats.rmse_p_f = [stats.rmse_p_f rmse_p];
            stats.spread_p_f = [stats.spread_p_f spread_p];
            stats.prm_t = [stats.prm_t x_true(ns + 1 : ns + np)];
            stats.prm_f = [stats.prm_f x(ns + 1 : ns + np)];
        end
        if elem ~= 0
            stats.rank_true_f = [stats.rank_true_f rank_true];
            stats.rank_mean_f = [stats.rank_mean_f rank_mean];
        end
        stats.corr_f = [stats.corr_f corr];
        stats.var95_f = [stats.var95_f var95];
        if isempty(stats.sum_diff_f)
            stats.sum_diff_f = x - x_true;
            stats.sum_diff_sq_f = (x - x_true) .^ 2;
        else
            stats.sum_diff_f = stats.sum_diff_f + x - x_true;
            stats.sum_diff_sq_f = stats.sum_diff_sq_f + (x - x_true) .^ 2;
        end
    else
        stats.rmse_a = [stats.rmse_a rms];
        stats.spread_a = [stats.spread_a spread];
        stats.skewness_a = [stats.skewness_a skew];
        stats.kurtosis_a = [stats.kurtosis_a kurt];
        if np > 0
            stats.rmse_p_a = [stats.rmse_p_a rmse_p];
            stats.spread_p_a = [stats.spread_p_a spread_p];
            stats.prm_a = [stats.prm_a x(ns + 1 : ns + np)];
        end
        if elem ~= 0
            stats.rank_true_a = [stats.rank_true_a rank_true];
            stats.rank_mean_a = [stats.rank_mean_a rank_mean];
        end
        stats.corr_a = [stats.corr_a corr];
        stats.var95_a = [stats.var95_a var95];
        if isempty(stats.sum_diff_a)
            stats.sum_diff_a = x - x_true;
            stats.sum_diff_sq_a = (x - x_true) .^ 2;
        else
            stats.sum_diff_a = stats.sum_diff_a + x - x_true;
            stats.sum_diff_sq_a = stats.sum_diff_sq_a + (x - x_true) .^ 2;
        end
    end
  
    return
