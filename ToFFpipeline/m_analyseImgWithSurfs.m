% m_analyseImgWithSurfs
% show central image with the surface fits for some points (maybe have mouse click for coords?)

clear
clc
close all



pth = fullfile("..\data\results\mat\occlusions\");

[dLF, ampLF, LFargs] = readToFFarray(pth); 

tic
[dImg, debug] = ToFFImage(dLF, ampLF, LFargs, "occlusionMethod", 'threshold');
% [dImg, debug] = ToFFImage(dLF, ampLF, LFargs, "occlusionMethod", 'activecontour');
toc


% single img
figure
imagesc(squeeze(dLF(LFargs.middleIdx,LFargs.middleIdx,:,:)))


