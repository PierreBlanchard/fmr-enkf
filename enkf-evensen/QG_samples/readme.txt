Files QG_samples-11.mat and QG_samples-12.mat are used for the initial
ensemble and initial true field, correspondingly, of data assimilation systems
with the quasigeostrophic (QG) model. The file QGs_samples.mat is used with
the "small" (65 x 65) version of the QG model.

All 3 files are necessary in the default setup. We make them available for
download to simplify the setup of the system, so that users could start
experimenting with the QG model straight away, without first generating those
files. After downloading, copy them to directory `enkf-matlab/samples'.

QG_samples-12.mat contains 195 dumps from a long run of the QG model with
biharmonic dissipation set to 2e-12.

QG_samples-11.mat contains 990 dumps from a run with dissipation of 2e-11.

QGs_samples.mat contains 501 dumps from QGs run with dissipation of 2e-11.

The default setup of the QG model involves using different dissipation for true 
field and ensemble. While users are free to experiment with the system setup,
using higher dissipation for the ensemble achieves better stability of the
system because (I think) it helps to dump the dynamical inconsistencies
introduced in the DA updates.

The default setup of the small version of QG (QGs) runs the true field and the 
ensemble with the same settings.

22 August 2008
Pavel Sakov

modified on 4 Februrary 2009

note on 27 February 2009: 
  replaced the files QG_samples-12.mat and QG_samples-11.mat by the previous
  version that makes the QG-based DA systems to run much more stabely.
