function frames()
%path = [-0.75625 -0.125 12; -0.75125 -0.125 100; -0.7500556641395 -0.01285937583185 1765.5173];
%path=[-2 0.5 1; -1.9 0.4 2; -1.8 0.3 4; -1.7 0.2 7;  -1.6 0 11;]
path = [
            -10 -10 -10 2;
            0 0 0 2;
            10 10 10 2;
        ];
    
numFrames = 7;

interpType = 'pchip';
full_path = path;
prev_path = path;
[m,~]=size(full_path);
for k = 1:m
    full_path = zeros(sum(path(:,4))+m, 3);
    
    full_path([1 3 6], :) = 
end


for k = 1:numFrames
    [m,~]=size(full_path);
    newM = m*2-1;
    for j = 1:(m-1)
        centerPoints = 1:2:newM;
        full_path(centerPoints, :) = prev_path(1:m, :);
        
    end
        
    full_path = zeros(newM, 3);
    full_path(1:2:newM, :) = prev_path(1:m, :);
    full_path(2:2:newM, 1) = interp1(prev_path(:,1), 1.5:1:m, interpType);
    full_path(2:2:newM, 2) = interp1(prev_path(:,2), 1.5:1:m, interpType);
    full_path(2:2:newM, 3) = interp1(prev_path(:,3), 1.5:1:m, interpType);
    prev_path = full_path;
end
clf
    hold on
    plot(path)
    plot(full_path)
    legend('path - real', 'path - img', 'path-zoom', 'full-real', 'full-img', 'full-zoom')
[m,~]=size(full_path);
MAX_FRAMES = m;

    function c = corners(center)
        matrix = [center(1)*ones(4,1)+[-1 1 -1 1]'*realWidth/2 center(2)*ones(4,1)+[1 1 -1 -1]'*imgHeight/2];
        c = [matrix(1, :) matrix(2, :) matrix(3, :) matrix(4, :)];
    end

% angle = atan((path(2,2)-path(1,2))/(path(2,1)-path(1,1)))
% realWidth = DEFAULT_ZOOM
% imgHeight = DEFAULT_ZOOM*HEIGHT/WIDTH
% distance = path(2,1:2) - path(1,1:2)
% n=ceil(norm(distance)/realWidth-1)*2+4
% frames = ones(n, 8);
% corners(path(1,1:2))
% frames(1, :) = corners(path(1,1:2))
% frames(end, :) = corners(path(2,1:2))
% dir = distance/abs(distance)
% for k=2:n-1
%     frames(k, :) = corners(path(1,1:2)+dir*realWidth*k)
%     frames(k+1, :) = [frames(k-2)]
%     frames(k+2, :) = []
%     k=k+3
% end


    
end