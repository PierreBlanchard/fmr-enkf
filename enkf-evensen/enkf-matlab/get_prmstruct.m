% function [prm, fmt] = get_prmstruct(prm)
%
% Creates two structures: prm -- to hold the system parameters; and fmt -- to
% hold the format strings for each parameter, used while reading from a file
%
% @param prm - system parameters (optional)
% @return prm - system parameters
% @return fmt - parameter formats
%
% Description of individual fields in the parameter file:
%
% field = method
%   - assimilation method
%   values =
%     DEnKF
%     ETKF
%     EnKF
%     Potter
%     EnOI
%
% field = rfactor1
%   - multiple for R (observation error covariance)
%   values =
%     <number> (1*)
%
% field = rfactor2
%   - (additional) multiple for R (observation error covariance) used for
%     anomalies update only
%   values =
%     <number> (1*)
%
% field = rotate 
%   - period of ensemble rotation (in model time steps); 0 = do not rotate; 
%     does not apply to EnOI; rounded to the nearest integer of assimilation
%     periods ("assim_step")
%   values =
%     <number> (0*)
%
% field = inflation
%   - inflation multiple for observed elements
% values =
%   <number>
%
% field = inflation_prm
%   - inflation multiple for unobserved elements ("parameters")
% values =
%   <number>
%
% field = model
%   - model tag
% values =
%   QG   - quasi-geostrophic model
%   LA   - linear advection model
%   LA2  - linear advection model (2 variables)
%   L40  - Lorenz-40 model (1996)
%   L40p - Lorenz-40 model with varying forcing parameter for parameter
%          estimation simulations
%   L3   - Lorenz-3 model (1965)
%   S    - sound model
%
% field = n
%   - if mult = 1 (for most of the models) then it is just the model state
%     vector length; if mult = 1 (for LA2 model) then 
%       n = (n_full - nprm) / mult, 
%     i.e. the state vector length for one variable. A bit complicated and may
%     be simplified in future
%   values =
%     <number>
%
% field = p
%   - number of obs at each assimilation cycle
%   values =
%     <number>
%
% field = p_inverse
%   - flag; whether to process observations in inverse order
%   values =
%     0*
%     1
%
% field = m
%   - ensemble size
%   values =
%     <number>
%
% field = nstep
%   - number of model steps in the run
%   values =
%     <number>
%
% field = assim_step
%   - number of model steps per assimilation step
%   values =
%     <number>
% 
% field = observe
%   - what variable to observe; important only for multivariate models with 
%     mult > 1
%   values =
%     A
%     A+B
%     A&B
%
% field = obs_step
%   - collect observations every obs_step model steps
%   values =
%     <number (0* -> assim_step)>
% 
% field = obs_spacing
%   - observation spacing
%   values =
%     regular
%     random
%     urandom (regular with random offset at each assimilation)
%
% field = obs_variance
%   - observation variance
%   values =
%     <number>
%
% field = alpha
%     - multiple for the anomaly matrix, for EnOI only
%   values =
%     <number>
%
% field = loc_len
%   - localisation length
%   values =
%     <number> (0 or NaN - no localisation)
%
% field = loc_function
%   - tag for the localisation function
%   values =
%     'Gauss'
%     'Gaspari_Cohn'
%     'Cosine'
%     'Cosine_Squared'
%     'Exp3'
%     'Lewitt'
%     'Cubic'
%     'Quadro'
%     'Step'
%
% field = loc_method
%   - localisation method
%   values =
%     'CF'*
%     'LA'
%
% field = rmse_max
%   - max allowed analysis rmse (divergence criterion)
%   values =
%     <max rmse (*NaN)>
%
% field = read_ens
%   - whether to read ensemble from the file saved during the last run
%   values =
%     0
%     1*
%
% field = randomise
%   - whether to randomise the initial state of the system
%   values =
%     0*
%     1
%
% field = seed
%   - initial seed for the random number generator; only if randomise = 0
%   values =
%     <number (0*)>
%
% field = plot_diag
%   - whether to plot diagnostics
%   values =
%     0
%     1*
%
% field = plot_diag_np
%   - number of last assimilation cycles to plot; only when the system runs --
%     all data will be plot on the end)
%   values =
%     <number (100*)>
%
% field = plot_state
%   - whether to plot the system state vector
%   values =
%     0
%     1*
%
% field = plot_prm
%   - whether to plot the current state of the parameter estimation; only for
%     models with nprm > 0
%   values =
%     0
%     1*
%
% field = rank_elem
%   - state vector element to be used for calculating rank diagrams
%   values =
%     <number (1*)>
%
% field = calc_bestrmse
%   - whether to calculate the best possible rmse with the initial ensemble
%   values =
%     0*
%     1
%
% field = verbose
%   values =
%     0*
%     1
%
% field = mult
%   - number of variables; not to be set from the parameter file
%   values =
%     <none>
%
% field = nx
%   - length of the grid in x direction for 2D models; not to be set from the
%     parameter file
%   values =
%     <none>
%
% field = nprm
%   - number of model parameters in the state vector; not to be set from the
%     parameter file
%   values =
%     <none>
%
% field = periodic
%   - whether the domain is periodic; not to be set from the parameter file
%   values =
%     <none>
%
% field = customprmfname
%   - name of the model-dependent parameter file; do not confuse with the model
%     parameter file!
%   values =
%     <file name>
%
% field = customprm
%   - structure with model-dependent parameters; not to be set from the
%     parameter file
%   values =
%     <none>
%
% field = version
%   - version string of the EnKF-Matlab code
%   values =
%     <none>
%
% field = enkfmatlabdir
%   - location of the EnKF-Matlab code
%   values =
%     <dir name>
%
% field = fatalnan
%   - whether encountering a nan generates a fatal error (that would disrupt
%     scripts)
%   values =
%     0
%     1*
%
% field = noasynchronous
%   - whether to assimilate synchronously despite asynchronous observations
%   values =
%     0*
%     1
%
% field = kfactor
%   - "K" parameter in adaptive observation prescreening
%   values =
%     <value of K (NaN*)>

