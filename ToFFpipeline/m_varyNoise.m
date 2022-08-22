% adding synthetic noise on the full 4D field and compare the effect on the
% accuracy for the flat screen

clear
clc
close all


accDset = fullfile("..\data\results\mat\side_wall_HQ");
[dLF, ampLF, LFargs] = readToFFarray(accDset); 
[HQdistImg, ~] = readHQimg(accDset);

% [imgsToAnalyse, methodNames, LFargs, dLF] = getAllMethodImgs(accDset);

kVals = 95:214;
lVals = 67:148;
truePz = 1.0494; % m

% Pzavg = getPzimg(imgsToAnalyse{2}, LFargs);
% PzavgCrop = Pzavg(lVals,kVals);
% truePz = mean(PzavgCrop(PzavgCrop > 0.7),'all');

dset.dLF = dLF;
dset.LFargs = LFargs;
dset.HQimg = HQdistImg;

sigmaVals = [0, 0.001, 0.01];

Niter = 2;
rmse = zeros(length(sigmaVals), 4, Niter);

for iterIdx = 1:Niter
    for sigIndx = 1:length(sigmaVals)
        dset.dLF = addNoise(dLF, sigmaVals(sigIndx));

        [imgsToAnalyse, methodNames] = getAllMethodImgs(dset);
        for imgIdx = 1:length(imgsToAnalyse)
            rmse(sigIndx, imgIdx, iterIdx) = computeScreenAccuracy(imgsToAnalyse{imgIdx}, LFargs, kVals, lVals, truePz);

        end
    end 
end








