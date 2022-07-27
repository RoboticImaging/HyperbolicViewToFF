clear;
clc;
close all;

addpath('../ToFFpipeline/')

N = 15;

baseDir = "../data/results/mat";

pathToMat = fullfile(baseDir, "gray_head");

cameraParams = load("cameraParams_july_2022.mat","cameraParams_july_2022");
[phaseLF,ampLF] = readToFF(pathToMat,N, cameraParams);


LFDispLawnmower(phaseLF)
