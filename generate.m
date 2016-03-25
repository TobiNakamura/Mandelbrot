function z0 = generate(interval, courseGrain, depth, brotFig, diffFig, num)
    if length(interval)==2
        x = linspace(interval(1), interval(2), courseGrain);
        y = x';
    elseif length(interval)==4
        x = linspace(interval(1), interval(2), courseGrain);
        y = linspace(interval(3), interval(4), courseGrain)';
    end
    
    n = length(x);
    
    [X,Y] = meshgrid(x,y);
    z0 = X + i*Y;
    
    z = zeros(n,n);
    c = zeros(n,n);
    endVal = 0.0003*courseGrain^2;
    numDiverged = 0;
    firstDiverge = 0;
    
    for k = 1:depth
      if k==depth
          z_bef = z;
      end
      
      [z, c] = step(z0, z, c, k);
      curNumDiverged = length(find(c==k-1));
      if curNumDiverged ~= 0 && firstDiverge == 0
          firstDiverge = k
      elseif curNumDiverged < endVal && curNumDiverged < numDiverged
          depth = k
%           disp('last diverged ');
%           z0(find(c==k));
          break
      end
      numDiverged = curNumDiverged;
    end
    
    
    hist = zeros(1,depth);
    for k=1:depth
        hist(1,k) = length(find(c==k));
    end
    
    
    subplot(diffFig);
    if exist('z_bef', 'var') == 0
        plot(hist);
        axis([0 depth 0 10*endVal]);
    else
        image(abs(z-z_bef));
        axis image
        colormap(flipud(jet(depth)));
    end
    
    
    subplot(brotFig);
    mandelImg = c-firstDiverge*ones(n,n);
    image(mandelImg);
    axis image;
    map = colormap(flipud(jet(depth-firstDiverge)));
    
    if nargin >= 6
        imwrite(mandelImg, map, strcat('Frames/', int2str(num), '.png'));
    end
    
    hp = impixelinfo;
    set(hp,'Position',[5 1 300 20]);
end
