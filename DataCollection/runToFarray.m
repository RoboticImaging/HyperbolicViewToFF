% runs a horizontal search with arb n (that cant be pm \hat{z})

clear;
clc;
close all;

addpath('C:\Program Files\ToF\lib\matlab\tof_chrono');

%% input array params
% optical axis (note that z should always be 0):
n = [0;1;0];
% opticalAxisDeviation = -10;
% n = [sind(opticalAxisDeviation);cosd(opticalAxisDeviation);0];
n = n./norm(n);

baseline = 300/1000; % mm
assert(baseline>0);

N = 15; assert(N>1);

seperation = baseline/(N-1);

% bottomLeftCorner position
bottomLeftCorner = [300 -15  250]./1000;
% bottomLeftCorner = [450 -40 250]./1000;

stepTime = 0.9;
% stepTime = 4;

% default position of camera at UR5 theta = 0; this needs to be rotated to
% n
p = 1/sqrt(2)*[1;-1;0];

angleBetween = atan2(norm(cross(p,n)),dot(p,n));

up = getUpwardsVec(n);
up = up./norm(up);

rotationVector = cross(p,n);
rotationVector = rotationVector./norm(rotationVector);

moveDirection = cross(n,[0;0;1])';
moveDirection = moveDirection./norm(moveDirection);
posFromCenter = -(baseline/2)*moveDirection;

x = 1/sqrt(2)*[1;-1;0];
y = 1/sqrt(2)*[1;1;0];

RglobalToDefault = [x,y,[0;0;1]];

