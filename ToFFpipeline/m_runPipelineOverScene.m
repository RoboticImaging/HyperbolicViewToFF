clear;
clc;
close all;


% folder = fullfile("G:\ACFR Winter storage\Winter Project\git\ToF\Winter2020\ToFFexperiments\Results\ToFF\matFiles\blockWithGroundTruth");
% folder = fullfile("G:\ACFR Winter storage\Winter Project\git\ToF\Winter2020\ToFFexperiments\Results\ToFF\matFiles\blocksWithSat");
% folder = fullfile("G:\ACFR Winter storage\Winter Project\git\ToF\Winter2020\ToFFexperiments\Results\ToFF\matFiles\shinyGoldHead");
% folder = fullfile("G:\ACFR Winter storage\Winter Project\git\ToF\Winter2020\ToFFexperiments\Results\ToFF\matFiles\dullHead");
% folder = fullfile("G:\ACFR Winter storage\Winter Project\git\ToF\Winter2020\ToFFexperiments\Results\ToFF\matFiles\tools");
folder = fullfile("C:\Users\Adam\Documents\University of Sydney\UNI\ACFR\ToFF_2022\ToFF\data\results\mat\many_objects");


tmp = load('../DataCollection/cameraParams_july_2022.mat');
K = tmp.cameraParams_july_2022.IntrinsicMatrix';

ToFFarr.N = 15;
ToFFarr.d = 0.3; % distance between array edges
[pLF,aLF] = readToFF(folder,ToFFarr.N, tmp.cameraParams_july_2022);

c = 3e8;
f_m = 50e6;
dLF = pLF*c/(4*pi*f_m);



middleIdx = (ToFFarr.N+1)/2;

% problem setup
% create interpolant st it can be passed around
dLF_fn = griddedInterpolant(dLF);

depthImg = zeros(size(dLF,3),size(dLF,4));

nIter = size(dLF,4)*size(dLF,3);
iterCount = 0;
wbar = waitbar(iterCount/nIter, 'iterating (k,l)...');


nPlanes = 80; %for plane sweep
rmseTrace = zeros(size(dLF,3),size(dLF,4), nPlanes);

% loop over each pixel in the principal frame
for k = 1:size(dLF,4)
% for k = 100:size(dLF,4)
    for l = 1:size(dLF,3)
        waitbar(iterCount/nIter, wbar)
%     for l = 100:size(dLF,3)
        % get init Pz guess
        if k == 160 && l == 117
            dLF(8,8,k,l)
            dLF(8,8,l,k)
        end
        initPz = computePz(K, dLF(middleIdx,middleIdx,l,k), [k,l]);
        
        % run nearby optimization
        [depth, rmse, nPts, debug] = refineDepthSearch(dLF_fn, size(dLF), K, initPz, [k,l],ToFFarr);
%         [depth, rmse, nPts, debug] = runPlaneSweep(dLF_fn, size(dLF), K, initPz, [k,l],ToFFarr, nPlanes);

        % store metrics
        depthImg(l,k) = depth;
        rmseImg(l,k) = rmse;
        nPtsImg(l,k) = nPts;

        Px(l,k) = debug.P(1);
        Py(l,k) = debug.P(2);
        Pz(l,k) = debug.P(3);

%         rmseTrace(l,k,:) = debug.rmseVals;

        iterCount = iterCount + 1;
    end
end


figure
imagesc(depthImg)

figure
imagesc(rmseImg,[0,0.5])
colorbar

figure
imagesc(nPtsImg,[0,ToFFarr.N^2])
colorbar


figure
subplot(1,3,1)
imagesc(Px)
axis image
subplot(1,3,2)
imagesc(Py)
axis image
subplot(1,3,3)
imagesc(Pz)
axis image


%% plot compare
boxX = [130,190];
boxY = [80,170];
clim = [0.7,1];

figure
subplot(1,2,1)
imagesc(squeeze(dLF(middleIdx,middleIdx,boxY(1):boxY(2),boxX(1):boxX(2))),clim)
title('Middle image')
axis image
subplot(1,2,2)
imagesc(depthImg(boxY(1):boxY(2),boxX(1):boxX(2)),clim)
title('Ours')
axis image

