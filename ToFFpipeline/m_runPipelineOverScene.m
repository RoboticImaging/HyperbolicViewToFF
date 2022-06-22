clear;
clc;
close all;


folder = fullfile("G:\ACFR Winter storage\Winter Project\git\ToF\Winter2020\ToFFexperiments\Results\ToFF\matFiles\blockWithGroundTruth");

ToFFarr.N = 15;
ToFFarr.d = 0.3; % distance between array edges
[pLF,aLF] = readToFF(folder,ToFFarr.N);

c = 3e8;
f_m = 50e6;
dLF = pLF*c/(4*pi*f_m);


tmp = load('cameraParams.mat');
K = tmp.cameraParams.IntrinsicMatrix';

middleIdx = (ToFFarr.N+1)/2;

% problem setup
% create interpolant st it can be passed around
dLF_fn = griddedInterpolant(dLF);

depthImg = zeros(size(dLF,3),size(dLF,4));


% loop over each pixel in the principal frame
for k = 1:size(dLF,4)
% for k = 100:size(dLF,4)
    for l = 1:size(dLF,3)
%     for l = 100:size(dLF,3)
        % get init Pz guess
        if k == 160 && l == 117
            dLF(8,8,k,l)
            dLF(8,8,l,k)
        end
        initPz = computePz(K, dLF(middleIdx,middleIdx,l,k), [k,l]);
        
        % run nearby optimization
        [depth, rmse, nPts, debug] = refineDepthSearch(dLF_fn, size(dLF), K, initPz, [k,l],ToFFarr);

        % store metrics
        depthImg(l,k) = depth;
        rmseImg(l,k) = rmse;
        nPtsImg(l,k) = nPts;

        Px(l,k) = debug.P(1);
        Py(l,k) = debug.P(2);
        Pz(l,k) = debug.P(3);
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


