clear
clc
close all

RGB = imread('peppers.png');
L = superpixels(RGB,500);
imshow(RGB)
h1 = drawpolygon('Position',[72,105; 1,231; 0,366; 104,359;...
        394,307; 518,343; 510,39; 149,72]);
roiPoints = h1.Position;
roi = poly2mask(roiPoints(:,1),roiPoints(:,2),size(L,1),size(L,2));


BW = grabcut(RGB,L,roi);
imshow(BW)