% m_EPIwithTraces 
% generate epi images with traces

clear
clc
close all

pth = fullfile("..\data\results\mat\many_objects\");

[dLF, ampLF, LFargs] = readToFFarray(pth); 


% select point that is in middle of scene
pixel = [65; 146];

% calculate Pz
r = dLF(LFargs.middleIdx, LFargs.middleIdx, pixel(2), pixel(1));
P = radialDist2point(r, LFargs, pixel);

% calculate slope
slope = -LFargs.K(1,1)*LFargs.baseline/(P(3)*(LFargs.N));

% get the shifted LF
[~,~,dLFshifted] = LFFiltShiftSum(dLF, slope);
dLFshifted = squeeze(dLFshifted(:,:,:,:,1));

% dLF has indicies (j,i,l,k)

clim = [min(dLF,[],'all'), max(dLF,[],'all')];

% single img
figure
imagesc(squeeze(dLF(LFargs.middleIdx,LFargs.middleIdx,:,:)), clim)
hold on
plot(pixel(1), pixel(2),'rx', LineWidth=1.2, MarkerSize=10)
axis image
xlabel("k")
ylabel("l")

% l, j fixed
horizEPI = squeeze(dLFshifted(LFargs.middleIdx,:,pixel(2),:));
figure
imagesc(horizEPI, clim)
hold on
plot(pixel(1)*[1,1], ylim,'r');
xlabel("k")
ylabel("i")

% k, i fixed
vertEPI = squeeze(dLFshifted(:,LFargs.middleIdx,:,pixel(1)))';
figure
imagesc(vertEPI, clim)
hold on
plot(xlim, pixel(2)*[1,1],'r');
xlabel("j")
ylabel("l")

%% traces
figure
horizEPITrace = horizEPI(:, pixel(1));
plot(horizEPITrace, 'bx')

figure
vertEPITrace = vertEPI(pixel(2),:);
plot(vertEPITrace, 'bx')

