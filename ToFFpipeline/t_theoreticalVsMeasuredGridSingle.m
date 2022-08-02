clear;
clc;
close all;

% pth = fullfile("..\data\results\mat\occlusions\");
% pixel = [190;112];

% pth = fullfile("..\data\results\mat\occlusions\");
% pixel = [200; 159]; % middle of board

% pth = fullfile("..\data\results\mat\small_N\");

pth = fullfile("..\data\results\mat\plastic_saturation_2\");
% pixel = [146;151];% saturated in centre view
pixel = [150;146]; % wooden bird chest

[dLF, ampLF, LFargs] = readToFFarray(pth);


% pixel = [94;152];
% pixel = [300;152];
% pixel = [130;149];
% pixel = [149;75];

r = dLF(LFargs.middleIdx, LFargs.middleIdx, pixel(2), pixel(1));
P = radialDist2point(r, LFargs, pixel);
Pz = P(3);


grid = getOtherViewIndexes (pixel, LFargs, Pz);


% get the distGrid
gridInterp = griddedInterpolant(dLF);
distGrid = gridInterp(grid{2}(:), grid{1}(:), grid{4}(:), grid{3}(:));

theoreticalGrid = getTheoreticalSurface (pixel, P(3), LFargs);

plotTheoreticalvsMeasured(theoreticalGrid, distGrid, rejectInvalidDataPts(distGrid));

