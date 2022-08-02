% m_showOcclusionDetection.m
% show the effects of using occlusion detection by running over a full
% image

clear
clc
close all

pth = fullfile("..\data\results\mat\occlusions\");

[dLF, ampLF, LFargs] = readToFFarray(pth); 

% [dImg, debug] = ToFFImage(dLF, ampLF, LFargs, "occlusionMethod", 'activecontour');
tic
[dImg, debug] = ToFFImage(dLF, ampLF, LFargs, "occlusionMethod", 'threshold');
toc

figure
imagesc(dImg)
colorbar

[dImgNoOcclusion, debugNone] = ToFFImage(dLF, ampLF, LFargs, "occlusionMethod", 'none');

figure
imagesc(dImgNoOcclusion)
colorbar

% single img
figure
imagesc(squeeze(dLF(LFargs.middleIdx,LFargs.middleIdx,:,:)))