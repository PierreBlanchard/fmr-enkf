% function model_getHE(prm, H, E)
%
% Default procedure for getting ensemble observations for L40b model.
%
% @param prm - system parameters
% @param H - observation sensitivity matrix
% @param E - ensemble matrix
% @return HE - ensemble observations

% File:           model_getHE.m
%
% Created:        25/08/2010
%
% Last modified:  25/08/2010
%
% Author:         Pavel Sakov
%                 NERSC
%
% Purpose:        Default procedure for getting ensemble observations for L40b
%                 model.
%
% Description:    
%
% Revisions:      None

%% Copyright (C) 2010 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [HE] = model_getHE(prm, H, E)

    % The last element of the state vector in this model is the bias estimate;
    % therfore
    %
    HE = H * E + repmat(E(end, :), prm.p, 1);
    
    return
