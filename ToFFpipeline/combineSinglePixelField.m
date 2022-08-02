function [finalDist, singleDebug] = combineSinglePixelField (distLF, LFargs, pixel, nvargs)
    % runs the ToFF pipeline for a single pixel

    arguments
        distLF (:,:,:,:) double
        LFargs

        pixel (2,1) double

        nvargs.useOcclusionDetect = true
    end
    
    distanceLFinterp = griddedInterpolant(distLF);
    

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
        rmseCoarse = zeros(length(PzVals));
        for i = 1:length(PzVals)
            rmseCoarse(i) = computeSinglePixelFieldSingleDepth(distanceLFinterp, ...
                                 LFargs, pixel, PzVals(i));
        end
        [~, minIdx] = min(rmseCoarse);
        initPz = PzVals(minIdx);
    end

    % optimize over rmse
    computeSinglePixelFieldSingleDepth();

    % set return values
    finalDist = 0;
    singleDebug.test = 0;


end