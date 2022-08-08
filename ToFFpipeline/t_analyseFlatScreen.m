clear
clc
close all

pth = fullfile("..\data\results\mat\flat_screen_low_light\");
% pth = fullfile("..\data\results\mat\flat_screen\");

% kcrop
% clim = [1.17, 1.35];  
clim = [1.17,1.21];   

[dLF, ampLF, LFargs] = readToFFarray(pth); 
[distImg, ampImg] = readHQimg(pth);


[dImg, debug] = ToFFImage(dLF, ampLF, LFargs, "occlusionMethod", 'none');

pixel = [154;111];
[ImgOut] = DepthFieldImage (dLF, LFargs, pixel);

figure
subplot(141)
centreImgSingle = squeeze(dLF(LFargs.middleIdx, LFargs.middleIdx, :, :));
imagesc(getPzimg(centreImgSingle, LFargs), clim)
axis image

subplot(142)
imagesc(getPzimg(distImg, LFargs), clim)
axis image

subplot(143)
imagesc(getPzimg(dImg, LFargs), clim)
axis image

subplot(144)
imagesc(getPzimg(ImgOut, LFargs), clim)
axis image

figure
imagesc(getPzimg(ImgOut, LFargs) - getPzimg(distImg, LFargs), 0.03*[-1,1])

% figure
% subplot(131)
% centreImgSingle = squeeze(ampLF(LFargs.middleIdx, LFargs.middleIdx, :, :));
% imagesc(centreImgSingle)
% 
% subplot(132)
% imagesc(ampImg)


