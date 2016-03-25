function [z, c, active] = step(z0, z, c, k, active)
    z = z.^2 + z0
    
    c(abs(z) < 2) = k
end