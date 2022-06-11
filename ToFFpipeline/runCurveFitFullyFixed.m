function [fitted_curve, rmse, error, regionCut] = runCurveFitFullyFixed(distSurf, regionCut,d,Pz,K,k,l)
    % curve fit using only Pz, since the pixels are already in known
    % locations

    N = size(distSurf,1);
    [ii,jj] = meshgrid(1:N);

    notSaturated = distSurf > 0.02;
    subset = and(notSaturated, regionCut);
    subset = subset(:);


    P = Pz*(K\[k;l;1]) + ((N+1)/2)*d*[1;1;0];
    fitted_curve = @(s,t) sqrt(P(3).^2 + (t*d-P(1)).^2 + (s*d-P(2)).^2);

    error = distSurf(subset) - fitted_curve(ii(subset),jj(subset));
    rmse = rms(error);
end