% m_analyseImgWithSurfs
% show central image with the surface fits for some points (maybe have mouse click for coords?)

clear
clc
close all

USE_PREDFINED_PIXELS = true;
USE_PIPELINE_IMAGE = false; % change to false for quicker testing

pth = fullfile("..\data\results\mat\occlusions\");

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
    imagesc(dImg)
    hold on

    % single img
    figure(1)
    imagesc(squeeze(dLF(LFargs.middleIdx,LFargs.middleIdx,:,:)))
    hold on
else
    % single img
    figure(2)
    imagesc(squeeze(dLF(LFargs.middleIdx,LFargs.middleIdx,:,:)))
    hold on
end


if USE_PREDFINED_PIXELS
    samplePoints = [
          195.5968  153.9035
          240.1313   97.4825
          127.1728  213.1316
          139.8548  104.2193
           35.4493   22.5351
           ];
else
    [x,y] = ginput;
    samplePoints = [x,y];
end

for pointIdx = 1:size(samplePoints,1)
    pixel = round(samplePoints(pointIdx,:));
    
    figure(2)
    plot(pixel(1), pixel(2), 'rx')
    text(pixel(1), pixel(2), sprintf("  %d", pointIdx))

    [finalDist, singleDebug] = combineSinglePixelField (dLF, LFargs, pixel, 'occlusionMethod','threshold');
    plotTheoreticalvsMeasured(singleDebug.theoreticalGrid, singleDebug.distGrid, singleDebug.indexSubset)
    title(sprintf("%d", pointIdx))
end