% File:           get_prmstruct.m
%
% Created:        31/08/2007
%
% Last modified:  13/05/2011
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Creates two structures: prm -- to hold the system parameters;
%                 and fmt -- to hold the format strings for each parameter,
%                 used while reading from a file
%
% Description:    
%
% Revisions:      13.08.2008 PS: Changed the default value for `p_batchsize'
%                 from 100 to 0. If not specified explicitely, this forces it to
%                 be set equal in get_prm() to the total number of observations
%                 p. Fixed default value for `rotate' from '0' to 0.
%                 14.08.2008 PS: 
%                   - introduced field "periodic"
%                   - introduced field "loc_function"
%                 22.07.2009 PS:
%                   - renamed field "loc_framework" by "loc_method"; renamed
%                     options for this field from "global" to "CF" (for
%                     covariance filtering) and from "local" to LA (for local
%                     analysis).
%                 1.08.2009 PS:
%                   - added field "version"
%                 16.09.2009 PS:
%                   - added field "enkfmatlabdir" to simplify use outside
%                     EnKF-Matlab root directory
%                 25.08.2010 PS:
%                   - eliminated p_batchsize due to moving to the asynchronous
%                     assimilation
%                   - introduced inflation_prm
%                 20.04.2011 PS:
%                   - "rfactor" became "rfactor2"; also added "rfactor1"
%                 02.05.2011 PS:
%                   - added "noasynchronous"
%                 13.05.2011 PS:
%                   - added "kfactor"

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [prm, fmt] = get_prmstruct(prm)

    if ~exist('prm', 'var')
        prm = struct(                       ...
            'method',          {'ETKF'},    ...
            'rotate',          {0},         ...
            'rotate_ampl',     {1},         ...
            'rfactor1',        {1},         ...
            'rfactor2',        {1},         ...
            'inflation',       {1},         ...
            'inflation_prm',   {1},         ...
            'model',           {'none'},    ...
            'n',               {0},         ...
            'p',               {0},         ...
            'p_inverse',       {0},         ...
            'm',               {0},         ...
            'nstep',           {0},         ...
            'assim_step',      {0},         ...
            'observe',         {'A'},       ...
            'obs_step',        {0},         ...
            'obs_spacing',     {'regular'}, ...
            'obs_variance',    {0},         ...
            'alpha',           {1},         ...
            'loc_len',         {NaN},       ...
            'loc_function',    {'Gauss'},   ...
            'loc_method',      {'CF'},      ...
            'rmse_max',        {NaN},       ...
            'read_ens',        {1},         ...
            'randomise',       {0},         ...
            'seed',            {0},         ...
            'plot_diag',       {1},         ...
            'plot_diag_np',    {100},       ...
            'plot_state',      {1},         ...
            'plot_prm',        {0},         ...
            'plot_ens',        {0},         ...
            'diagn_type',      {''},        ...
            'rank_elem',       {1},         ...
            'calc_bestrmse',   {0},         ...
            'verbose',         {0},         ...
            'mult',            {1},         ...
            'nx',              {1},         ...
            'nprm',            {0},         ...
            'periodic',        {0},         ...
            'customprmfname',  {'none'},    ...
            'customprm',       {struct([])},...
            'version',         {'unknown'}, ...
            'enkfmatlabdir',   {'.'},       ...
            'fatalnan',        {1},         ...
            'noasynchronous',  {0},         ...
            'kfactor',         {NaN}        ...
            );
    end
  
    fmt = struct(                         ...
        'method',          {'%s'},        ...
        'rotate',          {'%d'},        ...
        'rotate_ampl',     {'%g'},        ...
        'rfactor1',        {'%g'},        ...
        'rfactor2',        {'%g'},        ...
        'inflation',       {'%g'},        ...
        'inflation_prm',   {'%g'},        ...
        'model',           {'%s'},        ...
        'n',               {'%d'},        ...
        'p',               {'%d'},        ...
        'p_inverse',       {'%d'},        ...
        'm',               {'%d'},        ...
        'nstep',           {'%d'},        ...
        'assim_step',      {'%d'},        ...
        'observe',         {'%s'},        ...
        'obs_step',        {'%d'},        ...
        'obs_spacing',     {'%s'},        ...
        'obs_variance',    {'%g'},        ...
        'alpha',           {'%g'},        ...
        'loc_len',         {'%g'},        ...
        'loc_function',    {'%s'},        ...
        'loc_method',      {'%s'},        ...
        'rmse_max',        {'%g'},        ...
        'read_ens',        {'%d'},        ...
        'randomise',       {'%d'},        ...
        'seed',            {'%d'},        ...
        'plot_diag',       {'%d'},        ...
        'plot_diag_np',    {'%d'},        ...
        'plot_state',      {'%d'},        ...
        'plot_prm',        {'%d'},        ...
        'plot_ens',        {'%d'},        ...
        'diagn_type',      {'%s'},        ...
        'rank_elem',       {'%d'},        ...
        'calc_bestrmse',   {'%d'},        ...
        'verbose',         {'%d'},        ...
        'mult',            {'none'},      ...
        'nx',              {'none'},      ...
        'nprm',            {'none'},      ...
        'periodic',        {'none'},      ...
        'customprmfname',  {'%s'},        ...
        'customprm',       {'none'},      ...
        'version',         {'%s'},        ...
        'enkfmatlabdir',   {'%s'},        ...
        'fatalnan',        {'%d'},        ...
        'noasynchronous',  {'%d'},        ...
        'kfactor',         {'%g'}         ...
        );
  
    return
