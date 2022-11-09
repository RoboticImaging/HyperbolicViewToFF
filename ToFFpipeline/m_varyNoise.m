% adding synthetic noise on the full 4D field and compare the effect on the
% accuracy for the flat screen

clear
clc
close all


% accDset = fullfile("..\data\results\mat\side_wall_HQ");
accDset = fullfile("..\data\results\mat\side_wall_ACTUAL_HQ_tempsafe\");
[dLF, ampLF, LFargs] = readToFFarray(accDset); 
[HQdistImg, ~] = readHQimg(accDset);

% [imgsToAnalyse, methodNames, LFargs, dLF] = getAllMethodImgs(accDset);

% old paper (i.e. side_wall_HQ, paper_side wall)
% kVals = 95:214;
% lVals = 67:148;

% new paper (tempsafe ones)
kVals = 111:229;
lVals = 69:148;


[Pstack] = getPstack(HQdistImg, LFargs, kVals=kVals, lVals=lVals);
Pstack = Pstack(:,Pstack(3,:) > 0.08);
plane = getPlaneFit(Pstack);

dset.dLF = dLF;
dset.LFargs = LFargs;
dset.HQimg = HQdistImg;

sigmaVals = [0, 0.001, 0.01, 0.05, 0.1];
% sigmaVals = [0, 0.001];

Niter = 5;
rmse = zeros(length(sigmaVals), 4, Niter);

for iterIdx = 1:Niter
    for sigIndx = 1:length(sigmaVals)
        dset.dLF = addNoise(dLF, sigmaVals(sigIndx));

        [imgsToAnalyse, methodNames] = getAllMethodImgs(dset, ToFF_threshold=-0.3);
        for imgIdx = 1:length(imgsToAnalyse)
            rmse(sigIndx, imgIdx, iterIdx) = computeScreenAccuracy(imgsToAnalyse{imgIdx}, ...
                                                                   LFargs, kVals, lVals, plane);

        end
    end 
end

%%
figure
stddevs = std(rmse, 0, 3);
avgError = mean(rmse, 3);
hold on
for i = [1,3,4]
    ATerrorbar(sigmaVals', 100*avgError(:,i), stddevs(:,i))
end
xlabel("$\sigma$ [m]")
ylabel("RMS error [\%]")
legend(["Single","DF","Ours"])
box on
grid on
tmp = ylim;
ylim([tmp(1),10])
set(gca,'YScale','log')

%%
save('varyNoise.mat', 'Niter','sigmaVals', 'rmse')



