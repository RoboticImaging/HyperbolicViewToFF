function [depth, rmse, nPts, debug] = runPlaneSweep(dLF_fn, LFsize, K, initPz, pixel, ToFFarr, nPlanes)
    arguments
        dLF_fn (1,1) % a gridded interpolant object to search through the LF
        LFsize (1,4) % size(dLF)
        K (3,3) double % camera intrisic matrix
        initPz (1,1) double % initial depth to search at
        pixel (1,2) double % the pixels (k,l)
        ToFFarr 
        nPlanes
    end
    
%     [error, P, subset] = checkSurface(initPz, K, ToFFarr, LFsize, dLF_fn, pixel);

    Pzvals = linspace(0.7*initPz, 1.3*initPz,nPlanes);
    debug.rmseVals =zeros(size(Pzvals));

    for pzIdx = 1:length(Pzvals)
        err = checkSurface(Pzvals(pzIdx), K, ToFFarr, LFsize, dLF_fn, pixel);
        debug.rmseVals(pzIdx) = rms(err);
    end

    [~,minIdx] = min(debug.rmseVals);

    Pz = Pzvals(minIdx);

    P = Pz*(K\[pixel';1]) + ToFFarr.d/2*[1;1;0];
    debug.P = P;

    [~,~,ss] = checkSurface(Pzvals(minIdx), K, ToFFarr, LFsize, dLF_fn, pixel);

    depth = norm(P);
    rmse = debug.rmseVals(minIdx);
    nPts = sum(ss);

    
end