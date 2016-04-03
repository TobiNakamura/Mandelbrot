#include <math.h>
#include "mex.h"
void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray *prhs[] )
/*        left hand side              right hand side
/* function [z,kz] = mandelbrot_step(z,kz,z0,d);
 * Take one step of the Mandelbrot iteration.
 * Complex arithmetic:
 *    z = z.^2 + z0
 *    kz(abs(z) < 2) == d
 * Real arithmetic:
 *    x <-> real(z);
 *    y <-> imag(z);
 *    u <-> real(z0);
 *    v <-> imag(z0);
 *    [x,y] = [x.^2-y.^2+u, 2*x.*y+v];
 *    kz(x.^2+y.^2 < 4) = d;
 */
     
{ 
    double *x,*y,*u,*v,t; 
    unsigned short *kz, *num, d;
    int j ,n, m;
    int dim[] = {1, 1};
    
    x = mxGetPr(prhs[0]); 
    y = mxGetPi(prhs[0]);
    kz = (unsigned short *) mxGetData(prhs[1]); 
    u = mxGetPr(prhs[2]); 
    v = mxGetPi(prhs[2]);
    d = (unsigned short) mxGetScalar(prhs[3]);
    plhs[0] = prhs[0];
    plhs[1] = prhs[1];
    plhs[2] = mxCreateNumericArray(2,dim,mxUINT32_CLASS,mxREAL);
    num = mxGetData(plhs[2]);
    *num = 0;
    
    n = mxGetN(prhs[0]);

	m = mxGetM(prhs[0]);

    if(1){
    for (j=n*m; j--; ) {
        if (kz[j] == d-1) {
            t = x[j];
            x[j] = x[j]*x[j] - y[j]*y[j] + u[j];
            y[j] = (t+t)*y[j] + v[j];
            if (x[j]*x[j] + y[j]*y[j] < 4) {
                kz[j] = d;
            } else {
                *num = *num+1;
            }
        }
    }
    } else {
        for (j=0; j<n*m; j++) {
        if (kz[j] == d-1) {
            t = x[j];
            x[j] = x[j]*x[j] - y[j]*y[j] + u[j];
            y[j] = 2*t*y[j] + v[j];
            if (x[j]*x[j] + y[j]*y[j] < 4) {
                kz[j] = d;
            }
        }
    }
    }
    
    return;
}
