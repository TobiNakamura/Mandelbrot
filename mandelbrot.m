figure
a=subplot(1, 2, 1);
b=subplot(1, 2, 2);
for p=1:5
    generate([0 0.8], 300, p^3, a, b)
    drawnow
end