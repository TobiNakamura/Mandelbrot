% ENSC180-Assignment3

% Student Name 1: Nicole 

% Student 1 #: 123456781

% Student 1 userid (email): stu1 (stu1@sfu.ca)

% Student Name 2: Tobi Shires Nakamura

% Student 2 #: 123456782

% Student 2 userid (email): tshiresn (tshiresn@sfu.ca)

% Below, edit to list any people who helped you with the assignment, 
%      or put ‘none’ if nobody helped (the two of) you.

% Helpers: Brenden

% Instructions:
% * Put your name(s), student number(s), userid(s) in the above section.
% * Edit the "Helpers" line.  
% * Your group name should be "<userid1>_<userid2>" (eg. stu1_stu2)
% * You will submit THIS file (assignment3.m),    
%   and your video file (assignment3.avi or possibly similar).
% Craig Scratchley, Spring 2016

function frameArray = assignment3
HEIGHT = 300;
WIDTH = 300;
FRAMERATE = 30; % you can change this if you want.
MAX_DEPTH = 10000;
MAX_FRAMES = 500;

WRITE_VIDEO_TO_FILE = true; % change this as you like (true/false)
DO_IN_PARALLEL = true; %change this as you like (true/false)

iterateHandle = @iterate;

tic % begin timing

if DO_IN_PARALLEL
    startClusterIfNeeded
end

if WRITE_VIDEO_TO_FILE
    openVideoFile
end

path = [
            -0.5 0 1 1;
            -1.5 -0.175 4.8979592 0;
            -1.7 -0.01 10 0;
            -1.785 0 500 0;
            -1.7859375 0.00015625 1371.4286 1;
            -1.7859375 0.00015625 5000 0;
            -1.7864322699547 0 7000 0;
            -1.7864322699547 0 113988.87 1;
            -1.78645422796135 0 50000 0;
            -1.78646422796135 0 552407.61 1;
            -1.78646422796135 0 7000 0;
            -1.78636422796135 0 5000 0;
            -1.78530012796135 2.5770122876025e-7 1007.61 0;
            -1.78430012796135 2.5770122876025e-7 5000 0;
            -1.783643981238 2.5770122875e-7 14225.082 1;
            -1.783644981238 2.5770122875e-7 1000 0;
            -1.78130012796135 2.5770122876025e-7 107.61 0;
            -1.6 0 10 0;
            -1.78 0 50  1;
            -1.75 0 100 0;
            -1.75 0 10000 1;
            -1.75 0 500 0;
            -1.74 0 100 0;
            -1.5 0 10 0;
            0 0 1 1;
            0.4 0 7 0;
            0.308035714285 -0.0035714285715 20.740741 0;
            0.254034459428 0.00020912383471 409.8342 0;
            0.2514030599505 0 7000 0;
            0.250097526924625 0 7000 1;
            0.254034459428 0.00020912383471 409.8342 0;
            0.30125 -0.025 88.888889 0;
            0.395 -0.174375 23.076923 0;
            0.38125 -0.32375 11.881188 0;
            0.2075 -0.60625 5.0526316 0;
            -0.5 0 0.5 1;
];

%profile points to get information on depth
close all
[m,~]=size(path);
depthSample = zeros(m, 2);
depthProfile = zeros(m, 2);
for frameNum = 1:m
    [frame, depth] = iterate(frameNum, [path(frameNum, 1:3) 0]);
    figure
    [s, map]=frame2im(frame);
    image(s)
    axis image
    depthSample(frameNum, :) = [path(frameNum, 3) depth];
end

modPath = zeros(m, 3);
newIndex  = 1;
for k=1:m
    if path(k, 4)
        modPath(newIndex, :) = path(k, 1:3);
        modPath(newIndex+1, :) = path(k, 1:3);
        modPath(newIndex+2, :) = path(k, 1:3);
        newIndex = newIndex+3;
    else
        modPath(newIndex, :) = path(k, 1:3);
        newIndex=newIndex+1;
    end
end
modPath
% [~, sorting] = sort(depthSample(:,1))
% sorted = depthSample(sorting, :)
% k=1;
% j=1;
% for k = 2:length(sorting)
%     if sorted(k, 1) > sorted(k-1, 1)
%         depthProfile(j, :) = sorted(k, :)
%        j=j+1;
%     end
% end
% [~, sorting] = sort(depthProfile(:,1))
% depthProfile = depthProfile(sorting, :)
% while k <= length(sorting)
%     searchVal = sorted(k, :);
%     [row, ~] = find(sorted(:, 1)==searchVal(1));
%     [~,index]=max(sorted(row, 2));
%     depthProfile(j, :) = sorted(index+k-1, :);
%     k = k+length(row);
%     j=j+1;
% end
% depthProfile
%interpolate to find path though which camera will travel
[modPathLength,~]=size(modPath);
interpLoc = linspace(1, modPathLength, MAX_FRAMES);
interpType = 'pchip';
full_path = zeros(length(interpLoc), 4);
full_path(:, 1) = interp1(modPath(:,1), interpLoc, interpType); %real axis
full_path(:, 2) = interp1(modPath(:,2), interpLoc, interpType); %img axis
full_path(:, 3) = interp1(modPath(:,3), interpLoc, interpType); %zoom
full_path(:, 4) = interp1(depthSample(:,2), linspace(1,m,MAX_FRAMES), interpType); %depth
full_path
%preallocate struct array
frameArray=struct('cdata',cell(1,MAX_FRAMES),'colormap',cell(1,MAX_FRAMES));

