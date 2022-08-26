clear
clc
close all

% pth = fullfile("..\data\results\mat\flat_screen_low_light\");
% pth = fullfile("..\data\results\mat\flat_screen\");
% pth = fullfile("..\data\results\mat\paper_side_wall\");
% pth = fullfile("..\data\results\mat\paper_side_wall_2\");
pth = fullfile("..\data\results\mat\side_wall_HQ_tempsafe\");
% pth = fullfile("..\data\results\mat\paper_side_wall_2_low_light\");
% pth = fullfile("..\data\results\mat\side_wall_HQ");



[imgsToAnalyse, methodNames, LFargs] = getAllMethodImgs(pth);

%%
% use the averaged image for the correct depth
% old paper (i.e. side_wall_HQ, paper_side wall)
% kVals = 95:214;
% lVals = 67:148;

% new paper (tempsafe ones)
kVals = 111:229;
lVals = 69:148;
Pzavg = getPzimg(imgsToAnalyse{2}, LFargs);

PzavgCrop = Pzavg(lVals,kVals);

Pz = mean(PzavgCrop(PzavgCrop > 0.7),'all');

% clim = [1.17, 1.35];  

%%


clim = Pz + 0.02*[-1,1];   

figure
for i = 1:length(imgsToAnalyse)
    subplot(1,length(imgsToAnalyse), i);


    Pzimg = getPzimg(imgsToAnalyse{i}, LFargs);

    imCropped = Pzimg(lVals,kVals);
    fprintf('%s has rms (all in crop) %.4f\n',methodNames(i),rms(imCropped - Pz,'all'))
    fprintf('%s has rms (excluding dead) %.4f\n',methodNames(i),rms(imCropped(rejectInvalidDataPts(imCropped)) - Pz,'all'))

    
    imagesc(imCropped, clim)
    axis image
    colorbar

    title(methodNames(i));
end

% figure
% imagesc(getPzimg(DFimg, LFargs) - getPzimg(HQdistImg, LFargs), 0.03*[-1,1])




% figure
% subplot(131)
% centreImgSingle = squeeze(ampLF(LFargs.middleIdx, LFargs.middleIdx, :, :));
% imagesc(centreImgSingle)
% 
% subplot(132)
% imagesc(ampImg)


