% function [x, t] = QG_step(prm, x, t, true_field)
%
% Conducts a step of QG model.
%
% @param prm - model parameters
% @param x - state vector
% @param t - time
% @param true_field - flag, whether true field (when 1) or ensemble field (0)
% @return x - state vector
% @return t - time

% File :          QG_step.m
%
% Created:        31/08/2007
%
% Last modified:  08/02/2008
%
% Author:         Pavel Sakov
%                 CSIRO Marine and Atmospheric Research
%                 NERSC
%
% Purpose:        Conducts a step of QG model.
%
% Description:    Depending
%
% Revisions:

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [x, t] = QG_step(prm, x, t, true_field)
  
  n = prm.n;
  nx = prm.nx;
    
  PSI = reshape(x, nx, n / nx);

  time(1) = t; % sorry for that
  
  if true_field | prm.n == 1089
      if exist(prm.customprm.fname_parameters_true, 'file')
          fname_parameters_true = prm.customprm.fname_parameters_true;
      else
          fname_parameters_true = sprintf('%s/%s', prm.enkfmatlabdir, prm.customprm.fname_parameters_true);
      end
      switch prm.n
        case 16641
          QG_step_f(time, PSI, fname_parameters_true);
        case 4225
          QGs_step_f(time, PSI, fname_parameters_true);
        case 1089
          QGt_step_f(time, PSI, fname_parameters_true);
        otherwise
          error(sprintf('\n  error: QG_step(): state vector size n = %d is not handled for this model', prm.n));
      end
  else
      if exist(prm.customprm.fname_parameters_ens, 'file')
          fname_parameters_ens = prm.customprm.fname_parameters_ens;
      else
          fname_parameters_ens = sprintf('%s/%s', prm.enkfmatlabdir, prm.customprm.fname_parameters_ens);
      end
      switch prm.n
        case 16641
          QG_step_f(time, PSI, fname_parameters_ens);
        case 4225
          QGs_step_f(time, PSI, fname_parameters_ens);
        otherwise
          error(sprintf('\n  error: QG_step(): state vector size n = %d is not handled for this model', prm.n));
      end
  end
  
  x = reshape(PSI, n, 1);

  if nargout == 2
    t = time(1);
  end
  
  return
