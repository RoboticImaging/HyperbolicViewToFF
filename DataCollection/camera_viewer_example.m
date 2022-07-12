% Example of configuring the Chronoptics Kea Camera and streaming Z distance
% and intensity.
%
%% Camera Configuration Options

% Serial Number of the camera to connect to.
serial = '201000b';
% The visualization limits for the Z and intensity data.
z_clim = [0, 3000];
intensity_clim = [0, 255];

%% Depth Pipeline Configuration Options
proc = tof.ProcessingConfig();

%% Connect to camera
% Find and connect to the camera based on its serial number
kea = tof.KeaCamera(proc, serial);

% Select to stream amplitude and z frames from the camera
tof.selectStreams(kea, [tof.FrameType.Z tof.FrameType.INTENSITY]);

% Get the image size we are expecting so we can size the window correctly.
config = kea.getCameraConfig();
roi = config.getRoi(0);
nrows = roi.getImgRows();
ncols = roi.getImgCols();

%% Start streaming
kea.start();

fig = figure();
subplot(121);
imhandle = imagesc(ones(nrows, ncols, 'single'), z_clim);
ax1 = gca;
title('Z Distance');

subplot(122);
imhandle2 = imagesc(ones(nrows, ncols, 'uint8'), intensity_clim);
ax2 = gca;
title('Intensity');

% When we close the window stop the camera.
set(fig, 'CloseRequestFcn', 'kea.stop(); closereq')

% While the camera is running display what is going on.
while kea.isStreaming()
    frames = kea.getFrames();

    for frame = frames

        if frame.frameType() == tof.FrameType.Z
            set(imhandle, 'CData', rot90(frame.data(), 1));
            colormap(ax1, 'jet');
        elseif frame.frameType() == tof.FrameType.INTENSITY
            set(imhandle2, 'CData', rot90(frame.data(), 1));
            colormap(ax2, 'gray');
        end

    end

    drawnow;
end
