% function [] = setpath(prm)
%
% Sets path to include the current model directory.
%
% @param prm - system parameters
% @return prm - system parameters

% File:           setpath.m
%
% Created:        10/01/2008
%
% Last modified:  21/09/2009
%
% Author:         Pavel Sakov
%                 NERSC
%
% Purpose:        Sets path to include:
%                   ./bin
%                   ./model/common
%                   ./model/<model>
%
% Description:    First removes the previous model directory from the path to
%                 make sure that the procedures from the model run prior to the
%                 current one are not executed. After that adds the current
%                 model directory to the path. Also adds the bin directory if
%                 it is not in the path.
%
% Revisions:      15.09.2009 PS:
%                   - added path to the "stats" directory
%                   - added path to the "tools" directory
%                   - started to use samedir() to find whether directories are
%                     the same
%                 21.09.2009 PS:
%                   - fixed a defect
%                 09.11.2009 PS:
%                   - set a path separator to ';' for a PC - thanks to Oliver
%                     Pajonk for the bug report

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [prm] = setpath(prm)
    
    str = path;
    if ispc
        [firstdir, str] = strtok(str, ';');
    else
        [firstdir, str] = strtok(str, ':');
    end
    
    modelpath = sprintf('%s/models/%s', prm.enkfmatlabdir, prm.model);
    if samedir(modelpath, firstdir) % nothing to do
        return
    end
    
    % remove the previos model directory from the path
    %
    dirs = dir(sprintf('%s/models', prm.enkfmatlabdir));
    for i = 1 : length(dirs)
        modelname = dirs(i).name;
        if ~strcmp(modelname, '.') & ~strcmp(modelname, '..')
            amodelpath = sprintf('%s/models/%s', prm.enkfmatlabdir, modelname);
            if samedir(amodelpath, firstdir)
                rmpath(firstdir);
                break
            end
        end
    end
    
    % add the necessary directories from the EnKF-Matlab root to the path
    %
    if ispc
        [firstdir, str] = strtok(str, ';');
    else
        [firstdir, str] = strtok(str, ':');
    end
    binpath = sprintf('%s/bin', prm.enkfmatlabdir);
    %
    % (with the model directory removed from the path, the bin directory should
    % be on the top if the path has been already updated)
    %
    if ~samedir(binpath, firstdir)
        commonpath = sprintf('%s/models/common', prm.enkfmatlabdir);
        path(commonpath, path);
        statspath = sprintf('%s/stats', prm.enkfmatlabdir);
        path(statspath, path);
        toolspath = sprintf('%s/tools', prm.enkfmatlabdir);
        path(toolspath, path);
        path(binpath, path);
    end
    
    % add the model directory to the top of the path
    %
    modelpath = sprintf('%s/models/%s', prm.enkfmatlabdir, prm.model);
    path(modelpath, path);
    
    return

function [answer] = samedir(dir1, dir2)
% 
% Checks if two directories are actually the same. The first directory must
% exist, the second may not.
    
    if ~exist(dir1, 'dir')
        error(sprintf('\n  EnKF: error: setpath(): samedir(): directory \"%s\" does not exist', dir1));
    elseif ~exist(dir2, 'dir')
        answer = 0;
    else
        cwd = pwd;
        cd(dir1);
        name1 = pwd;
        cd(cwd);
        cd(dir2);
        name2 = pwd;
        answer = strcmp(name1, name2);
        cd(cwd);
    end
    
    return
