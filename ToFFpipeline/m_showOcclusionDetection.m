% m_showOcclusionDetection
% Compare pipelines with and without occlusion detection 

clear
clc
close all


pth = fullfile("..\data\results\mat\occlusions\");

point(1).pixel = [190;112]; % occlusion due to thin wire
point(1).view = [-101,13];

point(2).pixel = [200; 159]; % middle of board
point(2).view = [-155, 13];

point(3).pixel = [143; 97]; % back screen near edge of board
point(3).view = [-194, 9];


pointIdx = 1; %change this to select different point
pixel = point(pointIdx).pixel;

[dLF, ampLF, LFargs] = readToFFarray(pth);

% show the centre view image and mark point of interest
figure
imagesc(squeeze(dLF(LFargs.middleIdx,LFargs.middleIdx,:,:)));
hold on
plot(pixel(1), pixel(2),'rx', LineWidth=1.2, MarkerSize=10)


[finalDist, singleDebug] = combineSinglePixelField (dLF, LFargs, pixel, 'occlusionMethod','activecontour', 'contour', 'edge');
plotTheoreticalvsMeasured(singleDebug.theoreticalGrid, singleDebug.distGrid, singleDebug.indexSubset)
view(point(pointIdx).view)


[finalDist, singleDebug] = combineSinglePixelField (dLF, LFargs, pixel, 'occlusionMethod','none');
plotTheoreticalvsMeasured(singleDebug.theoreticalGrid, singleDebug.distGrid, singleDebug.indexSubset)
view(point(pointIdx).view)

