%% Copyright (C) 2008,2009 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

EnKF-Matlab
Matlab code for Ensemble Kalman Filter, with a number of simple models
Version 0.31
Last update: 12 June 2013

Please send comments and bug reports to Pavel Sakov: pavel.sakovatgmail.com.


1. EnKF-Matlab originally was a rather loose code that emerged over a number of
years in the course of experiments with Ensemble Kalman Filter (EnKF). In
particular, this code or its predecessors have been used in work on the
following papers:

* P. R. Oke, P. Sakov, and S. P. Corney. 
  Impacts of localisation in the EnKF and EnOI: Experiments with a small model. 
  Ocean Dynamics, 2006, 57, 32-45.
  http://www.cmar.csiro.au/staff/oke/pubs/Oke_et_al_2006_Ocean_Dynamics.pdf

* P. Sakov and P. R. Oke.
  Implications of the form of the ensemble transformation in the ensemble 
  square root filters. 
  Mon. Wea. Rev., 2008, 136, 1042-1053.
  http://enkf.nersc.no/Publications/sak08b.pdf

* P. Sakov and P. R. Oke. A deterministic formulation of the ensemble Kalman
  filter: an alternative to ensemble square root filters.
  Tellus, 2008, 60A, 361-371.
  http://enkf.nersc.no/Publications/sak08a.pdf

* Sakov, P., G. Evensen, and L. Bertino
  Asynchronous data assimilation with the EnKF.
  Tellus 62A, 2010, 24-29.

In the last year or two (2008-2009), this code has been brought to a
structurally decent shape. In 2009-2010 it evolved to incorporate assimilation 
of asynchronous observations.


2. EnKF-Matlab is designed primarily as a research and study tool. As a 
consequence, speed and memory usage are given a lower priority than simplicity 
and ease of use.

In particular, the code structure has been designed to maximally simplifiy the
representation of the analysis schemes in assimilate.m.


3. Available filters (analysis schemes):

EnKF -- perturbed observations EnKF (Evensen 1994, Burgers et al. 1998)
ETKF -- Ensemble Transform Kalman Filter (Bishop et al. 2001)
LESRF* -- Left-multiplied ESRF (Sakov & Oke 2008) (effective when m > n)
EnOI -- Ensemble Optimal Interpolation (?)
Potter -- serial Ensemble Square Root Filter (Whitaker & Hamill 2002)
DEnKF -- "deteministic" EnKF (Sakov & Oke 2008)

* The LESRF scheme has been taken out in version 0.28, in which the old
  (synchronous) code has been deprecated.

4. Available models:

- LA -- linear advection model (Evensen 2004)
  Represents a fixed profile (can be interpreted as tracer concentration) 
  composed from a number of harmonics with random amplitudes, propagated by 1
  cell at each time step
- LA2 -- linear advection model with two variables (Oke et al. 2006)
  Same as LA, except that a secondary variable that is (initially) a derivative
  of the first (primary) variable is added to study dynamic balance between the
  variables during assimilation.
- L3 -- 3-dimensional Lorenz model (Lorenz 1965)
- L40 -- 40-dimensional Lorenz model (Lorenz 1996)
- L40p -- as above, with varying forcing as a parameter
  Designed to demonstrate parameter estimation with ensemble Kalman filters.
- S -- Sound model (-)
  Similar to LA, except that two profiles are generated, moving in opposite
  directions. A linear, periodic in time model, but not static like LA or LA2.
- QG -- Quasigeostrophic 1.5-layer reduced gravity model (-)
  127 x 127 QG model (excluding the boundary) implemented in Fortran90.

model | linear | static | phys. dim. | state vector dim. | model subspace dim.

 LA       Yes      Yes      1D         1000                51
 LA2      Yes      Yes      1D         2000                51
 S        Yes      No       1D         1000                102
 L3       No       No       1D         3                   about 2
 L40      No       No       1D         40                  13+
 L40p     No       No       1D         41                  varying, around 13+
 L40b     No       No       1D         41                  about 13+
 QG       No       No       2D         16641/4225/1089     a few hundred (?)

