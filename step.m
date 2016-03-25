function [z, c] = step(z0, z, c, k)
    z = z.^2 + z0;
    c(abs(z) < 2) = k;
end