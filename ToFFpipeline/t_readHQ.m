clear
clc
close all


pth = fullfile("..\data\results\mat\gray_head");

[dImg, ampImg] = readHQimg(pth);

figure
subplot(121)
imagesc(dImg)
axis image
colorbar
subplot(122)
imagesc(ampImg)
axis image
colorbar
