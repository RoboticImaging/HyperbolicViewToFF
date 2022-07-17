% test script to see if we are finding the points in other views correctly
clear;
clc;
close all;

% folder = fullfile("G:\ACFR Winter storage\Winter Project\git\ToF\Winter2020\ToFFexperiments\Results\ToFF\matFiles\blockWithGroundTruth");
% N = 15;

folder = fullfile("C:\Users\Adam\Documents\University of Sydney\UNI\ACFR\ToFF_2022\ToFF\data\results\mat\small_N");
N = 5;

middleIdx = (N+1)/2;

d = 0.3/(N-1); % distance between array points
% d = 0.3/(N); % distance between array points
[pLF,~] = readToFF(folder,N);


l = 150;
k = 112;


c = 3e8;
f_m = 50e6;
dLF = pLF*c/(4*pi*f_m);


tmp = load('../DataCollection/cameraParams_july_2022.mat');
K = tmp.cameraParams_july_2022.IntrinsicMatrix';

% Pz = 0.94;
Pz = computePz(K, dLF(middleIdx,middleIdx,l,k), [k,l]);
P = Pz*(inv(K)*[k;l;1]) + ((N+1)/2)*d*[1;1;0];
% P = Pz*(inv(K)*[k;l;1]);

gridSize = 5;

clim = [0.9,1.5];

stSubset = round(linspace(1,N,gridSize));
for iIdx = 1:length(stSubset)
    i = stSubset(iIdx);
    for jIdx = 1:length(stSubset)
        j = stSubset(jIdx);
        sub2ind([gridSize,gridSize], iIdx,jIdx)
        subaxis(gridSize,gridSize, sub2ind([gridSize,gridSize], iIdx,jIdx));
        klVec = (K*[eye(3),[-i*d; -j*d; 0]]*[P;1]);
        klVec = klVec/klVec(3);

        kk(i,j) = klVec(1);
        ll(i,j) = klVec(2);

        hold on
        imagesc(squeeze(dLF(j,i,:,:)), clim)
        axis image
        set(gca,'YDir','reverse');
        ATplot(klVec(1),klVec(2),'rx')

    end
end

kk(:)


