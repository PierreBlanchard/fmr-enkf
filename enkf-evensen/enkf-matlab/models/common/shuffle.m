% function [pack] = shuffle(n)
%
% Returns randomly shuffled array of numbers from 1 to n.
%
% @param n - size of the array
% @return pack - shuffled array of numbers from 1 to n

% File: shuffle.m
%
% Created:        31/08/2007
%
% Last modified:  08/02/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Returns randomly shuffled array of numbers from 1 to n.
%
% Description:    
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [pack] = shuffle(n)
    pack = 1 : n;
    for i = 1 : n
        ii = floor(rand * n) + 1;
        val_ii = pack(ii);
        pack(ii) = pack(i);
        pack(i) = val_ii;
    end
  
    return