RglobalToDesired = [n,-moveDirection',up];

RDefaultToDesired = RglobalToDesired*RglobalToDefault';

orientationVec = vrrotmat2vec(RDefaultToDesired);
orientationVec = orientationVec(1:3)*orientationVec(4);

moveDirection = cross(n,[0;0;1])';
moveDirection = moveDirection./norm(moveDirection);


%% setup robot
HOST = '172.17.7.82';
PORT_30003 = 30003;

robotSocket = openArmConnection(HOST, PORT_30003);

% debug mode:
% robotSocket = 1;

initCommand = sprintf('movej(p[%.2f,%.2f,%.2f,%.2f,%.2f,%.2f],a=0.05, v=0.05, t=0, r=0)\n',...
    bottomLeftCorner(1),bottomLeftCorner(2),bottomLeftCorner(3),orientationVec(1),orientationVec(2),orientationVec(3));
fprintf(sprintf('Sending Command: %s', initCommand));
fprintf(robotSocket,initCommand);


% check center position and orientation is what you expect
pause() % make sure everything is in right position


%% prepare results location

saveTarget = "Results/ToFF/CsfFiles/blocksWithSat/";

sceneDescription = "true pz=0.87, screen added to induce saturation";


numFrames = 2; % The number of frames to capture 
dropFrames = 5; % The number of frames to drop before capturing 

integrationTime = 1000;
frameTime = 2200;
DACvalue = 550;
configFile = "kea_3step_50MHz.bin";


% check to make sure we aren't overrriding anything important:
if exist(saveTarget, 'dir')
    x = input('saveTarget exists, overwrite? (y/n) ','s');
    if ~((x == 'y') || (x == 'Y'))
        return
    end
else
    mkdir(saveTarget)
end


%% camera setup
% The serial number of the camera to connect to.
serial = '201000b';

% Find and connect to the camera based on its serial number
fprintf("creating camera...\n")
cam = tof.KeaCamera(tof.ProcessingConfig(), serial);
config = tof.CameraConfig("kea_3step_50MHz.bin");
config.setGain(2)
cam.setCameraConfig(config);


% Select to stream amplitude and z frames from the camera
tof.selectStreams(cam, [tof.FrameType.AMPLITUDE, tof.FrameType.PHASE]);





% information about the experiment
fid = fopen(strcat(saveTarget,"info.txt"), 'wt' );

fprintf(fid, 'Horizontal Scan taken %s\n',string(datetime(now,'ConvertFrom','datenum')));
fprintf(fid, 'Notes: %s\n',sceneDescription);

fprintf(fid, '\n**** Horizontal Scan Params ****\n');
fprintf(fid, 'n = [%f,%f,%f]\n',n(1),n(2),n(3));
fprintf(fid, 'p = [%f,%f,%f] mm\n',p(1),p(2),p(3));
fprintf(fid, 'baseline = %f mm\n',baseline);
fprintf(fid, 'N = %d\n',N);

fprintf(fid, '\n**** Camera Params ****\n');
fprintf(fid, 'numFrames = %d\n',numFrames);
fprintf(fid, 'dropFrames = %d\n',dropFrames);
% fprintf(fid, 'DACvalue = %d\n',DACvalue);
% if config.median.enabled == true
%     fprintf(fid, 'median filter  = %d\n',config.median.size);
% else
%     fprintf(fid, 'median filter  off\n');
% end
% fprintf(fid, 'integrationTime = %d\n',integrationTime);
fprintf(fid, 'configFile: %s\n\n',configFile);


%% Take data


cam.start(); 
pause(2); % let lasers warm up

row = 1;
posCounter = 1;
while row <= N
    if mod(row,2) == 0
        col = N;
    else
        col = 1;
    end
    while col <=N && col >=1
        fprintf('Taking position %d/%d\n',posCounter,N^2)
        writer = tof.createCsfWriterCamera(fullfile(saveTarget,sprintf('%d-%d.csf',row,col)), cam);

        pos = bottomLeftCorner + (row-1)*seperation*up' + (col-1)*seperation*moveDirection;

        
        % move arm
        fprintf(robotSocket,sprintf('movej(p[%.7f,%.7f,%.7f,%.7f,%.7f,%.7f],a=1, v=1, t=%.5f, r=0)\n',...
        pos(1),pos(2),pos(3),orientationVec(1),orientationVec(2),orientationVec(3),stepTime));
        movePose(robotSocket, pos, orientationVec, 't', stepTime)
        pause(1.2*stepTime)

        % record measured position
    %     measuredPos = readrobotpose(socket);
        measuredPos = pos;
        fprintf(fid, 'Photo taken with oritentation: [');
        fprintf(fid, ' %.4f ', measuredPos);
        fprintf(fid, ']\n');

       
        % take photo
        for i = 1:dropFrames
            frames = cam.getFrames();
        end

        for i = 1:numFrames
            frames = cam.getFrames();
            for frame = frames
                writer.writeFrame(frame);
            end
        end
        

        % update cols
        col = col + (-1)^(row-1);
        posCounter = posCounter + 1;
    end
    row = row + 1;
end
cam.stop();
cam.close();

fprintf(fid, '\n\n');
fprintf(fid, 'Test finished successfuly at %s\n',string(datetime(now,'ConvertFrom','datenum')));
fclose(fid);

closeArmConnection(robotSocket);




%% extra random testing code
% up = getUpwardsVec(n);
% p = 1/sqrt(2)*[1;-1;0];
% 
% angles = 0:0.001:2*pi;
% for k = 1:length(angles)
%     angle = angles(k);
%     directions(k,:) = vrrotvec2mat([up',angle])*p;
% end
% plot3(directions(:,1),directions(:,2),directions(:,3),'b')
% grid on
% hold on
% plot3(0,0,0,'rx')
% plot3([0,n(1)],[0,n(2)],[0,n(3)],'g');
% plot3([0,p(1)],[0,p(2)],[0,p(3)],'m');

% angles = 0:0.001:2*pi;
% nVals = [zeros(1,length(angles));cos(angles);sin(angles)];
% 
% for k  = 1:length(angles)
%     
%     CosTheta = max(min(dot(p',nVals(:,k)')/(norm(p)*norm(nVals(:,k))),1),-1);
%     angleBetween(k) = real(acosd(CosTheta));
%     
% end
% plot(angleBetween)



%}