if DO_IN_PARALLEL
    parfor frameNum = 1:MAX_FRAMES
        %evaluate function iterate with handle iterateHandle
        frameArray(frameNum) = feval(iterateHandle, frameNum, full_path(frameNum, :));
    end
else
    for frameNum = 1:MAX_FRAMES
        if WRITE_VIDEO_TO_FILE
            %frame has already been written in this case
            frameArray(frameNum) = iterate(frameNum, full_path(frameNum, :));
        else
            frameArray(frameNum) = iterate(frameNum, full_path(frameNum, :));
        end
    end
end

if WRITE_VIDEO_TO_FILE
    writeVideo(vidObj, frameArray);
    close(vidObj);
    toc %end timing
else
    toc %end timing
    %clf;
    shg; % bring the figure to the top to be seen.
    movie(frameArray,1,FRAMERATE);
end

    function startClusterIfNeeded
        myCluster = parcluster('local');
        if length(myCluster.Jobs) > 1
            disp('Warning! You are running multiple clusters. Try and close all but one before running again');
        elseif ~length(myCluster.Jobs) | ~strcmp(myCluster.Jobs.State, 'running')
            PHYSICAL_CORES = feature('numCores');
            LOGICAL_PER_PHYSICAL = 2; % "hyperthreads" per physical core
            NUM_WORKERS = (LOGICAL_PER_PHYSICAL + 1) * PHYSICAL_CORES-2
            myCluster.NumWorkers = NUM_WORKERS;
            saveProfile(myCluster);
            disp('This may take a couple minutes when needed!')
            tic
             parpool(NUM_WORKERS);
            toc
        end
    end

    function openVideoFile
        % create video object
        vidObj = VideoWriter('assignment3');
        %vidObj.Quality = 100; % or consider changing
        vidObj.FrameRate = FRAMERATE;
        open(vidObj);
    end

    function [frame depth] = iterate (frameNum, window)
        centreX = window(1); 
        centreY = window(2); 
        domain = 1/window(3);
        if ~window(4)
            depth = MAX_DEPTH;
            doDynamic = 1;
        else 
            depth = window(4);
            doDynamic = 0;
        end
        depth = MAX_DEPTH;
            doDynamic = 1;
        range = domain*HEIGHT/WIDTH;
        x = linspace(centreX - domain, centreX + domain, WIDTH);
        %you can modify the aspect ratio if you want.
        y = linspace(centreY - range, centreY + range, HEIGHT);

        % the below might work okay but you can further optimize it.
        
        % Create the two-dimensional complex grid using meshgrid
        [X,Y] = meshgrid(x,y);
        z0 = X + 1i*Y;
        
        % Initialize the iterates and counts arrays.
        z = z0;
        z(1,1) = z0(1,1); % needed for mex, assumedly to make z elements separate
        %in memory from z0 elements.
        
        clear X Y x y range domain centerX centerY
        
        % make c of type uint16 (unsigned 16-bit integer)
        c = zeros(HEIGHT, WIDTH, 'uint16');
        
        % Here is the Mandelbrot iteration.
        c(abs(z) < 2) = 1;
        endVal = 50;
        numDiverged = 0; %hold number of pixels that diverged in the previous iteration
        firstDiverge = 0; %holds the iteration number for when the first pixel diverged
        %don't show warning from mex invocation.
        WarningOff
        for w = 2:depth
            [z,c,d] = mandelbrot_step(z,c,z0,w);
            if d ~= 0 && firstDiverge == 0 %identify the first diverged pixel
              firstDiverge = w;
            elseif doDynamic && d < endVal && d < numDiverged 
              break
            end
            numDiverged = d;
        end
        depth = w
        % create an image from c and then convert to frame.  Use cmap
        image = ind2rgb(c-uint16(firstDiverge*ones(HEIGHT,WIDTH)), colormap(flipud(jet(depth-firstDiverge))));
        frame = im2frame(image);
        %         image(c-uint16(firstDiverge*ones(HEIGHT,WIDTH)));
%         axis image;
%         colormap(flipud(jet(depth-firstDiverge)));
        disp(['frame=' num2str(frameNum)]);
        clear image w c firstDiverge z d numDiverged endVal z0
    end
end


