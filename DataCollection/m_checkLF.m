clear;
clc;
close all;

addpath('../ToFFpipeline/')


baseDir = "../data/results/mat";

pathToMat = fullfile(baseDir, "plastic_boxes");

[dLF, ampLF, LFargs] = readToFFarray(pathToMat);


% LFDispLawnmower(dLF)
LFDispMousePan(dLF)
