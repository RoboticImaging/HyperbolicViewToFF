clear;
clc;
close all;

addpath('../ToFFpipeline/')


baseDir = "../data/results/mat";

pathToMat = fullfile(baseDir, "testing_N_3");

[dLF, ampLF, LFargs] = readToFFarray(pathToMat);


[distImg, ampImg] = readHQimg(pathToMat);

figure
subplot(131)
centreLF = squeeze(dLF(LFargs.middleIdx, LFargs.middleIdx, :, :));
imagesc(centreLF)
axis image

subplot(132)
imagesc(distImg)
axis image


subplot(133)
imagesc(centreLF-distImg)
axis image

