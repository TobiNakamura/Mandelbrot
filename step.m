%{
    single iteration of mandelbrot set generation.
    z0, z, c must be square matricies of same size.
    c is the map for the mandelbrot set
    k is the iteration number
%}

function [z, c] = step(z0, z, c, k)
    z = z.^2 + z0; %generate next number in sequence
    c(abs(z) < 2) = k; %update map for those pixels that has not diverged
end