clear;
clc;



intensity_clim = [0, 255];

% The serial number of the camera to connect to.
serial = '201000b';

% Find and connect to the camera based on its serial number
fprintf("creating camera...\n")
cam = tof.KeaCamera(tof.ProcessingConfig(), serial);

%{
config = cam.getCameraConfig();

fprintf("clearing default frames...\n")
while config.frameSize() > 1
    config.eraseFrame(1);
end

% Phase shifts for harmonic cancellation
config.setPhaseShifts(0, [0 0.25 0.375 0.625]);
config.setIntegrationTime(0, [750 750 750 750]);

config.setModulationFrequency(0, 40);
%}
config = tof.CameraConfig("kea_3step_50MHz.bin");
cam.setCameraConfig(config);



% Select to stream amplitude and z frames from the camera
tof.selectStreams(cam, [tof.FrameType.INTENSITY]);

% Get the image size we are expecting so we can size the window correctly.
config = cam.getCameraConfig();
roi = config.getRoi(0);
nrows = roi.getImgRows();
ncols = roi.getImgCols();

imhandle2 = imagesc(ones(nrows, ncols, 'uint8'), intensity_clim);
ax2 = gca;
title('Intensity');

cam.start()

% While the camera is running display what is going on.
while cam.isStreaming()
    frames = cam.getFrames();

    for frame = frames

        if frame.frameType() == tof.FrameType.INTENSITY
            set(imhandle2, 'CData', rot90(frame.data(), 1));
            colormap(ax2, 'gray');
        end

    end

    drawnow;
    pause(0.5)
end
cam.stop()

return

proc = tof.ProcessingConfig();
proc.setMedianEnabled(true);
proc.setMedianSize(5);

cam = tof.camCamera(proc, serial);

cap_types = [tof.FrameType.PHASE, tof.FrameType.INTENSITY, tof.FrameType.Z];
tof.selectStreams(cam, cap_types);

% Init the CSF writer
writer = tof.createCsfWriterCamera(fileName, cam);

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
