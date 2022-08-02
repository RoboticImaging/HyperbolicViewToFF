clear
clc
close all

pth = fullfile("..\data\results\mat\occlusions\");

[dLF, ampLF, LFargs] = readToFFarray(pth);
pixel = [130,99];

[finalDist, singleDebug] = combineSinglePixelField (dLF, LFargs, pixel)


