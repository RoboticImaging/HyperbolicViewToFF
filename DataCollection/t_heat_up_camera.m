% check if the camera has temperature calibration set by default

clear
clc
close all


configFile = "kea_3step_50MHz.bin";
gain = 1.8;
intTime = 1774;

serial = '201000b';

% Find and connect to the camera based on its serial number
fprintf("creating camera...");
cam = tof.KeaCamera(tof.ProcessingConfig(), serial);
config = tof.CameraConfig(configFile);
config.setGain(gain)
config.setIntegrationTime(1, intTime)
cam.setCameraConfig(config);


% Select to stream amplitude and z frames from the camera
tof.selectStreams(cam, [tof.FrameType.AMPLITUDE, tof.FrameType.PHASE]);

fprintf("Done!\n");


cam.start()

nFrames = 1;

while (1)
    frames = cam.getFrames();

    if mod(nFrames,1000) == 0
        temps = frames(1).temperatures;
        fprintf("Frame %d. Temperatures are [", nFrames)
        fprintf("%.2f, ",frames(2).temperatures())
        fprintf("\b\b]\n")
    end
    nFrames = nFrames + 1;
end


%% 

cam.stop()




