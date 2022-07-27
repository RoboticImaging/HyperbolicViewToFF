clear;
clc;
close all;

% set up memory
% folder = fullfile("G:\ACFR Winter storage\TOFF\matFiles\boxBlocksWithCoke");
folder = fullfile("G:\ACFR Winter storage\Winter Project\git\ToF\Winter2020\ToFFexperiments\Results\ToFF\matFiles\blockWithGroundTruth");

N = 15;
d = 0.3/(N-1); % distance between array points
[pLF,aLF] = readToFF(folder,N);

tmp = load('cameraParams.mat');
K = tmp.cameraParams.IntrinsicMatrix';

% choose a slope and find corresponding Pz
% slope = -5.2;
% slope = -4.73;
% slope = -4.82;
% Pz = -K(1,1)*d/slope

% or choose pz to give slope:
Pz = 1.45;
slope = -K(1,1)*d/Pz;

newLF = ATshiftLF(pLF, slope);


% l = 114;
% % k = 159;
% k = 162;

k = 145;
l = 106;


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
% regionCut = jj<9;
regionCut = true(N,N);
[fitted_curve, rmse, error] = runCurveFit(distSurf, regionCut,d);
% [fitted_curve, rmse, error] = runCurveFitGivenPz(distSurf, regionCut,d,Pz);


[xx,yy] = meshgrid(linspace(1,N,20),linspace(1,N,20));
hold on
surf(xx,yy,fitted_curve(xx,yy))
alpha(0.6);

% extract an edge and divide into regions
% phaseRegions = bwlabel(~edge(distSurf),4);
phaseRegions = kmeans(distSurf(:),2);
phaseRegions = reshape(phaseRegions,[N,N]);

% figure
% imagesc(phaseRegions)
% 
regionCut = phaseRegions == phaseRegions((N+1)/2,(N+1)/2);

tol = 0.03; % 3cm
% regionCut  = and(min(fitted_curve(xx,yy),[],'all') - tol < distSurf, distSurf < tol + max(fitted_curve(xx,yy),[],'all'));

regionCut = ii < 11;
figure
imagesc(regionCut)

[fitted_curve, rmse, error] = runCurveFit(distSurf, regionCut,d)
% [fitted_curve, rmse, error] = runCurveFitGivenPz(distSurf, regionCut,d,Pz);

figure
[xx,yy] = meshgrid(linspace(1,N,20),linspace(1,N,20));
plot3(ii,jj,distSurf,'rx', 'LineWidth',2)
hold on
surf(xx,yy,fitted_curve(xx,yy))
alpha(0.6);

coeffvals = coeffvalues(fitted_curve);
coeffvals

figure
hold on
imagesc(squeeze(pLF(8,8,:,:))*c/(4*pi*f_m))
axis image
set(gca,'YDir','reverse');
ATplot(k,l,'rx')

