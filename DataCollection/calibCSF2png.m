clear;
clc;
close all

N = 5;

pathPrefix = "../data/calib/";
dataFolder = fullfile(pathPrefix,"csf/withPhase");
target = fullfile(pathPrefix,"png/withPhase");

if ~exist(target,"dir")
    mkdir(target)
end

filesToChange = dir(fullfile(dataFolder,"*.csf"));

for imgIdx = 1:length(filesToChange)
    csfRead = tof.CsfReader(fullfile(dataFolder,filesToChange(imgIdx).name));
    
    frameSize = [320,240];
    frame = zeros(frameSize(1),frameSize(2),1);
    
    while csfRead.frameIndex ~= csfRead.numberOfFrames()
        frames = csfRead.readFrame();
        if frames.frameType() == tof.FrameType.INTENSITY
            frame(:,:,csfRead.frameIndex) = frames.data;
        end
    end
    % avgFrame = mean(frame,3);
    % avgFrame = rot90(avgFrame, 1);
    % avgFrame = flipud(avgFrame);
    
    avgFrame = flip(mean(frame,3)',2);
    avgFrame = avgFrame./max(avgFrame,[],"all");
    imwrite(avgFrame, fullfile(target,sprintf("%d.png",imgIdx)))
end

% for k = 1:N
%     fileName = strcat(dataFolder,sprintf('%d-%d.csf',j,k));
%     csf_type = CSFType(); 
%     [~,frames_phi] = bufferCSF(fileName, csf_type('phi') ); 
%     [~,frames_amp] = bufferCSF(fileName, csf_type('amp') ); 
%     
%     % flip things so they are the right way around and average across
%     % all frames
%     amp = flip(mean(frames_amp,3)',2);
%     phi = flip(mean(frames_phi,3)',2);
% end

% figure
% imagesc(amp)