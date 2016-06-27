% function [x, x_true, E, stats] = fmain(prmfname, x_true0, E0, stats0)
%
% Runs the system using parameters read from a parameter file.
%
% @param prmfname - system parameter file (structure, see get_prmstruct.m)
% @param x_true0 - initial true field (n x 1, optional)
% @param E0 - initial ensemble (n x m, optional)
% @param stats0 - initial statistics (structure, optional)
% @return x - final analysis (n x 1)
% @return x_true - final true field (n x 1)
% @return E - final ensemble (n x m)
% @return stats - final statistics (structure)
%
% Usage:
%
% [x, x_true, E, stats] = fmain(prmfname)
%   - conduct a run with a freshly generated ensemble
% [x, x_true, E, stats] = fmain(prmfname, x_true0)
%   - conduct a run with a freshly generated ensemble and specified true field
% [x, x_true, E, stats] = fmain(prmfname, x_true0, E0)
%   - conduct a run with specified true field and ensemble
% [x, x_true, E, stats] = fmain(prmfname, x_true0, E0, stats0)
%   - conduct a run with specified true field and ensemble; and append the 
%     existing statics rather than start it from scratch

% File:           fmain.m
%
% Created:        31/08/2007
%
% Last modified:  08/02/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%
% Purpose:        Main method for ensemble-based data assimilation.
%
% Description:    Runs the system using parameters read from a parameter file.
%
% Revisions:      25/08/2010 PS:
%                   - This file, formerly known as fmain_a.m, now replaced the
%                     previous (synchronous) version of fmain.m


%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [x, x_true, E, stats] = fmain(prmfname, x_true0, E0, stats0)
  
    % read parameters
    %
    prm = get_prm(prmfname);
  
    if nargin == 1
        [x, x_true, E, stats] = main(prm);
    elseif nargin == 2
        [x, x_true, E, stats] = main(prm, x_true0);
    elseif nargin == 3
        [x, x_true, E, stats] = main(prm, x_true0, E0);
    elseif nargin == 4
        [x, x_true, E, stats] = main(prm, x_true0, E0, stats0);
    else
        error('\n  EnKF: error: fmain(): wrong number of arguments');
    end

    return
