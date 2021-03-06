%{
    Used to zoom into the mandelbrot set.
    Must initially be called with 2 arguments, one for each subplot handel.
    After setup, it can be called with pixel (x,y) that can be chosen from
    the UI in the figure
%}


function explore(a, b, x, y)
    switch nargin
        case 2
            interval = [0 0.8]
        case 4
            z0 = getMAP; %refer to previous map
            r=50; %radius of zooming regions (square)
            min = z0(y-r, x-r)
            max = z0(y+r, x+r)
            interval = [real(min) real(max) imag(min) imag(max)]
    end
    
    setMAP(generate(interval, 300, 1000, a, b)); %store previous map
end

function setMAP(val)
    global MAP
    MAP = val;
end

function r = getMAP
    global MAP
    r = MAP;
end