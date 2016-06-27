% function [prm] = model_setprm(prm)
%
% Conducts custom initialisation of the system parameters for S model.
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
%                 S model.
%
% Description:    Sets the number of model fields to 2.
%
% Revisions:      14.08.2008 PS: added "prm.periodic = 1"

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [prm] = model_setprm(prm)
    
    prm.mult = 2;
    prm.periodic = 1;
    
    return
