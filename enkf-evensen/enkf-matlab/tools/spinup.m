% function [x, x_true, E, stats, x_true0] = spinup(prm, spinup_variances,
%                                     variance, full_length, full_size, verbose)
%
% Spins up the system, starting from a wide historic ensemble and big 
% observation error variance and progressing to smaller observation error
% variance. 

% The system runs for a number of intervals, each of `prm.nstep' steps,
% conducted with consequitive values of observation error variance from the
% input array `spinup_variances'. After reaching observation error variance
% equal to `variance', it will run either the last interval, or, if 
% `full_spinup = 1', until the full (maximal) length of spinup has been
% reached. If `full_size = 1' then the spinup is conducted with a full rank
% ensemble (prm.m = prm.n + 1) and is redrawn after completion to the initial
% size  `prm.m' if necessary.
%
% @param prm - system parameters used in spinup(structure, see get_prmstruct.m)
% @param spinup_variances - array of spinup variances to be used in the process
% @param variance - final observation error variances
% @param full_length - flag, whether to run the full length according to the
%                      length of `spinup_variances' (1), or until the specified 
%                      variance is reached (0*)
% @param full_size - flag, whether to use a full rank ensemble and redraw in
%                    the end to the specified size (1), or use the specified
%                    size all the way (0*)
% @param verbose - flag; overrides prm.verbose
% @return x - final analysis (n x 1)
% @return x_true - final true field (n x 1)
% @return E - final ensemble (n x m)
% @return stats - final statistics (structure)
% @return x_true0 - initial true field

% File:           spinup.m
%
% Created:        09/04/2010
%
% Last modified:  09/04/2010
%
% Author:         Pavel Sakov
%                 NERSC
%
% Purpose:        Gradual system spinup.
%
% Description:    Spins up the system, starting from a wide historic ensemble
%                 and big observation error variance and progressing to smaller
%                 observation error variance.
%
% Revisions:     

%% Copyright (C) 2010 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [x, x_true, E, stats, x_true0] = spinup(prm, spinup_variances, variance, full_length, full_size, verbose)
    
    if ~exist('full_length', 'var')
        full_length = 0;
    end
    if ~exist('full_size', 'var')
        full_size = 0;
    end
    if ~exist('verbose', 'var')
        verbose = prm.verbose;
    end
    
    nspinup = length(find(spinup_variances > variance)) + 1;
    if nspinup > length(spinup_variances)
        error(sprintf('\n  error: spinup(): variance = %.3g should not be smaller than spinup_variances(end) = %.3g\n', variance, spinup_variances(end)));
    end
    spinup_variances(nspinup : end) = variance;
    
    if full_length
        niter = length(spinup_variances);
    else
        niter = nspinup;
    end
    
    m = prm.m;
    if full_size & prm.m < prm.n + 1
        prm.m = prm.n + 1;
    end
    
    nstep = prm.nstep;
    tmp = prm;
    tmp.nstep = 0;
    tmp.plot_diag = 0;
    tmp.plot_state = 0;
    [tmp, x_true0] = main(tmp);
    x_true = x_true0;
    E = [];
    stats = [];
    prm.nstep = nstep;
    
    if verbose
        fprintf('  spinning up the system:');
    end
    for i = 1 : niter
        prm.obs_variance = spinup_variances(i);
        [x, x_true, E, stats] = main(prm, x_true, E, stats);
        if stats.step ~= prm.nstep * i
            error(sprintf('\n  error: spinup(): divergence: iteration %d: stats.step(end) = %d (expected %d)\n', i, stats.step(end), prm.nstep * i));
        end
        if verbose & ~prm.verbose
            fprintf('.');
        end
    end
    if verbose
        fprintf('done\n');
    end
    
    if prm.m > m
        if verbose
            fprintf('  redrawing ensemble from %d to %d members...', prm.m, m);
        end
        A = E - repmat(x, 1, prm.m);
        A = redraw_ensemble(A, m);
        E = A + repmat(x, 1, m);
        prm.m = m;
        if prm.verbose
            fprintf('done\n');
        end
    end
    
    return
