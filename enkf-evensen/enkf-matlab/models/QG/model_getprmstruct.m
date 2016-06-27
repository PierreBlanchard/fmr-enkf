% function [prm, fmt] = model_getprmstruct
%
% Reads custom parameter structure for QG model.
%
% @return prm - system parameters
% @return fmt - parameter formats
%
% Description of individual fields in the parameter file:
%
% field = fname_parameters_true
%   - parameter file for the true field
% value =
%   <file name>
%
% field = fname_parameters_ens
%   - parameter file for the ensemble members
% value =
%   <file name>
%
% field = fname_samples_true
%   - file with field dumps for initialisation of the true field
% value =
%   <file name>
%
% field = fname_samples_ens
%   - file with field dumps for initialisation of the ensemble field
% value =
%   <file name>

% File:           model_getprmstruct.m
%
% Created:        31/08/2007
%
% Last modified:  08/02/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Last modified:  18/01/2008
%
% Purpose:        Creates two structures: prm -- to hold the system parameters;
%                 and fmt -- to hold the format strings for each parameter,
%                 used while reading from a file
%
% Description:    
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [prm, fmt] = model_getprmstruct
    
    prm = struct(                            ...
        'fname_parameters_true', {'none'},   ...
        'fname_parameters_ens', {'none'},    ...
        'fname_samples_true', {'none'},      ...
        'fname_samples_ens', {'none'}        ...
        );

    fmt = struct(                            ...
        'fname_parameters_true', {'%s'},     ...
        'fname_parameters_ens', {'%s'},      ...
        'fname_samples_true', {'%s'},        ...
        'fname_samples_ens', {'%s'}          ...
        );
    
    return
