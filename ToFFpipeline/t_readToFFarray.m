clear
clc
close all

% pth = fullfile("..\data\results\mat\gray_head");
% pth = fullfile("..\data\results\mat\many_objects\");
% pth = fullfile("..\data\results\mat\occlusions\");
pth = fullfile("..\data\results\mat\plastic_saturation_2\");

[dLF, ampLF, LFargs] = readToFFarray(pth);

% figure
% LFDispMousePan(dLF)
% 
% figure
% LFDispMousePan(ampLF)

LFDispLawnmower(dLF)

LFargs