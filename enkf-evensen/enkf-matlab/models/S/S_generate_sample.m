% function [x] = S_generate_sample(prm, kstart, kstep, kend)
%
% Generates an instance of the state vector for S model.
%
% @param prm - system parameters
% @param kstart - smallest wave number
% @param kstep - wave number step
% @param kend - largest wave number
% @return x - an instance of a state vector

% File:           S_generate_sample.m
%
% Created:        31/08/2007
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%
% Purpose:        Calculates a sample field for the S model
%
% Description:    Is based on LA_generate_sample().
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [x] = S_generate_sample(prm, kstart, kstep, kend)
  
    x = LA_generate_sample(prm, kstart, kstep, kend);
    y = LA_generate_sample(prm, kstart, kstep, kend);
  
    x = [x; y];

    return
