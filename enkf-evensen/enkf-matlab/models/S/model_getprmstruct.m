% function [prm, fmt] = model_getprmstruct
%
% Reads custom parameter structure for S model.
%
% @return prm - system parameters
% @return fmt - parameter formats
%
% Description of individual fields in the parameter file:
%
% field = kstart_model
%   - minimal "wave number" for the ensemble fields and "climatology"
% value =
%   <value> (0*)
%
% field = kend_model
%   - maximal "wave number" for the ensemble fields and "climatology"
% value =
%   <value> (25*)
%
%
% field = kstep_model
%   - step of the "wave number" for the ensemble fields and "climatology"
% value =
%   <value> (1*)
%
% field = kstart_true
%   - minimal "wave number" for the true field
% value =
%   <value> (0*)
%
% field = kend_true
%   - maximal "wave number" for the true field
% value =
%   <value> (25*)
%
% field = kstep_true
%   - step of the "wave number" for the true field
% value =
%   <value> (1*)
%
% field = addref
%   - flag; whether to add another sample ("climatology") to all samples
% value =
%   0
%   1*

% File:           model_getprmstruct.m
%
% Created:        31/08/2007
%
% Last modified:  18/01/2008
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
    
    prm = struct(                ...
        'kstart_model', {0},     ...
        'kend_model',   {25},    ...
        'kstep_model',  {1}    , ...
        'kstart_true',  {0},     ...
        'kend_true',    {25},    ...
        'kstep_true',   {1},     ...
        'addref',       {1}      ...
        );
  
    fmt = struct(                ...
        'kstart_model', {'%d'},  ...
        'kend_model',   {'%d'},  ...
        'kstep_model',  {'%d'},  ...
        'kstart_true',  {'%d'},  ...
        'kend_true',    {'%d'},  ...
        'kstep_true',   {'%d'},  ...
        'addref',       {'%d'}   ...
        );

    return
