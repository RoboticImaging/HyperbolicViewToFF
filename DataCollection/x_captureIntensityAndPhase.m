clear;
clc;

nImgs = 30;

numFrames = 100; % The number of frames to capture
dropFrames = 100; % The number of frames to drop before capturing

targetLoc = "../data/calib/csf";
if ~exist(targetLoc,"dir")
    mkdir(targetLoc)
end

pauseTime = 3;

% The serial number of the camera to connect to.
serial = '201000b';

% Find and connect to the camera based on its serial number
fprintf("creating camera...\n")
cam = tof.KeaCamera(tof.ProcessingConfig(), serial);
config = tof.CameraConfig("kea_3step_50MHz.bin");
config.setGain(2)
cam.setCameraConfig(config);


% Select to stream amplitude and z frames from the camera
tof.selectStreams(cam, [tof.FrameType.INTENSITY, tof.FrameType.PHASE]);

for imgIdx = 1:nImgs
    pause(pauseTime)
    writer = tof.createCsfWriterCamera(fullfile(targetLoc,sprintf("%d.csf",imgIdx)), cam);

    cam.start();
    disp('Camera started');
    
    for i = 1:dropFrames
        frames = cam.getFrames();
    end
    
    disp('Frames Dropped');
    
    for i = 1:numFrames
        frames = cam.getFrames();
    
        for frame = frames
            writer.writeFrame(frame);
        end
    
    end
    
    disp("Capture finished")
    
    cam.stop();

    beep
end



