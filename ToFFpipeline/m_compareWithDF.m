% m_compareWithDF 
% compares our pipeline with depth fields [S. Jayasuriya 2015]


clear
clc
close all


pth = fullfile("..\data\results\mat\occlusions\");
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

% calculate Pz
r = dLF(LFargs.middleIdx, LFargs.middleIdx, pixel(2), pixel(1));
P = radialDist2point(r, LFargs, pixel);

% calculate slope
slope = -LFargs.K(1,1)*LFargs.baseline/(P(3)*(LFargs.N));

% shift and sum the LF
ImgOut = LFFiltShiftSum(dLF, slope);
ImgOut = ImgOut(:,:,1);

figure
imagesc(ImgOut, clim)


