clear;
clc;
close all;

% set up memory
% folder = fullfile("G:\ACFR Winter storage\TOFF\matFiles\boxBlocksWithCoke");
% folder = fullfile("G:\ACFR Winter storage\Winter Project\git\ToF\Winter2020\ToFFexperiments\Results\ToFF\matFiles\blockWithGroundTruth");
% folder = fullfile("C:\Users\Adam\Documents\University of Sydney\UNI\ACFR\ToFF_2022\ToFF\data\results\mat\many_objects");
folder = fullfile("C:\Users\Adam\Documents\University of Sydney\UNI\ACFR\ToFF_2022\ToFF\data\results\mat\small_N");

N = 5;
original_d = 0.3;
d = original_d/(N-1); % distance between array points
% d = 0.3/(N); % distance between array points
[pLF,aLF] = readToFF(folder,N);
c = 3e8;
f_m = 50e6;
dLF = pLF*c/(4*pi*f_m);

middleIdx = (N+1)/2;

tmp = load('../DataCollection/cameraParams_july_2022.mat');
K = tmp.cameraParams_july_2022.IntrinsicMatrix';

% l = 114;
% % k = 159;
% k = 162;


l = 150;
k = 112;

% choose a slope and find corresponding Pz
% slope = -5.2;
% slope = -4.73;
% slope = -4.82;
% Pz = -K(1,1)*d/slope

% or choose pz to give slope:
Pz = computePz(K, dLF(middleIdx,middleIdx,l,k), [k,l]);
slope = -K(1,1)*d/Pz;



newLF = ATshiftLF(pLF, slope);
newAmpLF = ATshiftLF(aLF, slope);

% t = 8;
t = 3;
figure
subaxis(2,1,1)
imagesc(squeeze(pLF(t,:,l,:)));
title('original epi')

subaxis(2,1,2)
imagesc(squeeze(newLF(t,:,l,:)));
title('shifted epi')


phaseSurface = squeeze(newLF(:,:,l,k));
ampSurface = squeeze(newAmpLF(:,:,l,k));

distSurf = phaseSurface*c/(4*pi*f_m);


figure
% surf(newLF(:,:,l,k));
[ii,jj] = meshgrid(1:N);
plot3(ii,jj,distSurf,'rx', 'LineWidth',2)
xlabel('i')
ylabel('j')


P = Pz*(K\[k;l;1]) + ((N+1)/2)*d*[1;1;0];
fitted_curve = @(s,t) sqrt(P(3).^2 + (t*d-P(1)).^2 + (s*d-P(2)).^2);

[xx,yy] = meshgrid(linspace(1,N,20),linspace(1,N,20));
hold on
surf(xx,yy,fitted_curve(xx,yy))
alpha(0.6);



figure
imagesc(squeeze(pLF(middleIdx,middleIdx,:,:))*c/(4*pi*f_m), [0.9,1.5])
hold on
plot(k,l,'rx')


%% now try with current pipeline method (i.e. no LFShiftSum)
initPz = computePz(K, dLF(middleIdx,middleIdx,l,k), [k,l]);

dLF_fn = griddedInterpolant(dLF);
ToFFarr.N = N;
ToFFarr.d = original_d;
grid = getInterpGrid(K, ToFFarr, size(dLF), initPz, [k,l]);
depthSamples = dLF_fn(grid{2},grid{1},grid{4},grid{3});
depthSamples = reshape(depthSamples,[ToFFarr.N, ToFFarr.N]);

figure
[ii,jj] = meshgrid(1:N);
plot3(ii,jj,depthSamples,'rx', 'LineWidth',2)
[xx,yy] = meshgrid(linspace(1,N,20),linspace(1,N,20));
hold on
surf(xx,yy,fitted_curve(xx,yy))
alpha(0.6);

return

% extract an edge and divide into regions
% phaseRegions = bwlabel(~edge(distSurf),4);
phaseRegions = kmeans(distSurf(:),2);
phaseRegions = reshape(phaseRegions,[N,N]);
figure
imagesc(phaseRegions)

regionCut = phaseRegions == phaseRegions(middleIdx,middleIdx);
figure
imagesc(regionCut)

% [fitted_curve, rmse, error] = runCurveFit(distSurf, regionCut,d)
[fitted_curve, rmse, error] = runCurveFitGivenPz(distSurf, regionCut,d,Pz);

figure
[xx,yy] = meshgrid(linspace(1,N,20),linspace(1,N,20));
plot3(ii,jj,distSurf,'rx', 'LineWidth',2)
hold on
surf(xx,yy,fitted_curve(xx,yy))
alpha(0.6);

coeffvals = coeffvalues(fitted_curve);
coeffvals




