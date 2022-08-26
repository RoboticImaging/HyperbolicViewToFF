clear
clc
close all

addpath('../../ToFFpipeline/')
addpath('..')


N = 15; 
% N = 3; 

% folderName = 'side_wall_HQ';
folderName = 'side_wall_HQ_tempsafe';
resultsLoc = "../../data/results";
% resultsLoc = "G:\ACFR Winter storage\NewResults\";
dataFolder = fullfile(resultsLoc,"csf",folderName);



tmp = load("cameraParams_july_2022.mat");
cameraParams = tmp.cameraParams_july_2022;


[~, ampLF, LFargs] = readToFFarray(fullfile(resultsLoc,"mat",folderName));


fileName = fullfile(dataFolder,"centerHQ.csf");


[dImgStack, tmps] = extractDepthAndTemp(fileName, LFargs);


figure
plot(tmps)
ylabel('temeprature')


% old paper (i.e. side_wall_HQ, paper_side wall)
% kVals = 95:214;
% lVals = 67:148;

% new paper (tempsafe ones)
kVals = 111:229;
lVals = 69:148;

% now to dImgs
for imgIdx = 1:size(dImgStack,3)
    dImg = squeeze(dImgStack(:,:,imgIdx));
    dImg = getPzimg(dImg, LFargs);
    dImgCropped = dImg(lVals,kVals);
    dist(imgIdx) = mean(dImgCropped(dImgCropped>0.2));
end

figure
plot(dist)
ylabel('mean Pz')


