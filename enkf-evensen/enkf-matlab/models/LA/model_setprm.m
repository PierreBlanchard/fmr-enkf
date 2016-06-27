% function [prm] = model_setprm(prm)
%
% Conducts custom initialisation of the system parameters for LA model.
%
% @param prm - system parameters
% @return prm - system parameters

% File:           model_setprm.m
%
% Created:        31/08/2007
%
% Last modified:  14/08/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Conducts custom initialisation of the system parameters for
%                 LA model.
%
% Description:    Does nothing.
%
% Revisions:      14.08.2008 PS: added "prm.periodic = 1"

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [prm] = model_setprm(prm)
    
    prm.periodic = 1;
    
    return
