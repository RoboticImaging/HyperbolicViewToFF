clear;
clc;
close all;


folder = fullfile("G:\ACFR Winter storage\Winter Project\git\ToF\Winter2020\ToFFexperiments\Results\ToFF\matFiles\blockWithGroundTruth");

N = 15;
d = 0.3/(N-1); % distance between array points
[pLF,aLF] = readToFF(folder,N);

c = 3e8;
f_m = 50e6;
dLF = pLF*c/(4*pi*f_m);


tmp = load('cameraParams.mat');
K = tmp.cameraParams.IntrinsicMatrix';

middleIdx = (N+1)/2;

% problem setup
% create interpolant st it can be passed around
dLF_fn = griddedInterpolant(dLF);

% loop over each pixel in the principal frame
for k = 1:size(dLF,4)
    for l = 1:size(dLF,3)
        % get init Pz guess
        initPz = computePz(K, dLF(middleIdx,middleIdx,l,k), [k,l]);
        
        % run nearby optimization
        [depth, rmse, nPts] = refineDepthSearch(dLF_fn, size(dLF), K, initPz, [k,l]);

        % store metrics
        depthImg(l,k) = depth;
        rmseImg(l,k) = rmse;
        nPtsImg(l,k) = nPts;
    end
end







