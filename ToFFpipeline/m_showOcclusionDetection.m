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

%% surfaces
pixel = [181; 84]; % back screen near edge of board
surfView = [-193, 9];

[~, singleDebugNone] = combineSinglePixelField (dLF, LFargs, pixel, 'occlusionMethod','none');
[~, singleDebugThresh] = combineSinglePixelField (dLF, LFargs, pixel, 'occlusionMethod','threshold');

%% debug figs

[nPtsNone, rmseNone] = generateDebugFigs(debugNone, LFargs, [0,1], false);
[nPtsThresh, rmseThresh] = generateDebugFigs(debug, LFargs, [0,1], false);
rmseClim = [0,prctile(rmseNone, 99,'all')];
nPtsClim = [0,1];

%% plotting

% 1st column is naive, 2nd is ours
% rows:
% dist img (with colorbar)
% surfaces
% nPts
% rmse


fp = getFontParams();
ap = getATaxisParams();

fig = figure('Position',[488.0000  131.0000  380.6000  631.0000]);


sv = 0.08;
mr = 0.2;

ax(1) = subaxis(4,2,1, 'sv',sv, 'sh', 0.01,'MarginLeft',.15,'MarginRight',mr);
plotDepthImg(dImgNoOcclusion, clim, 'useCbar', false)
hold on
plot(pixel(1), pixel(2),'kx', LineWidth=1.2, MarkerSize=10)

title('Naive', fp{:})


ax(2) = subaxis(4,2,2, 'sv',sv, 'sh', 0.01,'MarginLeft',.15,'MarginRight',mr);
plotDepthImg(dImg, clim, 'useCbar', false)
hold on
plot(pixel(1), pixel(2),'kx', LineWidth=1.2, MarkerSize=10)

title('Occlusion Aware', fp{:})


ax(3) = subaxis(4,2,3, 'sv',sv , 'sh', 0.01,'MarginLeft',.15,'MarginRight',0.12);
plotTheoreticalvsMeasured(singleDebugNone.theoreticalGrid, singleDebugNone.distGrid, singleDebugNone.indexSubset)
view(surfView)

ax(4) = subaxis(4,2,4, 'sv',sv, 'sh', 0.01,'MarginLeft',.15,'MarginRight',0.12);
plotTheoreticalvsMeasured(singleDebugThresh.theoreticalGrid, singleDebugThresh.distGrid, singleDebugThresh.indexSubset)
view(surfView)
zlabel('')

ax(5) = subaxis(4,2,5, 'sv',sv, 'sh', 0.01,'MarginLeft',.15,'MarginRight',mr);
plotDepthImg(nPtsNone/(LFargs.N^2), nPtsClim, 'useCbar', false)

ax(6) = subaxis(4,2,6, 'sv',sv, 'sh', 0.01,'MarginLeft',.15,'MarginRight',mr);
plotDepthImg(nPtsThresh/(LFargs.N^2), nPtsClim, 'useCbar', false)

ax(7) = subaxis(4,2,7, 'sv',sv, 'sh', 0.01,'MarginLeft',.15,'MarginRight',mr);
plotDepthImg(rmseNone, rmseClim, 'useCbar', false)

ax(8) = subaxis(4,2,8, 'sv',sv, 'sh', 0.01,'MarginLeft',.15,'MarginRight',mr);
plotDepthImg(rmseThresh, rmseClim, 'useCbar', false)


% bar for row 1
h = axes(fig,'visible','off');
c1 = colorbar(h,'Position',[(ax(2).Position(1) + ax(2).Position(3) + 0.01) ax(2).Position(2) 0.022 ax(2).Position(4)]);  % attach colorbar to h
caxis(h, clim);    
set(c1, ap{:})
ylabel(c1, 'Distance [m]', fp{:})

% bar for row 3
h = axes(fig,'visible','off');
c2 = colorbar(h,'Position',[(ax(6).Position(1) + ax(6).Position(3) + 0.01) ax(6).Position(2) 0.022 ax(6).Position(4)]);  % attach colorbar to h
caxis(h, nPtsClim);    
set(c2, ap{:})
% ylabel(c2, 'Views Used', fp{:})

% bar for row 4
h = axes(fig,'visible','off');
c3 = colorbar(h,'Position',[(ax(8).Position(1) + ax(8).Position(3) + 0.01) ax(8).Position(2) 0.022 ax(8).Position(4)]);  % attach colorbar to h
caxis(h, rmseClim);    
set(c3, ap{:})
% ylabel(c3, 'RMSE [m]', fp{:})

% text below plots
fp{2} = 12;

row = 1;
ax(1).Position(1)
% textX = (ax(1).Position(1) + ax(1).Position(3) + ax(2).Position(1))/2;
textX = ax(1).Position(1) + ax(1).Position(3);

offsetY = 0.05;
txtOpts = ["Units","normalized", "HorizontalAlignment","center","VerticalAlignment","middle", "edgeColor","none"];


subtitles = ["ToFF image", "Fit at occlusion", "Prop. views used","RMSE [m]"];

for i = 1:4
    textY = ax(2*i).Position(2)- offsetY;
%     text(textX,textY,subtitles(i),txtOpts{:}, fp{:})
    annotation('textbox', [textX-0.5/2, textY, 0.5, 0], 'string', subtitles(i), txtOpts{:}, fp{:})
end




% figure(1)
% plotDepthImg(dImg,clim)
% 
% figure(2)
% plotDepthImg(dImgNoOcclusion,clim)
% 
% % single img
% figure(3)
% plotDepthImg(dLF(LFargs.middleIdx,LFargs.middleIdx,:,:),clim)
% 
% % debug images
% rmse = zeros(LFargs.size(3), LFargs.size(4));
% for k = 1:LFargs.size(3)
%     for l = 1:LFargs.size(4)
%         rmse(k,l) = evaluateGoF (debugNone(k,l).distGrid, debugNone(k,l).theoreticalGrid, debugNone(k,l).indexSubset);
%     end
% end
% rmseClim = [0,prctile(rmse, 99,'all')];
% generateDebugFigs(debug, LFargs,rmseClim) % generates fig 4,5
% generateDebugFigs(debugNone, LFargs,rmseClim) % generates fig 6,7

%% saving

savePath = '../figs/occlusionDetection/';

save2pdf(gcf, fullfile(savePath, 'occlusionDetectCompare'))

% figSaves = [
%     "dimgOcclusionAware",...
%     "dimgNoOcc",...
%     "singleImg",...
%     "debugNpts",...
%     "debugrmse",...
%     "debugNoneNpts",...
%     "debugNoneRmse"
%     ];
% 
% for i = 1:length(figSaves)
%     figure(i)
%     save2pdf(gcf, fullfile(savePath, sprintf("%s.pdf", figSaves(i))))
% end
