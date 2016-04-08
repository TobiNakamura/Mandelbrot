%todo:
%algorithm for going from one locations to another with minimal rendering



% ENSC180-Assignment3

% Student Name 1: student1

% Student 1 #: 123456781

% Student 1 userid (email): stu1 (stu1@sfu.ca)

% Student Name 2: student2

% Student 2 #: 123456782

% Student 2 userid (email): stu2 (stu2@sfu.ca)

% Below, edit to list any people who helped you with the assignment, 
%      or put ‘none’ if nobody helped (the two of) you.

% Helpers: _everybody helped us/me with the assignment (list names or put ‘none’)__

% Instructions:
% * Put your name(s), student number(s), userid(s) in the above section.
% * Edit the "Helpers" line.  
% * Your group name should be "<userid1>_<userid2>" (eg. stu1_stu2)
% * You will submit THIS file (assignment3.m),    
%   and your video file (assignment3.avi or possibly similar).
% Craig Scratchley, Spring 2016

function frameArray = assignment3

MAX_FRAMES = 10; % you can change this and consider increasing it.
HEIGHT = 300;
WIDTH = 500;
%RESOLUTION = 512; % you can change this and consider increasing it.
FRAMERATE = 30; % you can change this if you want.
MAX_DEPTH = 10000;

WRITE_VIDEO_TO_FILE = true; % change this as you like (true/false)
DO_IN_PARALLEL = false; %change this as you like (true/false)

if DO_IN_PARALLEL
    startClusterIfNeeded
end

if WRITE_VIDEO_TO_FILE
    openVideoFile
end
%preallocate struct array
%frameArray=struct('cdata',cell(1,MAX_FRAMES),'colormap',cell(1,MAX_FRAMES));

%iterate (1, [0.443884460063589 0.3697499694058715 6.051697594976703e-06])

%tobi's valley - converges to pi
%[-0.75625 -0.125 12]
%[-0.7501127115442 -0.01264794877738 3068.931]

%zoom
%[0.4435625 0.3739375 2.608695699999698e+02]
%[0.443884460063589 0.3697499694058715 1.652428900000000e+05]

%self similarity along r=0
%[-1.81010002531922 -1.8084266939974e-8 5.924571299999999e+06]

%[-1.7859375 0.00015625 1371.4286]
%[-1.7864322699547 4.88313982295e-8 113988.87]
%[-1.78646422796135 2.5770725876025e-7 552407.61]


%[0.28693186889504513 0.014286693904085048 1.575051189163648e+03] %spirals
%[0.2869424733977535 0.01427493092629105  1.870274700000000e+06] %outtro
DISTANCE = 2; % total panning distance
STEP = DISTANCE/MAX_FRAMES; %how much to pan per step.

iterateHandle = @iterate;

tic % begin timing

%path = [-0.75625 -0.125 12; -0.75125 -0.125 100; -0.7500556641395 -0.01285937583185 1765.5173];
%path=[-2 0.5 1; -1.9 0.4 2; -1.8 0.3 4; -1.7 0.2 7;  -1.6 0 11;]
path = [
            -1.7859375 0.00015625 1371.4286;
            -1.7864322699547 4.88313982295e-8 113988.87;
            -1.78646422796135 2.5770725876025e-7 552407.61;
        ];
    
numFrames = 7;

interpType = 'pchip';
full_path = path;
prev_path = path;
for k = 1:numFrames
    [m,~]=size(full_path);
    newM = m*2-1;
    full_path = zeros(newM, 3);
    full_path(1:2:newM, :) = prev_path(1:m, :);
    full_path(2:2:newM, 1) = interp1(prev_path(:,1), 1.5:1:m, interpType);
    full_path(2:2:newM, 2) = interp1(prev_path(:,2), 1.5:1:m, interpType);
    full_path(2:2:newM, 3) = interp1(prev_path(:,3), 1.5:1:m, interpType);
    prev_path = full_path;
    
    clf
    hold on
    plot(path)
    plot(full_path)
    legend('path - real', 'path - img', 'path-zoom', 'full-real', 'full-img', 'full-zoom')
end
[m,~]=size(full_path);
MAX_FRAMES = m;
zoomMap = ones(1, 2);
        
if DO_IN_PARALLEL
    parfor frameNum = 1:MAX_FRAMES
        %evaluate function iterate with handle iterateHandle
        frameArray(frameNum) = feval(iterateHandle, frameNum, full_path(frameNum, :), zoomMap);
    end
else
    for frameNum = 1:MAX_FRAMES
        if WRITE_VIDEO_TO_FILE
            %frame has already been written in this case
            iterate(frameNum, full_path(frameNum, :), zoomMap);
        else
            frameArray(frameNum) = iterate(frameNum, full_path(frameNum, :), zoomMap);
        end
    end
end

if WRITE_VIDEO_TO_FILE
    if DO_IN_PARALLEL
        writeVideo(vidObj, frameArray);
        %movie2avi(frameArray,'assignment3m2a'); % deprecated
    end
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
            NUM_WORKERS = (LOGICAL_PER_PHYSICAL + 1) * PHYSICAL_CORES
            myCluster.NumWorkers = 2;
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

    function [frame, zoomMap] = iterate (frameNum, window, zoomMap)
        centreX = window(1); 
        centreY = window(2); 
        domain = 1/window(3); 
        range = domain*HEIGHT/WIDTH;
        x = linspace(centreX - domain, centreX + domain, WIDTH);
        %you can modify the aspect ratio if you want.
        y = linspace(centreY - range, centreY + range, HEIGHT);

        % the below might work okay but you can further optimize it.
        
        % Create the two-dimensional complex grid using meshgrid
        [X,Y] = meshgrid(x,y);
        z0 = X + i*Y;
        
        % Initialize the iterates and counts arrays.
        z = z0;
        z(1,1) = z0(1,1); % needed for mex, assumedly to make z elements separate
        %in memory from z0 elements.
        
        % make c of type uint16 (unsigned 16-bit integer)
        c = zeros(HEIGHT, WIDTH, 'uint16');
        
        % Here is the Mandelbrot iteration.
        c(abs(z) < 2) = 1;
        endVal = 1;%0.000001*HEIGHT*WIDTH; %set termination condition to be when 0.03% of total pixel number 
        numDiverged = 0; %hold number of pixels that diverged in the previous iteration
        firstDiverge = 0; %holds the iteration number for when the first pixel diverged
        %don't show warning from mex invocation.
        WarningOff
        for w = 2:MAX_DEPTH
            [z,c,d] = mandelbrot_step(z,c,z0,w);
            if d ~= 0 && firstDiverge == 0 %identify the first diverged pixel
              firstDiverge = w;
            elseif d < endVal && d < numDiverged %when less then 0.03% of total pixels diverged in a single iteration and when the total number of pixels diverged per iteration is decreasing
              break
            end
            numDiverged = d;
        end
        w
        % create an image from c and then convert to frame.  Use cmap
        image = ind2rgb(c-uint16(firstDiverge*ones(HEIGHT,WIDTH)), colormap(flipud(jet(w-firstDiverge))));
        text(10, 10, 'hi', 'Color', 'white')
        frame = im2frame(image);
        %         image(c-uint16(firstDiverge*ones(HEIGHT,WIDTH)));
%         axis image;
%         colormap(flipud(jet(depth-firstDiverge)));
        if WRITE_VIDEO_TO_FILE & ~DO_IN_PARALLEL
            writeVideo(vidObj, frame);
        end
        disp(['frame=' num2str(frameNum)]);
    end
end


