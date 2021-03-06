%{
    Generates mandelbrot set and plots it next to a diverged pixel vs
    iteration graph or a iteration pixel change map. Can optionally save
    image of mandelbrot set generated.
    Can only generate square images with dimentions specified by
    courseGrain.
    interval can either be 2 numbers specifiying bounds along [1, 1],[1,-1]
    or a pair of coordinates in 2 space.
    brotFig and diffFig are handels to subplot objects.
    num is used for a unique identifier when naming the image file for that frame.
 %}

function z0 = generate(interval, courseGrain, depth, brotFig, diffFig, num)
    if length(interval)==2
        x = linspace(interval(1), interval(2), courseGrain);
        y = x';
    elseif length(interval)==4
        x = linspace(interval(1), interval(2), courseGrain);
        y = linspace(interval(3), interval(4), courseGrain)';
    end
    
    n = length(x);
    
    %create grid of complex numbers for initial condition
    [X,Y] = meshgrid(x,y);
    z0 = X + i*Y;
    
    z = zeros(n,n);
    c = zeros(n,n);
    endVal = 0.0003*courseGrain^2; %set termination condition to be when 0.03% of total pixel number 
    numDiverged = 0; %hold number of pixels that diverged in the previous iteration
    firstDiverge = 0; %holds the iteration number for when the first pixel diverged
    
    for k = 1:depth
      if k==depth
          z_bef = z; %used for the iteration pixel change map
      end
      
      [z, c] = step(z0, z, c, k);
      
      curNumDiverged = length(find(c==k-1));
      if curNumDiverged ~= 0 && firstDiverge == 0 %identify the first diverged pixel
          firstDiverge = k;
      elseif curNumDiverged < endVal && curNumDiverged < numDiverged %when less then 0.03% of total pixels diverged in a single iteration and when the total number of pixels diverged per iteration is decreasing
          depth = k;
          break
      end
      numDiverged = curNumDiverged;
    end
    
    %generate histogram data for number of pixels diverged per iteration
    hist = zeros(1,depth);
    for k=1:depth
        hist(1,k) = length(find(c==k));
    end
    
    %plots histogram of diffarencial map dependent on option
    subplot(diffFig);
    if exist('z_bef', 'var') == 0 %plots data for number of pixels diverged per iteration
        plot(hist);
        axis([0 depth 0 10*endVal]);
    else                          %plots iteration pixel change map
        image(abs(z-z_bef));
        axis image
        colormap(flipud(jet(depth)));
    end
    
    
    subplot(brotFig);
    mandelImg = c-firstDiverge*ones(n,n); %initial iterations can see no divergence, cut out those values to maintain dynamic range of coloring
    image(mandelImg);
    axis image;
    map = colormap(flipud(jet(depth-firstDiverge)));
    
    if nargin >= 6 %if id# indicated in argument, save img
        [img, newMap] = imapprox(mandelImg, map, 256);
        imwrite(img, newMap, strcat('Frames/', int2str(num), '.png'));
        imwrite(img, newMap, strcat('Frames/', int2str(num), '.png', 'BitDepth', 16));
    else
        hp = impixelinfo; %create mouse hover UI
        set(hp,'Position',[5 1 300 20]);
    end
end
