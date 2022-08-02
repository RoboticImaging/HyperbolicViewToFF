clear;
clc;
close all;

pth = fullfile("..\data\results\mat\occlusions\");
% pixel = [190;112]; % occlusion due to thin wire
pixel = [200; 159]; % middle of board
% pixel = [143; 97]; % back screen near edge of board

[dLF, ampLF, LFargs] = readToFFarray(pth);

figure
imagesc(squeeze(dLF(LFargs.middleIdx,LFargs.middleIdx,:,:)));
hold on
ATplot(pixel(1), pixel(2),'rx')

% pixel = [94;152];
% pixel = [300;152];
% pixel = [130;149];
% pixel = [149;75];

r = dLF(LFargs.middleIdx, LFargs.middleIdx, pixel(2), pixel(1));
P = radialDist2point(r, LFargs, pixel);
Pz = P(3);


grid = getOtherViewIndexes (pixel, LFargs, Pz);


% get the distGrid
gridInterp = griddedInterpolant(dLF);
distGrid = gridInterp(grid{2}(:), grid{1}(:), grid{4}(:), grid{3}(:));

distGrid = reshape(distGrid, [LFargs.N, LFargs.N]);

theoreticalGrid = getTheoreticalSurface (pixel, P(3), LFargs);


figure
imagesc(distGrid)
title('Original distance grid')
axis image
colorbar

opts = ["none", "activecontour", "lazysnapping"];

figure
for i = 1:length(opts)
    subplot(1,length(opts),i);
    tic
    newmask = rejectOcclusionOutliers(distGrid, 'method', opts(i));
    t = toc;
    newmask = reshape(newmask, size(distGrid));
    imagesc(newmask)
    title(sprintf("%s, %f s", opts(i), t))
    axis image
end


% now try using the distance error instead
figure
imagesc(distGrid - theoreticalGrid)
title('Original error')
axis image
colorbar

figure
for i = 1:length(opts)
    subplot(1,length(opts),i);
    tic
    newmask = rejectOcclusionOutliers(distGrid - theoreticalGrid, 'method', opts(i));
    t = toc;
    newmask = reshape(newmask, size(distGrid));
    imagesc(newmask)
    title(sprintf("%s, %f s", opts(i), t))
    axis image
end

% plotTheoreticalvsMeasured(theoreticalGrid, distGrid, rejectOcclusionOutliers(distGrid));




