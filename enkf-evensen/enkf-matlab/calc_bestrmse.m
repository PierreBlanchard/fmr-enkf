% function [rmse] = calc_bestrmse(x, E)
% Calculates the best possible RMSE for a given true field and ensemble
%
% @param x - true field (n x 1)
% @param E - ensemble (n x m)
% @return rmse - RMSE value

% File:           calc_bestrmse.m
%
% Created:        31/08/2007
%
% Last modified:  08/02/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%
% Purpose:        Calculates the best possible RMSE for a given true field and
%                 ensemble
%
% Description:    Solves E * s = x in the least squares sense;
%                 then xbest = E * s.
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [rmse] = calc_bestrmse(x, E)

    [n, m] = size(E);
  
    if n > 1000
        rmse = 0;
        return ;
    end
  
    c = rcond(E * E');
    
    if c > 1.0e-6
        s = inv(E' * E) * E' * x;
    else
        warning off;
        s = lscov(E, x);
        warning on;
    end

    xbest = E * s;
    rmse = std(xbest - x, 1);
  
    return
