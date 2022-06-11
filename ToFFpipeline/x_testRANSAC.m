clear;
clc;
close all;

% set up memory
% folder = fullfile("G:\ACFR Winter storage\TOFF\matFiles\boxBlocksWithCoke");
folder = fullfile("G:\ACFR Winter storage\Winter Project\git\ToF\Winter2020\ToFFexperiments\Results\ToFF\matFiles\blockWithGroundTruth");

N = 15;
d = 0.3/(N-1); % distance between array points
[pLF,aLF] = readToFF(folder,N);

slope = -4.73;
newLF = ATshiftLF(pLF, slope);


l = 114;
% k = 159;
k = 162;


t = 8;
figure
subaxis(2,1,1)
imagesc(squeeze(pLF(t,:,l,:)));
title('original epi')

subaxis(2,1,2)
imagesc(squeeze(newLF(t,:,l,:)));
title('shifted epi')


phaseSurface = squeeze(newLF(:,:,l,k));

c = 3e8;
f_m = 50e6;
distSurf = phaseSurface*c/(4*pi*f_m);


figure
% surf(newLF(:,:,l,k));
[ii,jj] = meshgrid(1:N);
plot3(ii,jj,distSurf,'rx', 'LineWidth',2)
xlabel('i')
ylabel('j')

% need to juggle wanting to use as much data as possible vs lowering error
regionCut = jj<10;
[fitted_curve, rmse] = runCurveFit(distSurf, regionCut,d)



[xx,yy] = meshgrid(linspace(1,N,20),linspace(1,N,20));
hold on
surf(xx,yy,fitted_curve(xx,yy))
alpha(0.6);

figure
hold on
surf(xx,yy,fitted_curve(xx,yy))
alpha(0.6);
% plot3(ii(subset),jj(subset),distSurf(subset),'rx', 'LineWidth',2)
xlabel('i')
ylabel('j')

