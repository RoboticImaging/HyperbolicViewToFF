clear
clc
close all






pth = fullfile("..\data\results\mat\fruit\");

[dLF, ampLF, LFargs] = readToFFarray(pth); 
dLFinterp = griddedInterpolant(dLF, 'linear', 'none');

singleImg = squeeze(dLF(LFargs.middleIdx,LFargs.middleIdx,:,:));



figure
imagesc(singleImg)


pixel = [170,159];
pixel = [141,43];

Pz_bnd = [1.5,1.7];
nImgs = 100;

Pzvals = linspace(Pz_bnd(1), Pz_bnd(2),nImgs);

% calculate extrema
Pz = Pzvals(1);
[~, ~, theoreticalGrid, ~] = computeSinglePixelFieldSingleDepth (dLFinterp, LFargs, pixel, Pz);
zmin = min(theoreticalGrid, [], 'all');
Pz = Pzvals(end);
[~, ~, theoreticalGrid, ~] = computeSinglePixelFieldSingleDepth (dLFinterp, LFargs, pixel, Pz);
zmax = max(theoreticalGrid, [], 'all');


im_to_gif = {};

for i = 1:nImgs
    clf
    Pz = Pzvals(i);
    [error, dataGrid, theoreticalGrid, indexSubset] = computeSinglePixelFieldSingleDepth (dLFinterp, LFargs, pixel, Pz);
    
    
    plotTheoreticalvsMeasured(theoreticalGrid, dataGrid, indexSubset)
    title(sprintf("$P_z$ = %.2f, Fit RMSE = %.2f" , Pz, error), 'Interpreter','latex')
    zlim([zmin,zmax])

    set(gcf,'color','w')

    [frame, alpha] = export_fig;
    im_to_gif{i} = frame;
end


filename = "testAnimated.gif"; % Specify the output file name
for idx = 2:length(im_to_gif)
    [A,map] = rgb2ind(im_to_gif{idx},256);
    if idx == 2
        imwrite(A,map,filename,"gif","LoopCount",0,"DelayTime",0.1);
    elseif idx == length(im_to_gif)
        imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",30);
    else
        imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",0.1);
    end
end
% [finalDist, singleDebug] = combineSinglePixelField (dLF, LFargs, pixel, 'occlusionMethod','none');


