/*****************************************************************************
 * Copyright (C) 2008 Pavel Sakov
 * 
 * This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
 * LICENSE for details.
*****************************************************************************/

/*****************************************************************************
 *
 * File:           L3_step_c.c
 *
 * Created :       31/08/2007
 *
 * Last modified:  08/02/2008
 *
 * Author:         Pavel Sakov
 *                 CSIRO Marine Research
 *
 * Purpose:        C code for faster stepping Lorenz-3 model in Matlab.
 *
 * Description:
 * 
 * Revisions:
 *
 *****************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "mex.h"

static void L3(double y[], double y1[])
{
    y1[0] = 10.0 * (y[1] - y[0]);
    y1[1] = (28.0 - y[2]) * y[0] - y[1];
    y1[2] = y[0] * y[1] - (8.0 / 3.0) * y[2];
}

static void rk4step(double x, double xend, int n, double y[], double yout[])
{
    double* k = malloc(n * 5 * sizeof(double));
    double* k1 = k;
    double* k2 = &k[n];
    double* k3 = &k[n * 2];
    double* k4 = &k[n * 3];
    double* yy = &k[n * 4];
    double h = xend - x;
    double h2 = h / 2.0;
    int i;

    L3(y, k1);
    for (i = 0; i < 3; ++i)
	yy[i] = y[i] + h2 * k1[i];
    L3(yy, k2);
    for (i = 0; i < 3; ++i)
	yy[i] = y[i] + h2 * k2[i];
    L3(yy, k3);
    for (i = 0; i < 3; ++i)
	yy[i] = y[i] + h * k3[i];
    L3(yy, k4);

    for (i = 0; i < 3; ++i)
	yout[i] = y[i] + h * (k1[i] + 2.0 * (k2[i] + k3[i]) + k4[i]) / 6.0;

    free(k);
}

void mexFunction(int nlhs, mxArray* plhs[], int nrhs, const mxArray* prhs[])
{
    double* dt;
    double* x;
    double* xout;
    int N, M, n;
    int i;

    if (nlhs != 1 || nrhs != 2)
	mexErrMsgTxt("L3_step_c: wrong number of input or output arguments");

    dt = mxGetPr(prhs[0]);
    x = mxGetPr(prhs[1]);
    N = mxGetN(prhs[1]);
    M = mxGetM(prhs[1]);
    n = N * M;

    plhs[0] = mxCreateDoubleMatrix(M, N, mxREAL);
    xout = mxGetPr(plhs[0]);
    for (i = 0; i < n; ++i)
	xout[i] = x[i];

    rk4step(0.0, dt[0], n, xout, xout);
}
