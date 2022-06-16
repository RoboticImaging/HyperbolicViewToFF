clear;
clc;
close all;

folder = fullfile("G:\ACFR Winter storage\Winter Project\git\ToF\Winter2020\ToFFexperiments\Results\ToFF\matFiles\blockWithGroundTruth");

N = 15;
d = 0.3/(N-1); % distance between array points
[pLF,aLF] = readToFF(folder,N);

tmp = load('cameraParams.mat');
K = tmp.cameraParams.IntrinsicMatrix';

Pz = 1.4502;
slope = -K(1,1)*d/Pz;

newLF = ATshiftLF(pLF, slope);
newAmpLF = ATshiftLF(aLF, slope);


l = 114;
k = 145;


figure
imagesc(squeeze(pLF(8,8,:,:)))
hold on
plot(k,l,'rx')

t = 8;
figure
subaxis(2,1,1)
imagesc(squeeze(pLF(t,:,l,:)));
title('original epi')

subaxis(2,1,2)
imagesc(squeeze(newLF(t,:,l,:)));
title('shifted epi')


phaseSurface = squeeze(newLF(:,:,l,k));
ampSurface = squeeze(newAmpLF(:,:,l,k));

c = 3e8;
f_m = 50e6;
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


%% grabcuts

distSurfNorm = mat2gray(distSurf);

L = superpixels(distSurfNorm,2);

figure
imagesc(L)
% bw = grabcut(distSurf, L, true(size(distSurf)));
bw = grabcut(distSurfNorm, L, true(size(distSurf)));

figure
imagesc(bw)


imgStack = cat(3, mat2gray(ampSurface), mat2gray(distSurf), zeros(size(distSurf)));
L = superpixels(imgStack,2);

figure
imagesc(L)

% bw = grabcut(distSurf, L, true(size(distSurf)));
bw = grabcut(imgStack, L, true(size(distSurf)));

figure
imagesc(bw)

