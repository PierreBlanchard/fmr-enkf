clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Run in matlab command line interface (cli):
%% $ matlab -nodekstop
%%
%% or matlab graphic user interface (gui)
%% $ matlab &
%%
%% or even in octave
%% $ octave
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Define global variables and paths used by the interface

% Define FMR's api and home directory 
global fmr_home_directory 
% Path to MatlabAPI
matlabapi_directory = [fileparts(pwd()) '/fmr-dev/Addons/MatlabAPI'];
% Add all subdirs of API to search path
addpath(genpath(matlabapi_directory));
% Get path to FMR home directory
fmr_home_directory = getPathToFMR;

% Interface verbose?
global verbose_cpp
verbose_cpp=true;
global verbose_make
verbose_make=true;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Description:
%%
%% This is an example of Randomized SVD factorization
%% powered by dense MMPs.
%% 
%% The covariance matrix is assembled in the C++ routine
%% by evaluating a correlation function on the grid.
%%
%% [TODO] Avoid assembling covariance and use FMM powered MMPs.
%%
%% Pierre Blanchard (pierre.blanchard@inria.fr)
%% July, 4th 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Grid (artificial or load from other code)

% Define new grid or read existing grid?
grid_is_new=true; % default is true

% Size of the grid
grid_size=2000;

%grid_name='unitSegment'
%grid_points(1,:)=linspace(-1,1,grid_size)*0.0;
%grid_points(2,:)=linspace(-1,1,grid_size);
%grid_points(3,:)=linspace(-1,1,grid_size)*0.0;
%grid_width=1;
%grid_center=[0.,0.,0.];
%grid_binaryformat=false;

grid_name='unitGrid';
grid_points(1,:)=linspace(-1,1,grid_size);
grid_points(2,:)=linspace(-1,1,grid_size);
grid_points(3,:)=linspace(-1,1,grid_size);
grid_width=1;
grid_center=[0.,0.,0.];
grid_binaryformat=false;

%% The 'unitSphere' grid was already precomputed in scalfmm (in binary format)
%grid_name='unitSphere'
%grid_points=zeros(3,1);
%grid_width=0.;
%grid_center=[0.,0.,0.];
%grid_binaryformat=true;
%grid_is_new=false;
%%

% Grid structure
gridz = struct('size',grid_size, ...
                'points',grid_points, ...
                'name',grid_name, ...
                'width',grid_width, ...
                'center',grid_center, ...
                'directory',[fmr_home_directory '/Addons/MatlabAPI/Data/FMAInputGrids'], ...
                'filename',[grid_name num2str(grid_size)], ...
                'binaryformat',grid_binaryformat ...% Set to true if grid stored in binary format
                );

% Grid full filename
if(gridz.binaryformat)
    grid_fileextension='.bfma';
else
    grid_fileextension='.fma';
end%
grid_fullfilename=[gridz.directory '/' gridz.filename grid_fileextension];
gridz.('fullfilename')=grid_fullfilename


% Write grid in file (need to translate from matlab to scalfmm/fmr format)
% [TODO] write in binary format
if(grid_is_new)
    storeGrid(gridz);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Correlation kernel
correlation_name='Gauss';
correlation_length=0.5;
% Correlation structure
correlationz = struct('name',correlation_name, ...
                    'length',correlation_length, ...
                    'directory',[fmr_home_directory '/Addons/MatlabAPI/Data/Matrices/Covariance'], ...
                    'filename',[correlation_name(1) num2str(100*correlation_length)] ...
                    )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Specify parameters of Randomized SVD
disp('Set parameters of Randomized SVD ...')

% Fixed rank OR Fixed accuracy approach
rank_is_fixed=true;

if(rank_is_fixed)
    prescribed_rank=10;
else
    prescribed_rank=1e-3;
end%

% Oversampling
oversampling=10;

% Power iterations 
nb_power_it=0;

disp('Done.')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Factorize C using randomized SVD
disp('Run Randomized SVD ...')

[U,S,V]=factRandSVD(grid_size, prescribed_rank, oversampling, nb_power_it, rank_is_fixed, ...
                    correlation_length,correlation_name,grid_fullfilename);

disp('Done.')