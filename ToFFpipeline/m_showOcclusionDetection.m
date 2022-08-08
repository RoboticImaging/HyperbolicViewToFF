% m_showOcclusionDetection.m
% show the effects of using occlusion detection by running over a full
% image

clear
clc
close all

pth = fullfile("..\data\results\mat\occlusions\");

[dLF, ampLF, LFargs] = readToFFarray(pth); 

% [dImg, debug] = ToFFImage(dLF, ampLF, LFargs, "occlusionMethod", 'activecontour');
tic
[dImg, debug] = ToFFImage(dLF, ampLF, LFargs, "occlusionMethod", 'threshold');
toc

clim = [min(dImg,[],'all'), max(dImg,[],'all')];


[dImgNoOcclusion, debugNone] = ToFFImage(dLF, ampLF, LFargs, "occlusionMethod", 'none');


%% plotting
figure(1)
plotDepthImg(dImg,clim)

figure(2)
plotDepthImg(dImgNoOcclusion,clim)

% single img
figure(3)
plotDepthImg(dLF(LFargs.middleIdx,LFargs.middleIdx,:,:),clim)

% debug images
rmse = zeros(LFargs.size(3), LFargs.size(4));
for k = 1:LFargs.size(3)
    for l = 1:LFargs.size(4)
        rmse(k,l) = evaluateGoF (debugNone(k,l).distGrid, debugNone(k,l).theoreticalGrid, debugNone(k,l).indexSubset);
    end
end
rmseClim = [0,prctile(rmse, 99,'all')];
generateDebugFigs(debug, LFargs,rmseClim) % generates fig 4,5
generateDebugFigs(debugNone, LFargs,rmseClim) % generates fig 6,7

%% saving

savePath = '../figs/occlusionDetection/';

figSaves = [
    "dimgOcclusionAware",...
    "dimgNoOcc",...
    "singleImg",...
    "debugNpts",...
    "debugrmse",...
    "debugNoneNpts",...
    "debugNoneRmse"
    ];

for i = 1:length(figSaves)
    figure(i)
    save2pdf(gcf, fullfile(savePath, sprintf("%s.pdf", figSaves(i))))
end
