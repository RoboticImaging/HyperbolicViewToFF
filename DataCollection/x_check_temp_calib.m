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


cam.getCalibration()



