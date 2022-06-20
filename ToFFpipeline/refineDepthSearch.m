function [depth, rmse, nPts] = refineDepthSearch(dLF_fn, LFsize, K, initPz, pixel)
    arguments
        dLF_fn (1,1) % a gridded interpolant object to search through the LF
        LFsize (1,4) % size(dLF)
        K (3,3) double % camera intrisic matrix
        initPz (1,1) double % initial depth to search at
        pixel (1,2) double % the pixels (k,l)
    end
    
    % resample the LF to shift it correctly 
    grid = getInterpGrid();

    depthSamples = dLF_fn(grid);


    % check how well surface fits
    fitted_curve = @(s,t) sqrt(P(3).^2 + (t*d-P(1)).^2 + (s*d-P(2)).^2);

    % threshold and refit
    
end