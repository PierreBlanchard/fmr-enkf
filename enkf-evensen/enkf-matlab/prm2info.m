% function [str] = prm2info(prm)
%
% Converts system parameters to a string, suitable for output in a window.
%
% @param prm - system parameters @return str - ouput string

% File:          prm2info.m
%
% Created:       31/08/2007
%
% Last modified: 08/02/2008
%
% Author:        Pavel Sakov CSIRO Marine and Atmospheric Research
%
% Purpose:       Contains core code for data assimilation with EnKF systems.
%
% Description:   Converts system parameters to a string, suitable for output
%                in a window.
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [str] = prm2info(prm)

    [prm, fmt] = get_prmstruct(prm);
  
    str = [];
    line = [];
  
    fields = fieldnames(prm);
    nf = length(fields);
    for s = 1 : nf
        field = fields(s);
        format = getfield(fmt, char(field));
        if strcmp(format, 'none')
            continue;
        end
        fstr = ['%s = ' format];
        this = sprintf(fstr, char(field), getfield(prm, char(field)));
        if isempty(line)
            line = this;
        elseif length([line ', '  this]) < 50
            line = [line ', '  this];
        elseif isempty(str)
            str = sprintf('%s\n', line);
            line = this;
        else
            str = sprintf('%s%s\n', str, line);
            line = this;
        end
    end
    str = sprintf('%s%s', str, line);
  
    return
