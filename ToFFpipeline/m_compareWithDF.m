% m_compareWithDF 
% compares our pipeline with depth fields [S. Jayasuriya 2015]


clear
clc
close all


pth = fullfile("..\data\results\mat\plastic_saturation_2\");
% pth = fullfile("..\data\results\mat\occlusions\");
% pth = fullfile("..\data\results\mat\gray_head\");


[dLF, ampLF, LFargs] = readToFFarray(pth); 

tic
[dImg, debug] = ToFFImage(dLF, ampLF, LFargs, "occlusionMethod", 'threshold');
% [dImg, debug] = ToFFImage(dLF, ampLF, LFargs, "occlusionMethod", 'activecontour');
toc

clim = [min(dImg,[],'all'), max(dImg,[],'all')];

figure
imagesc(dImg, clim)
title('Ours')
colorbar



% single img
figure
imagesc(squeeze(dLF(LFargs.middleIdx,LFargs.middleIdx,:,:)), clim)
title('Single')


%% DF
% select point that is in middle of scene
pixel = [200; 159];


[ImgOut] = DepthFieldImage (distLF, depth,LFargs, pixel);

figure
imagesc(ImgOut, clim)


