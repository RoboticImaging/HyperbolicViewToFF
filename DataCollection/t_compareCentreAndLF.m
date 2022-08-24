clear;
clc;
close all;

addpath('../ToFFpipeline/')


baseDir = "../data/results/mat";

pathToMat = fullfile(baseDir, "flat_screen_extreme_low_light/");

[dLF, ampLF, LFargs] = readToFFarray(pathToMat);

    
[distImg, ampImg] = readHQimg(pathToMat);

clim = [1.17,1.34];

figure
subplot(131)
centreLF = squeeze(dLF(LFargs.middleIdx, LFargs.middleIdx, :, :));
imagesc(centreLF, clim)
axis image

subplot(132)
imagesc(distImg, clim)
axis image


subplot(133)
imagesc(centreLF-distImg)
axis image

