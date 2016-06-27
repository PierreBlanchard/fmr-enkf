% function [] = set_colormap
%
% For each subplot in the figure (independently) this function
% 1. sets the displayed range to be symmetric around zero, and
% 2. sets the color to be close to white for values close to zero

% File:           set_colormap.m
%
% Created:        November 2009
%
% Last modified:  10/12/2009
%
% Author:         Pavel Sakov
%                 NERSC
%
% Purpose:        Sets a sensible colormap
% 
% Description:
%
% Revisions:

%% Copyright (C) 2009 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [] = set_colormap

    subplots = get(gcf, 'children')';
    
    if isempty(subplots)
        return
    end
    
    factor = -1;
    for a = subplots
        c = caxis(a);
        factor = max(factor, max(abs(c)) / (c(2) - c(1)));
    end
    
    m = max(floor(factor * 64), 1024);
    w = white(m);
    colormap(w);
    
    for a = subplots
        absmax = max(caxis(a));
        caxis(a, [-absmax, absmax]);
    end
    
    return
    
function w = white(m)
    
    if nargin == 0
        m = size(get(gcf, 'colormap'), 1);
    end
    
    taper = exp(- ([-5 : 10 / (m - 1) : 5]) .^ 2);
    taper = (1 - abs([-5 : 10 / (m - 1) : 5]) / 5) .^ 4;
    w = jet(m);
    w = w + (1 - w) .* repmat(taper', 1, 3);
    
    return
