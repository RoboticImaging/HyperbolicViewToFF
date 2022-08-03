clear;
clc;
close all;

addpath('../ToFFpipeline/')


baseDir = "../data/results/mat";

pathToMat = fullfile(baseDir, "testing_N_3");

[dLF, ampLF, LFargs] = readToFFarray(pathToMat);


LFDispLawnmower(dLF)
