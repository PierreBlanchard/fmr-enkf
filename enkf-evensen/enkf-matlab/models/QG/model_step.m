% function [x, t] = model_step(prm, x, t, true_field)
%
% Performs one step of QG model.
%
% @param prm - system parameters
% @param x - state vector
% @param t - time
% @param true_field - flag, whether true field (when 1) or ensembl field (0)
% @return x - state vector
% @return t - time

% File:           model_step.m
%
% Created:        31/08/2007
%
% Last modified:  08/02/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Performs one step of LA model
%
% Description:
%
% Revisions:      13082008PS: -- introduced a couple of checks

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [x, t] = model_step(prm, x, t, true_field);
    
    % "just in case" check
    %
    if x(1) ~= 0
        error(sprintf('\n  error: QG: field(1, 1) = %.3g\n', x(1)));
    end

    if nargout == 1
        x = QG_step(prm, x, t, true_field);
    else
        [x, t] = QG_step(prm, x, t, true_field);
    end
    
    if prm.fatalnan & isnan(sum(x))
        error(sprintf('\n  error: QG: NaNs in the field after integration at t = %f', t));
    end
    
    return
