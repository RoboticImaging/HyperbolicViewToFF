function [finalDist, singleDebug] = combineSinglePixelField (distLF, LFargs, pixel, nvargs)
    % runs the ToFF pipeline for a single pixel

    arguments
        distLF (:,:,:,:) double
        LFargs

        pixel (2,1) double

        nvargs.useOcclusionDetect = true
    end
    

    % compute the initial Pz

    % optimize over rmse
    computeSinglePixelFieldSingleDepth();

    % set return values
    finalDist = 0;
    singleDebug.test = 0;


end