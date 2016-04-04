function frames()
path = [0 0 1; -3 -3 1];
WIDTH = 300;
HEIGHT = 200;
DEFAULT_ZOOM = 1; %sets the difference in real value

angle = atan((path(2,2)-path(1,2))/(path(2,1)-path(1,1)))
realWidth = DEFAULT_ZOOM
imgHeight = DEFAULT_ZOOM*HEIGHT/WIDTH
initial = corners(path(1,1:2))
final = corners(path(2,1:2))
distance = path(2,1:2) - path(1,1:2)
n=ceil(abs(distance)/realWidth-1)*2+2
frames = ones(n, 4);
dir = distance/abs(distance)
for k=2:n
    frames(k) = corners(path(1,1:2)+dir*realWidth*k) %main frame
    frames(k+1) = []
    frames(k+2) = []
    k=k+3
end


function c = corners(center)
    c = [center(1)*ones(4,1)+[-1 1 -1 1]'*realWidth/2 center(2)*ones(4,1)+[1 1 -1 -1]'*imgHeight/2];
end

end