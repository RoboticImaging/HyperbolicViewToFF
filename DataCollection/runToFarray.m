% runs a horizontal search with arb n (that cant be pm \hat{z})

clear;
clc;
close all;

addpath('C:\Program Files\ToF\lib\matlab\tof_chrono');

%% input array params
n = [0;1;0];
n = n./norm(n);

baseline = 300/1000; % mm
assert(baseline>0);

N = 15; assert(N>1);

seperation = baseline/(N-1);

% bottomLeftCorner position
bottomLeftCorner = [300 -25 250]./1000;

stepTime = 0.5;

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
HOST = '129.78.214.100';
PORT_30003 = 30003;

robotSocket = tcpip(HOST, PORT_30003);

fopen(robotSocket);

% robotSocket = 1;

fprintf(sprintf('movej(p[%.2f,%.2f,%.2f,%.2f,%.2f,%.2f],a=1, v=1, t=10, r=0)\n',...
    bottomLeftCorner(1),bottomLeftCorner(2),bottomLeftCorner(3),orientationVec(1),orientationVec(2),orientationVec(3)));
fprintf(robotSocket,sprintf('movej(p[%.2f,%.2f,%.2f,%.2f,%.2f,%.2f],a=1, v=1, t=5, r=0)\n',...
    bottomLeftCorner(1),bottomLeftCorner(2),bottomLeftCorner(3),orientationVec(1),orientationVec(2),orientationVec(3)));


% check center position and orientation is what you expect
pause(6) % make sure everything is in right position



%% prepare results location

folder = "Results/ToFF/CsfFiles/blocksWithSat/";

sceneDescription = "true pz=0.87, screen added to induce saturation";


numFrames = 2; % The number of frames to capture 
dropFrames = 5; % The number of frames to drop before capturing 

integrationTime = 1000;
frameTime = 2200;
DACvalue = 550;
configFile = "kea_3step_50MHz.bin";


% check to make sure we aren't overrriding anything important:
if exist(folder, 'dir')
    x = input('Folder exists, overwrite? (y/n) ','s');
    if ~((x == 'y') || (x == 'Y'))
        return
    end
else
    mkdir(folder)
end

%% camera setup

csf_types = CSFType(); 
% Save the amplitude and phase frames 
cap_types = [ csf_types('amp'),csf_types('phi') ]; 
% The depthPipeline configuration file, leave blank if none is used. 
pipelineFile = 'filter_config.json'; 
% The serial number of the camera to connect to. 
serial = '201000b'; 

cam = KeaCameraMex();
cam.open("",serial,3956,0,32500); 
% Set the camera configuration
cam.setConfiguration(configFile); 
% Set the integration time and raw frame time. 
cam.setFrameTime(frameTime); 
cam.setIntegrationTime(integrationTime); 
cam.setDAC(DACvalue); 
cam.close();

cam.open(pipelineFile,serial,3956,0,32500); 

% Example of changing the depthPipeline configuration. 
% For this case we set the median filter to enabled. 
config = cam.getProcessingConfig(); 
config.median.enabled = false; 
% config.median.enabled = true;  
% config.median.size = int32(5); 
cam.setProcessingConfig( config ); 

% Get the stream list and select the chosen streams 
streamList = cam.getSteamList(); 
exportList = selectStreamList(cap_types,streamList); 
cam.setStreamList(exportList); 

% Init the CSF writer 
writer = CSFWriterMex();

cam.start(); 
pause(2); % let lasers warm up


% information about the experiment
fid = fopen(strcat(folder,"info.txt"), 'wt' );

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
fprintf(fid, 'DACvalue = %d\n',DACvalue);
if config.median.enabled == true
    fprintf(fid, 'median filter  = %d\n',config.median.size);
else
    fprintf(fid, 'median filter  off\n');
end
fprintf(fid, 'integrationTime = %d\n',integrationTime);
fprintf(fid, 'configFile: %s\n\n',configFile);

%% Take data
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
        writer.open(strcat(folder,sprintf('%d-%d.csf',row,col)), cam); 

        pos = bottomLeftCorner + (row-1)*seperation*up' + (col-1)*seperation*moveDirection;

        % move arm
        fprintf(robotSocket,sprintf('movej(p[%.7f,%.7f,%.7f,%.7f,%.7f,%.7f],a=1, v=1, t=%.5f, r=0)\n',...
        pos(1),pos(2),pos(3),orientationVec(1),orientationVec(2),orientationVec(3),stepTime));
        pause(1.9*stepTime)

        % record measured position
    %     measuredPos = readrobotpose(socket);
        measuredPos = pos;
        fprintf(fid, 'Photo taken with oritentation: [');
        fprintf(fid, ' %.4f ', measuredPos);
        fprintf(fid, ']\n');

        % take photo
        for i = 1:dropFrames
            [hdrs,frames] = cam.getFrames(); 
        end

        for i = 1:numFrames
            [hdrs,frames] = cam.getFrames();
            for l = 1:length(frames)
                writer.writeFrame( hdrs(l), frames{l} ); 
            end
        end
        writer.close();

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
fclose(robotSocket);




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



