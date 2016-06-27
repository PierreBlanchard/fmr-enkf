% function [version] = get_version()
%
% Returns the version tag for the EnKF-Matlab code
%
% @return version - version string
%
% File:           get_version.m
%
% Created:        3/8/2009
%
% Last modified:  01/10/2009
%
% Author:         Pavel Sakov
%                 NERSC
%
% Purpose:        Provides access to the version tag
%
% Description:
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 

function [version] = get_version()
    
    version = '0.31';
    
    return
