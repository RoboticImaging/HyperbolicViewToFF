% produce accuracy and completness measures from resulting images

clear
clc
close all

% accDset = fullfile("..\data\results\mat\side_wall_HQ");
% accDset = fullfile("..\data\results\mat\paper_side_wall_2\");
accDset = fullfile("..\data\results\mat\paper_side_wall_2_low_light\");
% truePz = 1.0494; % m
completnessDset = fullfile("..\data\results\mat\fruit\");

%% accuracy analysis
[imgsToAnalyse, methodNames, LFargs] = getAllMethodImgs(accDset);

kVals = 95:214;
lVals = 67:148;


Pzavg = getPzimg(imgsToAnalyse{2}, LFargs);
PzavgCrop = Pzavg(lVals,kVals);
truePz = mean(PzavgCrop(PzavgCrop > 0.7),'all');

fprintf("\t \t \t")
fprintf("& \t %s ",methodNames);
fprintf("\\\\\n");
fprintf("Accuracy [mm] ");
for imgIdx = 1:length(imgsToAnalyse)
    rmse = computeScreenAccuracy(imgsToAnalyse{imgIdx}, LFargs, kVals, lVals, truePz);
    fprintf("\t & %.2f", rmse*1e3); % note this is in mm
end
fprintf("\\\\\n");


%% completness

[imgsToAnalyse, methodNames, LFargs] = getAllMethodImgs(completnessDset);

fprintf("Completness [%%] ");
for imgIdx = 1:length(imgsToAnalyse)
    fracComplete = computeCompletness(imgsToAnalyse{imgIdx});
    fprintf("\t & %.2f", fracComplete*1e2); % note this is in %
end
fprintf("\\\\\n");


