% File:           generate_samples.m
%
% Created:        18/01/2008
%
% Last modified:  08/02/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%
% Purpose:        Matlab script for generating samples for initial ensemble for
%                 L40p model
%
% Description:    Conducts a long integhration for TEND moel steps; varies
%                 forcing parameter F between FMIN and FMAX with period of T
%                 steps; saves dumps every TSAVE steps to "L40p_sample.mat".
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

TEND = 1000000;
T = 111;
FMIN = 7;
FMAX = 9;
TSAVE = 500;

F = (FMAX + FMIN) / 2.0;
A = (FMAX - FMIN) / 2.0;

x = zeros(41, 1);
x(10) = 0.01;

S = [];
for i = 1 : 1000000
    x(end) = F + A * sin(2 * pi * i / 111);
    x(1 : end - 1) = L40_step_c(0.05, x(1 : end - 1), x(end));
    if mod(i, TSAVE) == 0
        S = [S x];
    end
    if mod(i, 10000) == 0
        fprintf('.');
    end
end
fprintf('\n');

[n, n_sample] = size(S);
save L40p_samples.mat S n n_sample
