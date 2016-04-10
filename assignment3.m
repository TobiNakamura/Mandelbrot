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
%      or put �none� if nobody helped (the two of) you.

% Helpers: _everybody helped us/me with the assignment (list names or put �none�)__

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
MAX_FRAMES = 100;

WRITE_VIDEO_TO_FILE = false; % change this as you like (true/false)
DO_IN_PARALLEL = false; %change this as you like (true/false)

iterateHandle = @iterate;

tic % begin timing

if DO_IN_PARALLEL
    startClusterIfNeeded
end

if WRITE_VIDEO_TO_FILE
    openVideoFile
end

%1319 440 17592186044416
% figure
% for k = 1:50
%     HEIGHT = k*10+100;
%     WIDTH = k*10+100;
%     zoom = 2^k;
%     frameArray(k) = iterate(k, [-1.5 0 zoom]);
%     img = frame2im(frameArray(k));
%     image(img)
%     drawnow
%     %pixelated = length(diff(img(HEIGHT/2, :))==0)/HEIGHT
% %     if pixelated > 3
% %         break
% %     end
% end
% disp([num2str(pixelated), ' ' num2str(HEIGHT), ' ' ,  num2str(zoom)])
% shg; % bring the figure to the top to be seen.
% movie(frameArray(end),1,FRAMERATE);
% disp('end')




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

%path = [-0.75625 -0.125 12; -0.75125 -0.125 100; -0.7500556641395 -0.01285937583185 1765.5173];
%path=[-2 0.5 1; -1.9 0.4 2; -1.8 0.3 4; -1.7 0.2 7;  -1.6 0 11;]
path = [
            -0.5 0 1
            -1.7859375 0.00015625 1371.4286;
            -1.7864322699547 4.88313982295e-8 113988.87;
            -1.78646422796135 2.5770725876025e-7 552407.61;
            -1.78530012796135 2.5770122876025e-7 1007.61;
            -1.783643981238 2.5770122875e-7 14225.082;
            -1.78130012796135 2.5770122876025e-7 107.61;
            -1.6 0 10;
            -1.75 0 10000;
            0.5 0 1;
            0.4 0 7;
            0.308035714285 -0.0035714285715 20.740741;
            0.254034459428 0.00020912383471 409.8342;
            0.2514030599505 4.5187367249e-6 11571.789;
            0.250610818843565 -1.327123262751e-6 39344.083;
            0.250097526924625 2.741340674115e-7 107107.31;
            0.2500010 0 10000000;
];
[m,~]=size(path);
%path = [-1.5 0 1; -1.5 0 20000000000000];

%profile points to get information on depth
% close all
% depthSample = zeros(m, 2);
% depthProfile = zeros(m, 2);
% for frameNum = 1:m
%     [frame, depth] = iterate(frameNum, [path(frameNum, :) 0]);
%     figure
%     [s, map]=frame2im(frame);
%     image(s)
%     axis image
%     depthSample(frameNum, :) = [path(frameNum, 3) depth];
% end
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
interpLoc = linspace(1, m, MAX_FRAMES);
interpType = 'pchip';
full_path = zeros(length(interpLoc), 4);
full_path(:, 1) = interp1(path(:,1), interpLoc, interpType);
full_path(:, 2) = interp1(path(:,2), interpLoc, interpType);
full_path(:, 3) = interp1(path(:,3), interpLoc, interpType);
full_path(:, 4) = zeros(length(interpLoc), 1);
%full_path(:, 4) = interp1(depthProfile(:,1),depthProfile(:,2), full_path(:, 3), interpType)

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
        endVal = 1;
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


