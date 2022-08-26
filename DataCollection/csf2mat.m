clear;
clc;


N = 15; 
% N = 3; 

folderName = 'side_wall_HQ_tempsafe';
% folderName = 'plastic_saturation_2';
resultsLoc = "../data/results";
% resultsLoc = "G:\ACFR Winter storage\NewResults\";
dataFolder = fullfile(resultsLoc,"csf",folderName);
resultsFolder = fullfile(resultsLoc,"mat",folderName);
if ~exist(resultsFolder, "dir")
    mkdir(resultsFolder)
end

copyfile(fullfile(dataFolder,"info.txt"),resultsFolder)
copyfile(fullfile(dataFolder,"LFargs.mat"),resultsFolder)

tmp = load("cameraParams_july_2022.mat");
cameraParams = tmp.cameraParams_july_2022;




fileName = fullfile(dataFolder,"centerHQ.csf");
cell_of_imgs = readCSF(fileName, [tof.FrameType.AMPLITUDE, tof.FrameType.PHASE]);
amp = mean(cell_of_imgs{1}, 3);
phi = mean(cell_of_imgs{2}, 3);

% rectifications
[amp,~] = undistortImage(amp,cameraParams);
[phi,~] = undistortImage(phi,cameraParams);

save(fullfile(resultsFolder,"centerHQ_phase.mat"), 'phi')
save(fullfile(resultsFolder,"centerHQ_amplitude.mat"), 'amp')




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