All models but QG are implemented in Matlab. For L3 and L40 models there is 
also C code that, once compiled with the mex compiler, increases the 
effectiveness of the system by a significant factor. Beware that the compiled 
code has fewer options that the Matlab code (the model step can only be a 
single step of the RK4 integrartor.) To run QG model, one has to compile the 
Fortran code or use the pre-compiled binaries.

Another significant factor that may affect the effectiveness is the graphical
output, which can be turned off by setting

plot_diag       0
plot_state      0

in the parameter file.


5. To run a quick test, in Matlab run one of the following commands:

>> [x, x_true, E, stats] = fmain('prm/prm-L3-m=2.txt');
>> [x, x_true, E, stats] = fmain('prm/prm-L3-m=3.txt');
>> [x, x_true, E, stats] = fmain('prm/prm-L40-etkf.txt');
>> [x, x_true, E, stats] = fmain('prm/prm-L40-etkf-loc.txt');
>> [x, x_true, E, stats] = fmain('prm/prm-L40p.txt');
>> [x, x_true, E, stats] = fmain('prm/prm-L40b.txt');
>> [x, x_true, E, stats] = fmain('prm/prm-LA.txt');
>> [x, x_true, E, stats] = fmain('prm/prm-LA2.txt');
>> [x, x_true, E, stats] = fmain('prm/prm-S.txt');
>> [x, x_true, E, stats] = fmain('prm/prm-QG-denkf.txt');
>> [x, x_true, E, stats] = fmain('prm/prm-QG-etkf.txt');
>> [x, x_true, E, stats] = fmain('prm/prm-QG-potter.txt');
>> [x, x_true, E, stats] = fmain('prm/prm-QG-enoi.txt');
>> [x, x_true, E, stats] = fmain('prm/prm-QG-enkf.txt');
>> [x, x_true, E, stats] = fmain('prm/prm-QGs-denkf.txt');
>> [x, x_true, E, stats] = fmain('prm/prm-QGs-enkf.txt');
>> [x, x_true, E, stats] = fmain('prm/prm-QGt-denkf.txt');
>> [x, x_true, E, stats] = fmain('prm/prm-QGt-etkf.txt');
>> [x, x_true, E, stats] = fmain('prm/prm-QGt-potter.txt');

(See README in prm directory.)

Note that you will have to create or download samples for QG and QGs (small QG) 
models to run these systems; however you must be able to run QGt (tiny QG) model
out of the box.


6. The DA system is run by calling fmain() (that reads parameters from a file)
or main() (that reads parameters from a structure). main() may be more
convenient to call when running batch jobs. But see the headers of fmain.m and
main.m for more details.


7. A description of the common (among all models) fields in the parameter file 
can be found in the header of get_prmstruct.m. Model-specific parameters are
handled by model-specific code in models/<model tag>/model_getprmstruct.m.


8. The code directory structure is as follows:

enkf-matlab 
  - contains generic code, including launching, running, plotting, reading
    parameters, and calculating some common tasks.
enkf-matlab/bin 
  - compiled code (binaries) for some architectures
enkf-matlab/models 
  - model-specific code for a number of models
enkf-matlab/models/common 
  - code shared by several models
enkf-matlab/models/<model name> 
  - model-specific code
enkf-matlab/prm 
  - some sample parameter files
enkf-matlab/samples 
  - files with collection of model dumps for some model used for the initial
    enesmble
enkf-matlab/tools
  - some analysis/plotting tools not used directly by EnKF code


9. This software has been created under/for *nux, but should be portable to run
under Windows. If the system does not find a compiled version for L40 or L3
models it then tries to run the (slower) Matlab code. 


10. If you manage to compile binaries for some model(s) that are not in the 
package - I would much appreciate if you shared those.


11. If you use EnKF-Matlab and find it useful, please drop me a line.


12. The author gratefully acknowledge funding from the eVITA-EnKF project by the
Research Council of Norway while developing the EnKF-Matlab code in the period
from December 2007 to September 2009.


13. Please acknowledge use of this software in publications.
