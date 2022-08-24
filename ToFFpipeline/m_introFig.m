% generate an intro figure with comparison of DF and ours to single as well
% as a pair of insets that show poor performance with saturation, occlusion
% and noise

clear
clc
close all


pth = fullfile("..\data\results\mat\fruit\");

[dLF, ampLF, LFargs] = readToFFarray(pth); 

singleImg = squeeze(dLF(LFargs.middleIdx,LFargs.middleIdx,:,:));

pixel = [100;200];
DFImg = DepthFieldImage (dLF,LFargs, pixel);

ourImg = ToFFImage(dLF, ampLF, LFargs, "occlusionMethod", "threshold");

%%

imgsToPlot = {singleImg, DFImg, ourImg};
titles = ["Single ToF", "Depth Fields (previous)", "ToFF (Ours)"];
% clim = [min(ourImg,[],"all"), max(ourImg,[],"all")];
clim = [prctile(ourImg, 1,'all'), prctile(ourImg, 99,'all')];

boxes(1).kVals = 140:200;
boxes(1).lVals = 50:70;
boxes(1).line = 'r';
boxes(1).clim = [];

boxes(2).kVals = 100:110;
boxes(2).lVals = 30:50;
boxes(2).line = 'b';
boxes(2).clim = [];

fp = getFontParams();

figure
for imgIdx = 1:length(imgsToPlot)
    subaxis(length(imgsToPlot), 1, imgIdx, 'sv',0.01)
    plotDepthImg(imgsToPlot{imgIdx}, clim, 'useCbar', false)
    
    for boxIdx = 1:length(boxes)
        plotBox(boxes(boxIdx), boxes(boxIdx).line)
    end
    title(titles(imgIdx), fp{:})
end

%% insets
figure
j = 1;
for imgIdx = 1:length(imgsToPlot)
    for boxIdx = 1:length(boxes)
        subaxis(length(imgsToPlot)*length(boxes), 1, j, 'sv',0.01)

        plotDepthImg(imgsToPlot{imgIdx}(boxes(boxIdx).lVals,boxes(boxIdx).kVals) ...
            , clim, 'useCbar', false)
        axis on
        set(gca, 'xtick',[], 'ytick',[])
        set(gca,'xColor', boxes(boxIdx).line, 'yColor', boxes(boxIdx).line)
        j = j + 1;
    end
end





