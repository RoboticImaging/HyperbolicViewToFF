function [error, P, subset] = checkSurface(Pz, K, ToFFarr, LFsize, dLF_fn, pixel)

    % resample the LF to shift it correctly 
    grid = getInterpGrid(K, ToFFarr, LFsize, Pz, pixel);
    depthSamples = dLF_fn(grid{2},grid{1},grid{4},grid{3});
    depthSamples = reshape(depthSamples,[ToFFarr.N, ToFFarr.N]);

    P = Pz*(K\[pixel';1]) + ToFFarr.d/2*[1;1;0];

    % check how well surface fits
    % TODO: check (s,t)
    seperation = ToFFarr.d/(ToFFarr.N-1)-;
    fitted_curve = @(s,t) sqrt(P(3).^2 + (s*seperation-P(1)).^2 + (t*seperation-P(2)).^2);

    % get subset
    [ii,jj] = meshgrid(1:ToFFarr.N);
%     regionCut = true(ToFFarr.N, ToFFarr.N);
    regionCut = abs(depthSamples - fitted_curve(ii,jj)) < 0.04;
    notSaturated = depthSamples > 0.02;
    subset = and(notSaturated, regionCut);
    subset = subset(:);

    % might be jj,ii ??
    error = depthSamples(subset) - fitted_curve(ii(subset),jj(subset));
    

end