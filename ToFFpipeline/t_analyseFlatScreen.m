clear
clc
close all

% pth = fullfile("..\data\results\mat\flat_screen_low_light\");
% pth = fullfile("..\data\results\mat\flat_screen\");
% pth = fullfile("..\data\results\mat\paper_side_wall\");
% pth = fullfile("..\data\results\mat\paper_side_wall_2\");
pth = fullfile("..\data\results\mat\side_wall_HQ");



[dLF, ampLF, LFargs] = readToFFarray(pth); 
[HQdistImg, ampImg] = readHQimg(pth);


[ToFFimg, debug] = ToFFImage(dLF, ampLF, LFargs, "occlusionMethod", 'threshold', 'threshold', -0.2);

pixel = [154;111];
[DFimg] = DepthFieldImage (dLF, LFargs, pixel);

singleImg = squeeze(dLF(LFargs.middleIdx, LFargs.middleIdx, :, :));

%%
% use the averaged image for the correct depth
kVals = 95:214;
lVals = 67:148;
Pzavg = getPzimg(HQdistImg, LFargs);

PzavgCrop = Pzavg(lVals,kVals);

Pz = mean(PzavgCrop(PzavgCrop > 0.7),'all');

% clim = [1.17, 1.35];  

%%
imgsToAnalyse = {singleImg, HQdistImg, ToFFimg, DFimg};
names = ["single", "N^2", "ToFF", "DF"];

clim = Pz + 0.06*[-1,1];   

figure
for i = 1:length(imgsToAnalyse)
    subplot(1,length(imgsToAnalyse), i);


    Pzimg = getPzimg(imgsToAnalyse{i}, LFargs);

    imCropped = Pzimg(lVals,kVals);
    fprintf('%s has rms %.4f\n',names(i),rms(imCropped - Pz,'all'))

    
    imagesc(imCropped, clim)
    axis image

    title(names(i));
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


