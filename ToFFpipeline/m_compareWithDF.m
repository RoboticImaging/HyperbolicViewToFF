% m_compareWithDF 
% compares our pipeline with depth fields [S. Jayasuriya 2015]


clear
clc
close all


% pth = fullfile("..\data\results\mat\plastic_saturation_2\");
% pth = fullfile("..\data\results\mat\occlusions\");
% pth = fullfile("..\data\results\mat\gray_head\");
pth = fullfile("..\data\results\mat\many_objects\");


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


%% DF
% select point that is in middle of scene
% pixel = [200; 159];
pixel = [125; 116];

[ImgOut] = DepthFieldImage (dLF,LFargs, pixel);

figure
imagesc(ImgOut, clim)


%% zoomed imgs for head
headLim = [0.77,0.97];
kLim = 100:143;
lLim = 95:180;
fp = getFontParams();
ap = getATaxisParams();

figure
subplot(131)
imagesc(singleDImg(lLim,kLim), headLim)
title('Single')
colorbar
axis image
axis off
set(gca, ap{:})

subplot(132)
imagesc(ImgOut(lLim,kLim), headLim)
title('DF')
colorbar
axis image
axis off
set(gca, ap{:})

subplot(133)
imagesc(dImg(lLim,kLim), headLim)
title('Ours')
h = colorbar;
axis image
axis off

set(gca, ap{:})
set(h, ap{:})
ylabel(h, 'Distance [m]', fp{:})

set(gcf,'Position',[488.0000  354.6000  730.2000  407.4000])


savePath = '../figs/compareWithDF/';

save2pdf(gcf, fullfile(savePath, 'compareWithDF.pdf'))
