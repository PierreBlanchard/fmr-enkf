% function [prm] = get_prm(fname)
%
% Reads parameters from files into the prm structure
%
% @param fname - parameter file name
% @return prm - system parameters
%
% Note: the parameter file has the following format:
%
% <parameter1 tag> <parameter1 value>
% <parameter2 tag> <parameter2 value>
% ...
%
% The tag and value should be separated by spaces only; TABs are not allowed!
% For details look at get_prmstruct.m

% File:           get_prm.m
%
% Created:        3/08/2007
%
% Last modified:  03/08/2009
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Reads parameters from files into the prm structure
%
% Description:    
%
% Revisions:      3.08.2009 PS:
%                   - got rid of references to LETKF
%                   - check that ETKF is not run with CF localisation

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [prm] = get_prm(fname)

    % 1. read main parameter file
    %
    [prm, fmt] = get_prmstruct;
    prm.version = get_version;
    prm = readprmfile(fname, prm, fmt);
    
    %
    % 2. make the necessary checks and adjustments
    %
    
    % set obs_step to assim_step if necessary
    %
    if prm.obs_step == 0
        prm.obs_step = prm.assim_step;
    end
    
    % set rotation period to the closest integer of assimilation period
    %
    if prm.rotate > 0
        if prm.rotate < prm.assim_step
            prm.rotate = prm.assim_step;
        else
            prm.rotate = round(prm.rotate / prm.assim_step) * prm.assim_step;
        end
    end
    
    % 3. set the paths
    %
    prm = setpath(prm);
    
    % 4. read model-specific parameter file
    %
    [customprm, customfmt] = model_getprmstruct;
    if exist(prm.customprmfname, 'file')
        customprmfname = prm.customprmfname;
    else
        customprmfname = sprintf('%s/%s', prm.enkfmatlabdir, prm.customprmfname);
    end
    prm.customprm = readprmfile(customprmfname, customprm, customfmt, prm.verbose);
    
    % 5. do not run ETKF with CF localisation
    %
    if strcmp(prm.method, 'ETKF') & strcmp(prm.loc_method, 'CF') & prm.loc_len > 0
        error('\n  EnKF: error: get_prm(): prm.loc_method = \"CF\" is not supported with prm.method = \"ETKF\"');
    end
    
    prm = model_setprm(prm);
    
    return
