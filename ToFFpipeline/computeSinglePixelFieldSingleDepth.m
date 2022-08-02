function [error] = computeSinglePixelFieldSingleDepth (dLFinterp, LFargs, pixel, Pz)
    arguments
        dLFinterp % a gridded interp object
        LFargs
        pixel (2,1) double % in form [k;l]
        Pz double
    end

    % extract data
    grid = getOtherViewIndexes (pixel, LFargs, Pz);
    dataGrid = dLFinterp(grid{2}(:), grid{1}(:), grid{4}(:), grid{3}(:));

    % compute the theoretical surface
    theoreticalGrid = getTheoreticalSurface (pixel, Pz, LFargs);

    % get anti saturation mask
    [indexSubsetSat] = rejectInvalidDataPts (dataGrid);
    [indexSubsetOcc] = rejectOcclusionOutliers (dataGrid);
    indexSubset = and(indexSubsetSat, indexSubsetOcc);

    % get Goodness of Fit
    error = evaluateGoF(dataGrid, theoreticalGrid, indexSubset);
end