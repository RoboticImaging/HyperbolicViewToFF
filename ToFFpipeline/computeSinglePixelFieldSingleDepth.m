function [error, dataGrid, theoreticalGrid, indexSubset] = computeSinglePixelFieldSingleDepth (dLFinterp, LFargs, pixel, Pz, nvargs)
    arguments
        dLFinterp % a gridded interp object
        LFargs
        pixel (2,1) double % in form [k;l]
        Pz double

        nvargs.occlusionMethod = 'none'
        nvargs.contour = 'edge'
        nvargs.useOcclusionErrorThreshold = -0.1
    end
    Pz

    % extract data
    grid = getOtherViewIndexes (pixel, LFargs, Pz);
    dataGrid = dLFinterp(grid{2}(:), grid{1}(:), grid{4}(:), grid{3}(:));
    dataGrid = reshape(dataGrid, [LFargs.N, LFargs.N]);

    % compute the theoretical surface
    theoreticalGrid = getTheoreticalSurface (pixel, Pz, LFargs);

    % get anti saturation mask
    [indexSubsetSat] = rejectInvalidDataPts (dataGrid);
    indexSubsetSat = reshape(indexSubsetSat, [LFargs.N, LFargs.N]);

    isMiddleValid = rejectInvalidDataPts(dataGrid(LFargs.middleIdx,LFargs.middleIdx))

    distError = dataGrid - theoreticalGrid;
    % check if there is something that looks like it is occluding the scene
    if min(distError,[],'all') < nvargs.useOcclusionErrorThreshold
%     if sum(distError < nvargs.useOcclusionErrorThreshold) > 1
        [indexSubsetOcc] = rejectOcclusionOutliers (dataGrid - theoreticalGrid, isMiddleValid,...
                                'method', nvargs.occlusionMethod);
    else
        [indexSubsetOcc] = rejectOcclusionOutliers (dataGrid - theoreticalGrid, isMiddleValid,...
                                'method', 'none');
    end
    sum(indexSubsetOcc,'all')
    indexSubset = and(indexSubsetSat, indexSubsetOcc);

    % get Goodness of Fit
    error = evaluateGoF(dataGrid, theoreticalGrid, indexSubset);
end