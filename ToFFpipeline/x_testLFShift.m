clear;
clc;
close all;

% set up memory
% folder = fullfile("G:\ACFR Winter storage\TOFF\matFiles\blocksAndScreen");
folder = fullfile("G:\ACFR Winter storage\TOFF\matFiles\blocksWithoutScreen");



[pLF,aLF] = readToFF(folder,15);

tic
[~,~,newLF] = LFFiltShiftSum(pLF,2);
newLF = squeeze(newLF(:,:,:,:,1));
toc

tic
myLF = ATshiftLF(pLF, 2);
toc


t = 8;
rowCut = 114;
figure
imagesc(squeeze(pLF(t,:,rowCut,:)));
title('original epi')
figure
imagesc(squeeze(newLF(t,:,rowCut,:)));
title('LFFiltShiftSum epi')
figure
imagesc(squeeze(myLF(t,:,rowCut,:)));
title('my epi')



