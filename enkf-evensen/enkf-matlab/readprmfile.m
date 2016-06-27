% function [prm] = readprmfile(fname, prm, fmt, verbose)
%
% Reads parameters from a file.
%
% @param fname - file name
% @param prm - parameter structure
% @param fmt - format structure
% @param verbose - verbosity flag
%
% Note:  This is an internal procedure; for reading in the parameters from a 
%        file with the idea etc. to run main() -- consider using get_prm() 
%        instead.

% File:           readprmfile.m
%
% Created:        31/08/2007
%
% Last modified:  20/02/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Reads parameters from a file.
%
% Description:    This is an internal procedure; for reading parameters from a
%                 file consider using get_prm() instead.
%
% Revisions:      20/02/2008 PS - added TAB ("\t") to separators along with
%                   SPACE. This proved rather simple in the end - via sprintf().

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [prm] = readprmfile(fname, prm, fmt, verbose)
    
    VERBOSE_DEF = 1;
    SEP = sprintf(' \t');
    
    if ~exist('fname', 'var')
        return
    end
    if ~exist(fname, 'file')
        error(sprintf('\n  EnKF: error: readprmfile(): could not open parameter file \"%s\"', fname));
    end

    f = fopen(fname);
    lno = 1;
  
    while 1
        linestr = fgetl(f);
        if ~ischar(linestr)
            break
        end
        if isempty(linestr) | linestr(1) == '#'
            continue
        end
    
        [field, str] = strtok(linestr, SEP);
        value = strtok(str, SEP);
    
        if isempty(str) | isempty(value)
            error(sprintf('\n  EnKF: error:  readprmfile(): \"%s\": could not interpret l.%d: \"%s\"', fname, lno, linestr));
        end
    
        if ~isfield(prm, field)
            error(sprintf('\n  EnKF: error:  readprmfile(): \"%s\": could not interpret l.%d: \"%s\": \"%s\": unknown field', fname, lno, linestr, field));
        end
    
        format = getfield(fmt, field);
        prm = setfield(prm, field, sscanf(value, format));
    
        lno = lno + 1;
    end
  
    if ~exist('verbose', 'var')
        if isfield(prm, 'verbose')
            verbose = prm.verbose;
        else
            verbose = VERBOSE_DEF;
        end
    end
    
    if verbose > 1
        fields = fieldnames(prm);
        nf = length(fields);
        fprintf('  reading \"%s\":\n', fname);
        for s = 1 : nf
            field = fields(s);
            format = getfield(fmt, char(field));
            if strcmp(format, 'none')
                continue;
            end
            fstr = ['    %-15s = ' format '\n'];
            fprintf(fstr, char(field), getfield(prm, char(field)));
        end
    end

    fclose(f);
    
    return
    