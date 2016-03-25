% shows how complex numbers with diffarent initial conditions diverge in a
% chaotic manner.
%mainly used for explaining concepts and to identify why mandelbrot set gets
%pixaletad at high depths

n=1000
depth=1000;
x = linspace(0.3509, 0.351, n);
y = linspace(0.3843, 0.3844, n)
z0 = x + y*i;
z=zeros(depth,n);

for k=2:depth
    z(k,:)=z(k-1,:).^2+z0;
end
figure
hold on
grid on
for k=2:n
    plot(abs(z(:,k)))
end
axis([0 depth 0 2])