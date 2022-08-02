
clear
clc
close all


% pth = fullfile("..\data\results\mat\occlusions\");

pth = fullfile("..\data\results\mat\gray_head\");
headLim = [0.77,0.9];
kLim = 100:143;
lLim = 95:180;

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
singleDImg = squeeze(dLF(LFargs.middleIdx,LFargs.middleIdx,:,:));
imagesc(singleDImg, clim)
title('Single')


%% zoomed imgs

figure
subplot(121)
imagesc(dImg(lLim,kLim), headLim)
title('Ours')
colorbar
axis image

subplot(122)
imagesc(singleDImg(lLim,kLim), headLim)
title('Single')
colorbar
axis image

