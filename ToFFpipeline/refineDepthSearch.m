function [depth, rmse, nPts, debug] = refineDepthSearch(dLF_fn, LFsize, K, initPz, pixel, ToFFarr)
    arguments
        dLF_fn (1,1) % a gridded interpolant object to search through the LF
        LFsize (1,4) % size(dLF)
        K (3,3) double % camera intrisic matrix
        initPz (1,1) double % initial depth to search at
        pixel (1,2) double % the pixels (k,l)
        ToFFarr
    end
    
    % resample the LF to shift it correctly 
    grid = getInterpGrid(K, ToFFarr, LFsize, initPz, pixel);
    depthSamples = dLF_fn(grid{2},grid{1},grid{4},grid{3});
    depthSamples = reshape(depthSamples,[ToFFarr.N, ToFFarr.N]);

    P = initPz*(K\[pixel';1]) + ToFFarr.d/2*[1;1;0];

    % check how well surface fits
    % TODO: check (s,t)
    fitted_curve = @(s,t) sqrt(P(3).^2 + (s*ToFFarr.d/(ToFFarr.N-1)-P(1)).^2 + (t*ToFFarr.d/(ToFFarr.N-1)-P(2)).^2);

    % get subset
    [ii,jj] = meshgrid(1:ToFFarr.N);
    regionCut = true(ToFFarr.N, ToFFarr.N);
    notSaturated = depthSamples > 0.02;
    subset = and(notSaturated, regionCut);
    subset = subset(:);

    error = depthSamples(subset) - fitted_curve(ii(subset),jj(subset));

    % outputs
    depth = norm(P);
    rmse = rms(error);
    nPts = length(subset);
    debug.P = P;

    % threshold and refit

    
end