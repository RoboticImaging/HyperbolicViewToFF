clear;
clc;
close all;

% set up memory
% folder = fullfile("G:\ACFR Winter storage\TOFF\matFiles\boxBlocksWithCoke");
folder = fullfile("G:\ACFR Winter storage\Winter Project\git\ToF\Winter2020\ToFFexperiments\Results\ToFF\matFiles\blockWithGroundTruth");

N = 15;
d = 0.3/(N-1); % distance between array points
[pLF,aLF] = readToFF(folder,N);



l = 114;
% k = 159;
k = 162;

% l = 85;
% k = 155;


c = 3e8;
f_m = 50e6;

tmp = load('cameraParams.mat');
K = tmp.cameraParams.IntrinsicMatrix';

PzVals = linspace(0.8,1.2,20);
% PzVals = linspace(1,1.8,35);

% [ii,jj] = meshgrid(1:N);
fitters = {@(distSurf,regionCut,pz) runCurveFit(distSurf, regionCut,d),...
              @(distSurf,regionCut,pz) runCurveFitGivenPz(distSurf, regionCut,d,pz),...
              @(distSurf,regionCut,pz) runCurveFit(distSurf, true(N,N),d),...
              @(distSurf,regionCut,pz) runCurveFitGivenPz(distSurf, true(N,N),d,pz)};

fitLeg  =["Curve fit (regionCut)", "Curve fit with Pz Fixed (regionCut)", ...
    "Curve fit (full)", "Curve fit with Pz Fixed (full)"];

errors = zeros(length(fitters),length(PzVals));
regionSize = zeros(length(fitters),length(PzVals));


waitTotal = length(fitters)*length(PzVals);
waitCount = 0;

for fitIdx = 1:length(fitters)
    for depthIdx = 1:length(PzVals)
        waitbar(waitCount/waitTotal)
    
        slope = -K(1,1)*d/PzVals(depthIdx);
        newLF = ATshiftLF(pLF, slope);
        phaseSurface = squeeze(newLF(:,:,l,k));
        distSurf = phaseSurface*c/(4*pi*f_m);

        phaseRegions = bwlabel(~edge(distSurf),4);
        regionCut = phaseRegions == phaseRegions((N+1)/2,(N+1)/2);
    
        [fitted_curve, rmse, error] = fitters{fitIdx}(distSurf, regionCut,PzVals(depthIdx));
    
        regionSize(fitIdx,depthIdx) = sum(regionCut,'all');
    
        errors(fitIdx,depthIdx) = rmse;

        waitCount = waitCount + 1;
    end
end

figure
subaxis(2,1,1)
ATplot(PzVals, errors')
set(gca,'YScale','log')
ylabel('RMSE [m]')
subaxis(2,1,2)
ATplot(PzVals, regionSize')
ylabel('Number of points used')
xlabel('P_z [m]')
legend(fitLeg)





figure
imagesc(squeeze(pLF((N+1)/2,(N+1)/2,:,:))*c/(4*pi*f_m))
colorbar
hold on
ATplot(k,l,'rx')

