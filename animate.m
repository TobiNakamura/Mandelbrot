%{
    creats set of frames that zoom into a single point
%}

function animate()
    center = [0.350907738170318 0.350907738170319...
                0.384318829808752 0.384318829808753];
    figure
    a=subplot(1,2,1);
    b=subplot(1,2,2);
    
    rate = 7; %is inversely proportional to zooming speed, must be >=2
    zoomLength = 108; % number of zooming iterations
    imageSize = 300;
    maxDepth = 5000; %incase generate() does not autoterminate
    
    bounds = center + 0.8*[-1 1 -1 1]; %set initial bounds
    
    
    for k=1:zoomLength
        z0 = generate(bounds, imageSize, maxDepth, a, b);
        drawnow;
        x_scale = (bounds(2)-bounds(1))/rate;
        y_scale = (bounds(4)-bounds(3))/rate;
        bounds = bounds + [x_scale -x_scale y_scale -y_scale];
%         if length(find(diff(abs(z0))>eps(abs(z0(1, 1))))) == 0 %if area within bounds is too small, double will not have enough precision
%             disp('Max floating point tolarence reached')
%             low=low+1
%             if low > 20
%                 break
%             end
%         end
    end
end


%[0.367613283989535 0.367613283989536]