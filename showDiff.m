function showDiff()
    depth = [5 7 11 12 13 14 15 20 30 100]
    interval = [0 0.8]
%     depth = [30 40 50 60 70 80 100 200 300]
%     interval = [0.369 0.3695]
%     depth = [400 500]
%     interval=[0.357 0.369]
% depth=[500]
% interval=[0.36 0.368]
    for k=1:length(depth)
        figure;
        a=subplot(1, 2, 1);
        b=subplot(1, 2, 2);
        generate(interval, 300, depth(k), a, b);
    end
end