function [finalDist, singleDebug] = combineSinglePixelField (distLF, LFargs, pixel, nvargs)
    % runs the ToFF pipeline for a single pixel

    arguments
        distLF (:,:,:,:) double
        LFargs

        pixel (2,1) double

        nvargs.occlusionMethod = 'none'
        nvargs.contour = 'edge'
    end
    
    distanceLFinterp = griddedInterpolant(distLF, 'linear', 'nearest');
%     distanceLFinterp = griddedInterpolant(distLF,'nearest');
    

    % compute the initial Pz
    r = distLF(LFargs.middleIdx, LFargs.middleIdx, pixel(2), pixel(1));

    % check if centre view is valid
    if rejectInvalidDataPts(r)
        P = radialDist2point(r, LFargs, pixel);
        initPz = P(3);
    else
        % since the centre view isn't valid, do a coarse plane sweep and
        % choose the best Pz
        PzVals = linspace(0.3,1.5,5);
        rmseCoarse = zeros(length(PzVals),1);
        for i = 1:length(PzVals)
            rmseCoarse(i) = computeSinglePixelFieldSingleDepth(distanceLFinterp, ...
                                 LFargs, pixel, PzVals(i));
        end
        [~, minIdx] = min(rmseCoarse);
        initPz = PzVals(minIdx);
    end

    % need to convert to cell to pass it down
    nvargsCell = namedargs2cell(nvargs);

    % optimize over rmse
    fnToOpt = @(Pz) computeSinglePixelFieldSingleDepth(distanceLFinterp, LFargs, pixel, Pz, nvargsCell{:});

    [Pz, finalErr] = fminsearch(@(PzVec) arrayfun(fnToOpt, PzVec), initPz);

    P = Pz2point(Pz, LFargs, pixel);

    % set return values
    finalDist = norm(P);

    singleDebug.finalErr = finalErr;
    [~, dataGrid, theoreticalGrid, indexSubset] = computeSinglePixelFieldSingleDepth(distanceLFinterp, LFargs, pixel, Pz, nvargsCell{:});
    singleDebug.distGrid = dataGrid;
    singleDebug.theoreticalGrid = theoreticalGrid;
    singleDebug.indexSubset = indexSubset;
end