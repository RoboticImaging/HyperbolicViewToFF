clear
clc
close all

pth = fullfile("..\data\results\mat\flat_screen_very_low_light\");
% pth = fullfile("..\data\results\mat\flat_screen\");
clim = [1.17, 1.35];    

[dLF, ampLF, LFargs] = readToFFarray(pth); 
[distImg, ampImg] = readHQimg(pth);


[dImg, debug] = ToFFImage(dLF, ampLF, LFargs, "occlusionMethod", 'none');


figure
subplot(131)
centreImgSingle = squeeze(dLF(LFargs.middleIdx, LFargs.middleIdx, :, :));
imagesc(centreImgSingle, clim)
axis image

subplot(132)
imagesc(distImg, clim)
axis image

subplot(133)
imagesc(dImg, clim)
axis image


% figure
% subplot(131)
% centreImgSingle = squeeze(ampLF(LFargs.middleIdx, LFargs.middleIdx, :, :));
% imagesc(centreImgSingle)
% 
% subplot(132)
% imagesc(ampImg)


