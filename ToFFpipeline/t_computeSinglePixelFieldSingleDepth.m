clear;
clc;
close all;

pth = fullfile("..\data\results\mat\occlusions\");
pixel = [196; 159]; % middle of board

[dLF, ampLF, LFargs] = readToFFarray(pth);

dLFinterp = griddedInterpolant(dLF);

% Pz = 1;
Pz = 0.8399; % the correct value

[error] = computeSinglePixelFieldSingleDepth (dLFinterp, LFargs, pixel, Pz)




