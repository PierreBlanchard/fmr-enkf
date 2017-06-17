clear all
close all




% Add enkf-evensen to load path
test_dir=pwd()
addpath(test_dir)
enkf_dir=[fileparts(pwd()) '/enkf-evensen/enkf-matlab']
addpath(genpath(enkf_dir))

% Move to enkf directory (necessary for initialization)
cd(enkf_dir)

% Set parameters using enkf-evensen's prm routines
prmfname='prm/prm-L3-m=2.txt'
prm = get_prm(prmfname);
prm = setpath(prm);

% Assemble covariance
R=calc_r(prm);

% Take square root
sqrt_of_R = precomp_sqrt(R)


cd(test_dir)	