clear
clc
close all

% pth = fullfile("..\data\results\mat\flat_screen_low_light\");
pth = fullfile("..\data\results\mat\flat_screen\");


[dLF, ampLF, LFargs] = readToFFarray(pth); 
[HQdistImg, ampImg] = readHQimg(pth);


[ToFFimg, debug] = ToFFImage(dLF, ampLF, LFargs, "occlusionMethod", 'threshold', 'threshold', -0.2);

pixel = [154;111];
[DFimg] = DepthFieldImage (dLF, LFargs, pixel);

singleImg = squeeze(dLF(LFargs.middleIdx, LFargs.middleIdx, :, :));


% use the averaged image for the correct depth
kVals = 36:249;
lVals = 36:197;
Pzavg = getPzimg(HQdistImg, LFargs);

Pz = mean(Pzavg(lVals,kVals),'all');

% clim = [1.17, 1.35];  
clim = Pz + 0.03*[-1,1];   


imgsToAnalyse = {singleImg, HQdistImg, ToFFimg, DFimg};
names = ["single", "N^2", "ToFF", "DF"];

figure
for i = 1:length(imgsToAnalyse)
    subplot(1,length(imgsToAnalyse), i);
    imagesc(getPzimg(imgsToAnalyse{i}, LFargs), clim)
    axis image

    imCropped = imgsToAnalyse{i}(lVals,kVals);
    rms(imCropped - Pz,'all')

    title(names(i));
end

figure
imagesc(getPzimg(DFimg, LFargs) - getPzimg(HQdistImg, LFargs), 0.03*[-1,1])




% figure
% subplot(131)
% centreImgSingle = squeeze(ampLF(LFargs.middleIdx, LFargs.middleIdx, :, :));
% imagesc(centreImgSingle)
% 
% subplot(132)
% imagesc(ampImg)


