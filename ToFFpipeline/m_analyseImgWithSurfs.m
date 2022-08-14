% m_analyseImgWithSurfs
% show central image with the surface fits for some points (maybe have mouse click for coords?)

clear
clc
close all

%% generate the figures

USE_PREDFINED_PIXELS = 0;
USE_PIPELINE_IMAGE = 0; % change to false for quicker testing

% pth = fullfile("..\data\results\mat\occlusions\");
pth = fullfile("..\data\results\mat\\many_objects\");

[dLF, ampLF, LFargs] = readToFFarray(pth); 

if USE_PIPELINE_IMAGE
    tic
    [dImg, debug] = ToFFImage(dLF, ampLF, LFargs, "occlusionMethod", 'threshold');
    % [dImg, debug] = ToFFImage(dLF, ampLF, LFargs, "occlusionMethod", 'activecontour');
    toc
end


if USE_PIPELINE_IMAGE
    % single img
    figure(2)
    plotDepthImg(dImg)
    hold on

    % single img
    figure(1)
else
    % single img
    figure(2)
end
plotDepthImg(dLF(LFargs.middleIdx,LFargs.middleIdx,:,:))
hold on


if USE_PREDFINED_PIXELS
    samplePoints = [    
                44.3384   32.1162
                76.2576  115.5505
                154   35.3485
                119.0859  174.3384
                188.5808  123.2273
                242.9242   97.7727
%               116.0098   63.4866
%                85.0314  124.4547
%               117.9871  175.5360
%               241.2415   96.7719
%               261.0149  156.0922
%               212.2405  207.1735
           ];
else
    [x,y] = ginput;
    samplePoints = [x,y];
end


fp = getATfontParams();

for pointIdx = 1:size(samplePoints,1)
    pixel = round(samplePoints(pointIdx,:));
    
    figure(2)
    plot(pixel(1), pixel(2), 'kx', LineWidth=2, MarkerSize=9)
    text(pixel(1), pixel(2), sprintf("   %d", pointIdx), HorizontalAlignment="left", FontSize= 16)

    [finalDist, singleDebug] = combineSinglePixelField (dLF, LFargs, pixel, 'occlusionMethod','threshold');
    figure(pointIdx+10)
    plotTheoreticalvsMeasured(singleDebug.theoreticalGrid, singleDebug.distGrid, singleDebug.indexSubset)
    title(sprintf("%d", pointIdx))
end


%% after orienting as desired, save all the figures

savePath = '../figs/analyseImgWithSurfs/';

% first save single img
figure(2)
save2pdf(gcf, fullfile(savePath, 'centreImg.pdf'))

for pointIdx = 1:size(samplePoints,1)
    figure(pointIdx+10)
    save2pdf(gcf, fullfile(savePath, sprintf('view_%d.pdf', pointIdx)))
end