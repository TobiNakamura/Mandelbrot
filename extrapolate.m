n=100
depth=2000;
x = linspace(0.354, 0.4, n);
z0 = 0.350907738170319 + 0.384318829808752i;
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