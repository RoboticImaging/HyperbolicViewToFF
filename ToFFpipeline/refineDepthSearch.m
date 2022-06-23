function [depth, rmse, nPts, debug] = refineDepthSearch(dLF_fn, LFsize, K, initPz, pixel, ToFFarr)
    arguments
        dLF_fn (1,1) % a gridded interpolant object to search through the LF
        LFsize (1,4) % size(dLF)
        K (3,3) double % camera intrisic matrix
        initPz (1,1) double % initial depth to search at
        pixel (1,2) double % the pixels (k,l)
        ToFFarr
    end
    
    [error, P, subset] = checkSurface(initPz, K, ToFFarr, LFsize, dLF_fn, pixel);

    

    % outputs
    depth = norm(P);
    rmse = rms(error);
    nPts = sum(subset);
    debug.P = P;

    % threshold and refit

    
end