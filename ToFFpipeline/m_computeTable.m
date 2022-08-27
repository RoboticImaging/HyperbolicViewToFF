% produce accuracy and completness measures from resulting images

clear
clc
close all

% accDset = fullfile("..\data\results\mat\side_wall_HQ");
% accDset = fullfile("..\data\results\mat\paper_side_wall_2\");
% accDset = fullfile("..\data\results\mat\paper_side_wall_2_low_light\");
accDset = fullfile("..\data\results\mat\side_wall_low_light_tempsafe\");
% truePz = 1.0494; % m
completnessDset = fullfile("..\data\results\mat\fruit\");

%% accuracy analysis
[imgsToAnalyse, methodNames, LFargs, ~, imEnum] = getAllMethodImgs(accDset);

% kVals = 95:214;
% lVals = 67:148;

% new paper (tempsafe ones)
kVals = 111:229;
lVals = 69:148;

%%
[Pstack] = getPstack(imgsToAnalyse{imEnum.HQ}, LFargs, kVals=kVals, lVals=lVals);
Pstack = Pstack(:,Pstack(3,:) > 0.08);
plane = getPlaneFit(Pstack);

fprintf("\n\t \t \t")
fprintf("& \t %s ",methodNames);
fprintf("\\\\\n");
fprintf("Accuracy [mm] ");
for imgIdx = 1:length(imgsToAnalyse)
    rmse = computeScreenAccuracy(imgsToAnalyse{imgIdx}, LFargs, kVals, lVals, plane);
    fprintf("\t & %.2f", rmse*1e3); % note this is in mm
end
fprintf("\\\\\n");



%%
clim = 0.03*[-1,1];
figure
for imgIdx = 1:length(imgsToAnalyse)
    subaxis(2,2, imgIdx, 'sh',0.01, 'sv',0.01, 'marginright',0.15)

    [Pstack] = getPstack(imgsToAnalyse{imgIdx}, LFargs, kVals=kVals, lVals=lVals);
    errors = plane.n'*(Pstack(:,:)- plane.centroid);
    
    errors = reshape(errors, [length(kVals), length(lVals)])';


    imagesc(errors, clim);
    axis image
    axis off

    if imgIdx > 2
        text(0.5, -0.1, methodNames(imgIdx), 'Units', 'normalized', HorizontalAlignment='center', ...
            FontSize=14);
    else
        text(0.5, 1.1, methodNames(imgIdx), 'Units', 'normalized', HorizontalAlignment='center', ...
            FontSize=14);
    end
end
set(gcf,'Position',[488.0000  403.8000  561.8000  358.2000]);

fp = getFontParams();
ap = getATaxisParams();

h = axes(gcf,'visible','off');

c1 = colorbar(h,'Position',[0.88 0.2 0.03 0.6]);  % attach colorbar to h

caxis(h, clim*100);  
ylabel(c1, 'Distance Error [cm]', fp{:}, 'color','k')
  
set(c1, ap{:})



savePath = '../figs/flatScreen/';
save2pdf(gcf, fullfile(savePath, 'flatScreenCompare.pdf'))

return

%% completness

[imgsToAnalyse, methodNames, LFargs] = getAllMethodImgs(completnessDset);

fprintf("Invalid Pts ");
for imgIdx = 1:length(imgsToAnalyse)
    fracComplete = computeCompletness(imgsToAnalyse{imgIdx});
    fprintf("\t & %d", fracComplete); 
end
fprintf("\\\\\n");


