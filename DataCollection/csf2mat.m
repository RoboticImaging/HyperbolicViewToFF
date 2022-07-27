clear;
clc;


N = 15; 

folderName = 'gray_head';
dataFolder = fullfile("../data/results/csf",folderName);
resultsFolder = fullfile("../data/results/mat",folderName);
if ~exist(resultsFolder, "dir")
    mkdir(resultsFolder)
end

copyfile(fullfile(dataFolder,"info.txt"),resultsFolder)

tmp = load("cameraParams_july_2022.mat");
cameraParams = tmp.cameraParams_july_2022;

for j = 1:N
    for k = 1:N
% for j = 1:1
%     for k = 1:1
        fileName = fullfile(dataFolder,sprintf('%d-%d.csf',j,k));
        cell_of_imgs = readCSF(fileName, [tof.FrameType.AMPLITUDE, tof.FrameType.PHASE]);

        amp = mean(cell_of_imgs{1}, 3);
        phi = mean(cell_of_imgs{2}, 3);

        % rectifications
        [amp,~] = undistortImage(amp,cameraParams);
        [phi,~] = undistortImage(phi,cameraParams);
        
        save(fullfile(resultsFolder,sprintf('%d-%d_phase.mat',j,k)), 'phi')
        save(fullfile(resultsFolder,sprintf('%d-%d_amplitude.mat',j,k)), 'amp')
    end
end

fileName = fullfile(dataFolder,"centerHQ.csf");
cell_of_imgs = readCSF(fileName, [tof.FrameType.AMPLITUDE, tof.FrameType.PHASE]);
amp = mean(cell_of_imgs{1}, 3);
phi = mean(cell_of_imgs{2}, 3);

% rectifications
[amp,~] = undistortImage(amp,cameraParams);
[phi,~] = undistortImage(phi,cameraParams);

save(fullfile(resultsFolder,"centerHQ_phase.mat"), 'phi')
save(fullfile(resultsFolder,"centerHQ_amplitude.mat"), 'amp')
