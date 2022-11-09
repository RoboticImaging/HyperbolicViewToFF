% generate an intro figure with comparison of DF and ours to single as well
% as a pair of insets that show poor performance with saturation, occlusion
% and noise

clear
clc
close all


% pth = fullfile("..\data\results\mat\many_objects\");
pth = fullfile("..\data\results\mat\fruit\");

[dLF, ampLF, LFargs] = readToFFarray(pth); 

singleImg = squeeze(dLF(LFargs.middleIdx,LFargs.middleIdx,:,:));

pixel = [137;132];
DFImg = DepthFieldImage (dLF,LFargs, pixel);

% ourImg = ToFFImage(dLF, ampLF, LFargs, "occlusionMethod", "threshold");
ourImg = singleImg; % for quick figure testing
%%

imgsToPlot = {singleImg, DFImg, ourImg};
titles = ["Single ToF", "Depth Fields (previous)", "Hyperbolic AiF (ours)"];
clim = [min(ourImg,[],"all"), max(ourImg,[],"all")];
% clim = [prctile(ourImg, 1,'all'), prctile(ourImg, 99,'all')];

boxes(1).kVals = 76:109;
boxes(1).lVals = 136:166;
boxes(1).line = 'r';
cropped = ourImg(boxes(1).lVals,boxes(1).kVals);
boxes(1).clim = [prctile(cropped, 1,'all'),prctile(cropped, 99,'all')];

boxes(2).kVals = 132:154;
boxes(2).lVals = 145:163;
boxes(2).line = 'b';
cropped = ourImg(boxes(2).lVals,boxes(2).kVals);
boxes(2).clim = [prctile(cropped, 1,'all'),prctile(cropped, 99,'all')];

fp = getFontParams();

figure
set(gcf, 'Position',[345.8000   78.6000  488.8000  702.4000])
for imgIdx = 1:length(imgsToPlot)
    subaxis(length(imgsToPlot), 1, imgIdx, 'sv',0.01)
    plotDepthImg(imgsToPlot{imgIdx}, clim, 'useCbar', false)
    
    for boxIdx = 1:length(boxes)
        plotBox(boxes(boxIdx), boxes(boxIdx).line)
    end
    title(titles(imgIdx), fp{:})

    axis on
    set(gca, 'XTick', [], 'yTick', [])
end

%% insets
fig = figure;
set(gcf, 'Position',[345.8000   78.6000  488.8000  702.4000])
j = 1;
for imgIdx = 1:length(imgsToPlot)
    for boxIdx = 1:length(boxes)
        subaxis(length(imgsToPlot)*length(boxes), 1, j, 'sv',0.01)

        cropped = imgsToPlot{imgIdx}(boxes(boxIdx).lVals,boxes(boxIdx).kVals);

        plotDepthImg(cropped ...
            , boxes(boxIdx).clim, 'useCbar', false)
        axis on
        set(gca, 'xtick',[], 'ytick',[])
        set(gca,'xColor', boxes(boxIdx).line, 'yColor', boxes(boxIdx).line)
        j = j + 1;
    end
end

% add colorbars
fp = getFontParams();
ap = getATaxisParams();


for cbarIdx = 1:3
    fig = figure;
    h = axes(fig,'visible','off');
%     c1 = colorbar(h,'Position',[0.8 1.05-0.3*cbarIdx 0.0271 0.18]);  % attach colorbar to h
    c1 = colorbar(h,'southoutside','Position',[0.5 0.4 0.2 0.03]);  % attach colorbar to h
    if cbarIdx > 1
        caxis(h, boxes(cbarIdx-1).clim);  
    else
        caxis(h, clim);  
    end  
    set(c1, ap{:})
    if cbarIdx > 1
        set(c1,'color',boxes(cbarIdx-1).line)
    end
end
ylabel(c1, 'Distance [m]', fp{:}, 'color','k')


return
%% saving

savePath = '../figs/intro_fig/';

figure(1);
save2pdf(gcf, fullfile(savePath, 'main_tiles.pdf'))

figure(2);
save2pdf(gcf, fullfile(savePath, 'insets.pdf'))

figure(3);
save2pdf(gcf, fullfile(savePath, 'main_cbar.pdf'))

for i = 1:length(boxes)
    figure(3+i);
    save2pdf(gcf, fullfile(savePath, sprintf('cbar_%d.pdf', i)))
end
