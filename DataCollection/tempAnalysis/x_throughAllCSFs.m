clear
clc
close all

addpath('../../ToFFpipeline/')
addpath('..')


N = 15; 
% N = 3; 

% folderName = 'side_wall_HQ';
folderName = 'side_wall_HQ_tempsafe';
% folderName = 'paper_side_wall_2';
% folderName = 'fruit';
resultsLoc = "../../data/results";
% resultsLoc = "G:\ACFR Winter storage\NewResults\";
dataFolder = fullfile(resultsLoc,"csf",folderName);



N = 15;

[tmps] = extractTempThoughAllCSFs(dataFolder, N);


figure
plot(tmps)
ylabel('temeprature')


