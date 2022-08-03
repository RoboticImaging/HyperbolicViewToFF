clear
clc
close all

% pth = fullfile("..\data\results\mat\flat_screen_low_light\");
pth = fullfile("..\data\results\mat\flat_screen\");
clim = [1.17, 1.35];    

[dLF, ampLF, LFargs] = readToFFarray(pth); 
[distImg, ampImg] = readHQimg(pth);


[dImg, debug] = ToFFImage(dLF, ampLF, LFargs, "occlusionMethod", 'threshold');


figure
subplot(131)
centreImgSingle = squeeze(dLF(LFargs.middleIdx, LFargs.middleIdx, :, :));
imagesc(centreImgSingle, clim)

subplot(132)
imagesc(distImg, clim)

subplot(133)
imagesc(dImg, clim)


% figure
% subplot(131)
% centreImgSingle = squeeze(ampLF(LFargs.middleIdx, LFargs.middleIdx, :, :));
% imagesc(centreImgSingle)
% 
% subplot(132)
% imagesc(ampImg)


