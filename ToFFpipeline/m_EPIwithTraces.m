% m_EPIwithTraces 
% generate epi images with traces

clear
clc
close all

pth = fullfile("..\data\results\mat\many_objects\");

[dLF, ampLF, LFargs] = readToFFarray(pth); 

hcolor = 'm';
vcolor = 'g';

% select point
% pixel = [65; 146];
% pixel = [74; 100];
pixel = [108; 146];

% calculate Pz
r = dLF(LFargs.middleIdx, LFargs.middleIdx, pixel(2), pixel(1));
P = radialDist2point(r, LFargs, pixel);

% calculate slope
slope = -LFargs.K(1,1)*LFargs.baseline/(P(3)*(LFargs.N));

% get the shifted LF
[~,~,dLFshifted] = LFFiltShiftSum(dLF, slope);
dLFshifted = squeeze(dLFshifted(:,:,:,:,1));

% dLF has indicies (j,i,l,k)

% clim = [min(dLF,[],'all'), max(dLF,[],'all')];
clim = [prctile(dLF, 1,'all'), prctile(dLF, 99,'all')];

fp = getFontParams();

% single img
figure(1)
plotDepthImg(dLF(LFargs.middleIdx,LFargs.middleIdx,:,:), clim)
hold on
% plot(pixel(1), pixel(2),'rx', LineWidth=1.2, MarkerSize=10)
plot(pixel(1)*[1,1], ylim, vcolor, LineWidth=1.2, MarkerSize=10)
plot(xlim, pixel(2)*[1,1], hcolor, LineWidth=1.2, MarkerSize=10)
axis on
xlabel("k", fp{:})
ylabel("l", fp{:})
figHeight = 420;
figWidth = 700;
mainFigPos = [300   300   figWidth figHeight]; 
set(gcf,'Position', mainFigPos)

% l, j fixed
horizEPI = squeeze(dLFshifted(LFargs.middleIdx,:,pixel(2),:));
figure(2)
plotDepthImg(horizEPI, clim, 'useCbar', false, 'useAxisImage', false)
hold on
axis on
plot(pixel(1)*[1,1], ylim,hcolor, LineWidth=2);
xlabel("k", fp{:})
ylabel("i", fp{:})

set(gcf,'Position', [300   300  figWidth 0.4*figHeight])

% k, i fixed
vertEPI = squeeze(dLFshifted(:,LFargs.middleIdx,:,pixel(1)))';
figure(3)
plotDepthImg(vertEPI, clim, 'useCbar', false, 'useAxisImage', false)
hold on
axis on
plot(xlim, pixel(2)*[1,1],vcolor, LineWidth=2);
xlabel("j", fp{:})
ylabel("l", fp{:})
set(gcf,'Position', [300   300  0.3*figWidth figHeight])


%% traces

[finalDist, singleDebug] = combineSinglePixelField (dLF, LFargs, pixel);

figure(4)
horizEPITrace = horizEPI(:, pixel(1));
plot(horizEPITrace, strcat(hcolor,'x'), LineWidth=1.5)
hold on
P = singleDebug.P;
sep = LFargs.seperation;
fn = @(i,j) sqrt(P(3)^2 + (P(1) - (i-1)*sep).^2 + ...
                     (P(2) - (j-1)*sep).^2);
iVals = 1:LFargs.N;
plot(iVals, fn(iVals, LFargs.middleIdx),'b', 'LineWidth',2)

xlabel("i", fp{:})
ylabel("Distance [m]", fp{:})
ap = getATaxisParams();
set(gca, ap{:})
set(gcf, 'Position', [488.0000  587.8000  227.8000  174.2000]);


txtOpts = ["horizontalAlignment","right", "units","normalized"];

text(0.7,0.9,'Trace Data',txtOpts{:},fp{:},'color',hcolor)

figure(5)
vertEPITrace = vertEPI(pixel(2),:);
plot(vertEPITrace, strcat(vcolor,'x'), LineWidth=1.5)
hold on
xlabel("j", fp{:})
ylabel("Distance [m]", fp{:})
ap = getATaxisParams();
set(gca, ap{:})
set(gcf, 'Position', [488.0000  587.8000  227.8000  174.2000]);
jVals = 1:LFargs.N;
plot(jVals, fn(LFargs.middleIdx, iVals),'b', 'LineWidth',2)


text(0.95,0.9,'Trace Data',txtOpts{:},fp{:},'color',vcolor)
text(0.95,0.75,'Fit',txtOpts{:},fp{:},'color','b')


%% save the figures

savePath = '../figs/EPI/';

figure(1)
save2pdf(gcf, fullfile(savePath, 'centreView.pdf'))

figure(2)
save2pdf(gcf, fullfile(savePath, 'horizEPI.pdf'))

figure(3)
save2pdf(gcf, fullfile(savePath, 'vertEPI.pdf'))

figure(4)
save2pdf(gcf, fullfile(savePath, 'horizEPITrace.pdf'))

figure(5)
save2pdf(gcf, fullfile(savePath, 'vertEPITrace.pdf'))
