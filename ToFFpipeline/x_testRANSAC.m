clear;
clc;
close all;

% set up memory
% folder = fullfile("G:\ACFR Winter storage\TOFF\matFiles\boxBlocksWithCoke");
folder = fullfile("G:\ACFR Winter storage\Winter Project\git\ToF\Winter2020\ToFFexperiments\Results\ToFF\matFiles\blockWithGroundTruth");

N = 15;
d = 0.3/(N-1); % distance between array points
[pLF,aLF] = readToFF(folder,N);



k = 162;
l = 114;

% l = 60;
% k = 87;

% k = 145;
% l = 106;



c = 3e8;
f_m = 50e6;

tmp = load('cameraParams.mat');
K = tmp.cameraParams.IntrinsicMatrix';

% PzVals = linspace(0.8,1.2,20);
PzVals = linspace(0.86,1.1,40);
% PzVals = linspace(1.35,1.6,20);
% PzVals = linspace(1,1.8,35);

% [ii,jj] = meshgrid(1:N);
% fitters = {@(distSurf,regionCut,pz) runCurveFit(distSurf, regionCut,d),...
%               @(distSurf,regionCut,pz) runCurveFitGivenPz(distSurf, regionCut,d,pz),...
%               @(distSurf,regionCut,pz) runCurveFit(distSurf, true(N,N),d),...
%               @(distSurf,regionCut,pz) runCurveFitGivenPz(distSurf, true(N,N),d,pz)};
% 
% fitLeg  =["Curve fit (regionCut)", "Curve fit with Pz Fixed (regionCut)", ...
%     "Curve fit (full)", "Curve fit with Pz Fixed (full)"];


fitters = {@(distSurf,regionCut,pz) runCurveFit(distSurf, regionCut,d),...
              @(distSurf,regionCut,pz) runCurveFitGivenPz(distSurf, regionCut,d,pz),...
              @(distSurf,regionCut,pz) runCurveFitFullyFixed(distSurf, regionCut,d,pz,K,k,l)};
fitLeg  =["full fit", "Pz fixed", "all fixed"];

errors = zeros(length(fitters),length(PzVals));
regionSize = zeros(length(fitters),length(PzVals));


waitTotal = length(fitters)*length(PzVals);
waitCount = 0;

for fitIdx = 1:length(fitters)
    tic
    for depthIdx = 1:length(PzVals)
        waitbar(waitCount/waitTotal)
    
        slope = -K(1,1)*d/PzVals(depthIdx);
        newLF = ATshiftLF(pLF, slope);
        phaseSurface = squeeze(newLF(:,:,l,k));
        distSurf = phaseSurface*c/(4*pi*f_m);

        phaseRegions = true(N,N);
%         phaseRegions = bwlabel(~edge(distSurf),4);
%         phaseRegions = kmeans(distSurf(:),2);
%         phaseRegions = reshape(phaseRegions,[N,N]);
        regionCut = phaseRegions == phaseRegions((N+1)/2,(N+1)/2);


        regionCut = true(N,N);
        [fitted_curve, rmse, error, regionCut] = fitters{fitIdx}(distSurf, regionCut,PzVals(depthIdx));
        tol = 0.03; % 3cm
        [xx,yy] = meshgrid(linspace(1,N,20));
        regionCut  = and(min(fitted_curve(xx,yy),[],'all') - tol < distSurf, distSurf < tol + max(fitted_curve(xx,yy),[],'all'));
        if (sum(regionCut,'all') >= 2) && regionCut((N+1)/2,(N+1)/2) == 1
            [fitted_curve, rmse, error, regionCut] = fitters{fitIdx}(distSurf, regionCut,PzVals(depthIdx));
        end

        regionSize(fitIdx,depthIdx) = sum(regionCut,'all');
    
        errors(fitIdx,depthIdx) = rmse;

        waitCount = waitCount + 1;
    end
    toc
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

