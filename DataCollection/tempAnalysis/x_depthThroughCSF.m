clear
clc
close all

addpath('../../ToFFpipeline/')


N = 15; 
% N = 3; 

folderName = 'side_wall_HQ';
resultsLoc = "../data/results";
% resultsLoc = "G:\ACFR Winter storage\NewResults\";
dataFolder = fullfile(resultsLoc,"csf",folderName);



tmp = load("cameraParams_july_2022.mat");
cameraParams = tmp.cameraParams_july_2022;

[~, ~, LFargs] = readToFFarray(fullfile(resultsLoc,"mat",folderName));


fileName = fullfile(dataFolder,"centerHQ.csf");


[dImgStack, tmps] = extractDepthAndTemp(file, LFargs);


figure
plot(tmps)
ylabel('temeprature')


% now to dImgs
for imgIdx = 1:size(dImgStack,3)
    dImg = squeeze(dImgStack(:,:,imgIdx));
    dist(imgIdx) = mean(dImg(dImg>0.2));
end

figure
plot(dist)


