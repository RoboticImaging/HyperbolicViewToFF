clear
clc
close all

pth = fullfile("..\data\results\mat\gray_head");

[dLF, ampLF, LFargs] = readToFFarray(pth);

figure
LFDispMousePan(dLF)

figure
LFDispMousePan(ampLF)

LFargs