%questions:
%can we using video editing tool?
%do we have access to matlab parallel compute
%how do you optimize .c
%can we have separete video rendering file, save frames as still, then
%later writing them to video

%todo:
%modify to make variabble aspect ratio
%find good ration between re rendering and zooming
%algorithm for going from one locations to another with minimal rendering
%extend color map to beyond 64 colors



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
HEIGHT = 200;
WIDTH = 300;
%RESOLUTION = 512; % you can change this and consider increasing it.
FRAMERATE = 30; % you can change this if you want.
MAX_DEPTH = 1000;

WRITE_VIDEO_TO_FILE = false; % change this as you like (true/false)
DO_IN_PARALLEL = false; %change this as you like (true/false)

if DO_IN_PARALLEL
    startClusterIfNeeded
end

if WRITE_VIDEO_TO_FILE
    openVideoFile
end
%preallocate struct array
%frameArray=struct('cdata',cell(1,MAX_FRAMES),'colormap',cell(1,MAX_FRAMES));

DISTANCE = 2; % total panning distance
STEP = DISTANCE/MAX_FRAMES; %how much to pan per step.

iterateHandle = @iterate;

tic % begin timing
        
if DO_IN_PARALLEL
    parfor frameNum = 1:MAX_FRAMES
        %evaluate function iterate with handle iterateHandle
        frameArray(frameNum) = feval(iterateHandle, frameNum);
    end
else
    for frameNum = 1:MAX_FRAMES
        if WRITE_VIDEO_TO_FILE
            %frame has already been written in this case
            iterate(frameNum);
        else
            frameArray(frameNum) = iterate(frameNum);
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

    function frame = iterate (frameNum)
        % you will need to change the next set of lines for sure.
        centreX = 0.5 - (frameNum-1) * STEP;
        centreY = 0;
        domain = 1.5;
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
        endVal = 0.0003*HEIGHT*WIDTH; %set termination condition to be when 0.03% of total pixel number 
        numDiverged = 0; %hold number of pixels that diverged in the previous iteration
        firstDiverge = 0; %holds the iteration number for when the first pixel diverged
        depth = 0;
        %don't show warning from mex invocation.
        WarningOff
        for k = 2:MAX_DEPTH
            [z,c] = mandelbrot_step(z,c,z0,k);
            
            curNumDiverged = length(find(c==k-1)); %build this into c
            if curNumDiverged ~= 0 && firstDiverge == 0 %identify the first diverged pixel
              firstDiverge = k;
            elseif curNumDiverged < endVal && curNumDiverged < numDiverged %when less then 0.03% of total pixels diverged in a single iteration and when the total number of pixels diverged per iteration is decreasing
              depth = k
              break
            end
            numDiverged = curNumDiverged;
        end
        
        % create an image from c and then convert to frame.  Use cmap
        frame = im2frame(ind2rgb(c-uint16(firstDiverge*ones(HEIGHT,WIDTH)), colormap(flipud(jet(depth-firstDiverge)))));
        if WRITE_VIDEO_TO_FILE & ~DO_IN_PARALLEL
            writeVideo(vidObj, frame);
        end
        
        disp(['frame=' num2str(frameNum)]);
    end
end


