function [fitted_curve, rmse, error, regionCut] = runCurveFitGivenPz(distSurf, regionCut,d,Pz)
    notSaturated = distSurf > 0.02;
    N = size(distSurf,1);
    [ii,jj] = meshgrid(1:N);
    
    
    subset = and(notSaturated, regionCut);
    subset = subset(:);
    
    fitfun = fittype( @(px,py,s,t) sqrt(Pz.^2 + (t*d-px).^2 + (s*d-py).^2), 'independent',{'s','t'});
    [fitted_curve,~] = fit([ii(subset),jj(subset)],distSurf(subset),fitfun,'StartPoint',[1 1]);
    
    error = distSurf(subset) - fitted_curve(ii(subset),jj(subset));
    rmse = rms(error);
end