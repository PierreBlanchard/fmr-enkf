# fmr-enkf

Ensemble Kalman Filters (EnKFs) powered by the Fast Multipole Method (FMM) and Randomized Low-Rank Approximations (RandLRA)

###1. INTRODUCTION

####1.1 The Ensemble Kalman Filter (EnKF)

**fmr-enkf** is an open-source package providing a matlab implementation of the <a href="http://twister.ou.edu/OBAN2004/Evensen03a_OceanDynamics.pdf">Ensemble Kalman Filter (EnKF)</a>. 

* The original `./enkf-evensen` package can be downloaded from the <a href="http://enkf.nersc.no/">EnKF Home Page</a>. 
* `./enkf-evensen/readme.txt` provides extensive documentation, e.g., lists of available models and filters.
* `./enkf-evensen/enkf-matlab` provides all necessary matlab routines.

The EnKF is a Kalman Filter formulation based on the propagation of an ensemble of member (state) through the forward model, where the state estimate is computed as the mean of members and the covariance as the ensemble covariance.

* **[TODO]** Provide equations of the EnKF (prediction + correction). 
* **[TODO]** Provide weighted mean and covariance.

####1.2 Fast Methods for Randomized Numerical Linear Algebra (FMR)

Expensive matrix computations involved in the algorithm such as matrix factorizations and matrix multiplications can be handled by the open-source C++ package **FMR** :

* The package can be downloaded from <a href="https://gforge.inria.fr/projects/fmr/">FMR Home Page</a>.
* A copy of the current dev branch is provided in the tarball `./fmr-dev.tar.gz`.
* It provides an extensive documentation on installation and usage.
* Automatic installation is also explained in the [Tutorial](#SectionTutoInstallFMR).

####1.2.1 The Randomized SVD

**FMR** implements a random projection based low-rank approximation known as the Randomized SVD, see [Section 3.4 for algorithms and guidelines](#SectionTutoAdvancedFMR). 
The Randomized SVD provides an approximate rank-r SVD factorization of an m-by-n input dense matrix M, i.e., 

```
M = USV^T
```

at a O(rmn) computational cost governed by the multiplication of M to a n-by-r matrix X, where 

```
r << m,n
```

is a prescribed numerical rank. It is applicable to any low-rank matrix as long as the singular values decrease sufficiently fast (**[TODO]** add illustration and tests in tutorial).

####1.2.2 The Fast Multipole Method

If an n-by-n symmetric matrix M is prescribed as a *smooth* kernel k evaluated on a spatial grid x, i.e., 

```
M_ij = k(x_i,x_j)
```

then it can be multiplied to any arbitrary vector at a O(n) computational cost using the FMM. Consequently, decreasing the cost of the Randomized SVD from O(rn^2) to O(r^2n).

**FMR** relies on the open-source parallel library **ScalFMM** for Fast Multipole matrix multiplication, see [Section 3.4.1 for algorithms and guidelines](#SectionTutoAdvancedFMR). 

* **ScalFMM** can be downloaded from <a href="http://scalfmm-public.gforge.inria.fr/doc/">ScalFMM Home Page</a>.
* A copy of the current dev branch is provided in the tarball `fmr/Packages/SCALFMM-X.X-XXXX.tar.gz`.
* **ScalFMM** provides built-in scalar kernels such as 1/r, 1/r^2 and tensorial kernels such as Stokes (r,ij). 
* **FMR** provides built-in scalar correlation kernels such as RBF functions (exponential and gaussian decay), spherical model, Oseen-Gauss kernel...

###2. DIRECTORIES AND FILES

	./enkf-evensen/  : Evensen's EnKF matlab library 
	./fmr-dev.tar.gz : FMR's package (tarball)
	./fmr-examples/  : Contains matlab examples using FMR's matlab interface
	./fmr-install.sh : FMR's install script
	./fmr-logs/      : (untracked) Contains stdout of the main steps of FMR's installation
	./README.md		 : This file 
	
###3. <a name="SectionTuto"></a> TUTORIAL

This project aims at enhancing a well known Data Assimilation code implemented in Matlab using fast numerical linear algebra implemented in C++.

The resulting matlab library has 2 levels of usage:

* [Basic EnKF](#SectionTutoBasicEnKF): Pure Matlab implementation, that does not require any installation
* [Accelerated EnKF](#SectionTutoInstallFMR): Matlab calls C++ NLA routines. Therefore, compilation of **FMR**'s routines is required.

####3.1 <a name="SectionTutoBasicEnKF"></a> **Basic** usage of EnKF's Matlab library 

If you don't want/need to install **FMR**, you can still play around with the EnKF matlab library. Please have a look at `./enkf-evensen/readme.txt` in order to get familiar with Evensen's implementation. 

**Forward Models** Some basic forward models are implemented in Matlab:

* Built-in: L3, L40, LA, LA2

But more evolved ones are written in fortran90 and interfaced with Matlab using Mex:

* Built-in: QG
* **[TODO]** Add more models (MODFLOW, TOUGH2, ...)

####3.2 <a name="SectionTutoInstallFMR"></a> Install FMR package

In order to use all features provided by **FMR** package, e.g., 

* O(rn^2) approximate matrix factorization based on randomized NLA
* O(n) approximate kernel matrix multiplication

you will have to run the install script `./fmr-install.sh`, i.e.,

* Untar the package
* Go to **FMR**'s home folder
* Install dependencies, i.e., **ScalFMM** library 
	* Configure: `cmake ../`
	* Compile and install library: `make install`
* Install **FMR** library
	* Configure: `cmake ../`
	* Compile (and install): `make install`

For an advanced configuration of **ScalFMM** and **FMR** you can use cmake with your own options or ccmake GUI, see [Section for further details on advanced configuration](#SectionTutoAdvancedFMR).

####3.3 <a name="SectionTutoBasicFMR"></a> **Basic** usage of FMR's matlab interface

Here we describe how to use the **FMR**'s basic features through the matlab interface. 

#####3.3.1 Fast Matrix Multiplication


#####3.3.2 Randomized SVD



#####3.3.3 Fast Multipole acceleration of the Randomized SVD



####3.4 <a name="SectionTutoAdvancedFMR"></a> **Advanced** usage of FMR's features

#####3.4.1 Fast Matrix Multiplication



#####3.4.2 Randomized SVD



#####3.4.3 Fast Multipole acceleration of the Randomized SVD

