% test script to see if we are finding the points in other views correctly
clear;
clc;
close all;

folder = fullfile("G:\ACFR Winter storage\Winter Project\git\ToF\Winter2020\ToFFexperiments\Results\ToFF\matFiles\blockWithGroundTruth");

N = 15;
d = 0.3/(N-1); % distance between array points
[pLF,~] = readToFF(folder,N);


k = 162;
l = 114;


c = 3e8;
f_m = 50e6;
dLF = pLF*c/(4*pi*f_m);


tmp = load('cameraParams.mat');
K = tmp.cameraParams.IntrinsicMatrix';

Pz = 0.94;
P = Pz*(inv(K)*[k;l;1]) + ((N+1)/2)*d*[1;1;0];

gridSize = 3;

stSubset = round(linspace(1,15,3));
for iIdx = 1:length(stSubset)
    i = stSubset(iIdx);
    for jIdx = 1:length(stSubset)
        j = stSubset(jIdx);
        sub2ind([gridSize,gridSize], iIdx,jIdx)
        subaxis(gridSize,gridSize, sub2ind([gridSize,gridSize], iIdx,jIdx));
        klVec = (K*[eye(3),[-i*d; -j*d; 0]]*[P;1]);
        klVec = klVec/klVec(3);

        hold on
        imagesc(squeeze(dLF(j,i,:,:)))
        axis image
        set(gca,'YDir','reverse');
        ATplot(klVec(1),klVec(2),'rx')

    end
end




