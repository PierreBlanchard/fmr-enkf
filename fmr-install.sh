#!/bin/bash

# Get path to modules
pathtomods=${PWD}
pathtologs=${pathtomods}/fmr-logs
pathtofmr=${pathtomods}/fmr-dev

# create log directory
mkdir -p ${pathtologs}

# delete previous package
echo "Remove fmr and logs folders."
rm -rf fmr-dev
rm -r ${pathtologs}/*


# extract fmr project
echo "Untar fmr package."
tar -zxvf fmr-dev.tar.gz > ${pathtologs}/fmr-untar.log

# install dependencies (ScalFMM)
cd fmr-dev/Packages/

# untar scalfmm
scalfmmversion=SCALFMM-1.4-2892
echo "Untar scalfmm package (${scalfmmversion}.tar.gz)."
tar -zxvf ${scalfmmversion}.tar.gz > ${pathtologs}/fmr-scalfmm-untar.log

# move to scalfmm
rm -rf scalfmm
mv ${scalfmmversion} scalfmm
cd scalfmm/

# create Build directory
mkdir -p Build
cd Build/

# Prepare ScalFMM's makefile
#cmake ../ -DSCALFMM_USE_BLAS=ON -DSCALFMM_USE_FFT=ON -DSCALFMM_USE_SSE=OFF -DSCALFMM_BUILD_EXAMPLES=OFF -DSCALFMM_USE_MEM_STATS=ON -DCMAKE_INSTALL_PREFIX=${pathtofmr}/Packages/scalfmm

## NB: You can also specify that you want to use MKL as Blas and FFT routines
echo "Generate scalfmm's makefile."
cmake ../ -DSCALFMM_USE_BLAS=ON -DSCALFMM_USE_MKL_AS_BLAS=ON -DSCALFMM_USE_FFT=ON -DSCALFMM_USE_MKL_AS_FFTW=ON -DSCALFMM_USE_SSE=OFF \
-DSCALFMM_BUILD_EXAMPLES=OFF -DSCALFMM_USE_MEM_STATS=ON -DCMAKE_INSTALL_PREFIX=${pathtofmr}/Packages/scalfmm \
-DSCALFMM_USE_ADDONS=ON \
> ${pathtologs}/fmr-scalfmm-cmake.log

# Activate HMat addon
cmake ../ -DSCALFMM_ADDON_HMAT=ON >> ${pathtologs}/fmr-scalfmm-cmake.log

# Install ScalFMM in /path/to/fmr/Packages/scalfmm
echo "Install scalfmm library."
make install > ${pathtologs}/fmr-scalfmm-makeinstall.log 2>&1

# Move to fmr project main directory
cd ${pathtofmr}

# Create Build/ directory
mkdir -p Build/
cd Build/

# Write FMR's makefile
echo "Generate fmr's makefile (do not use MDS addon, since not provided in package)."
cmake ../ -DFMR_BUILD_TESTS=ON -DFMR_BUILD_GENERATORS=ON -DFMR_BUILD_FACTORIZERS=ON -DFMR_ADDON_MDS=OFF  > ${pathtologs}/fmr-cmake.log

# For a list of all possible options
#ccmake ../

# NB: Setup precision (float/double) in Src/Definitions/FMRDefines.hpp

# Compile FMR project
echo "Make fmr project."
make > ${pathtologs}/fmr-make.log 2>&1

