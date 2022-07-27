function [centreViewImg, debug] = ToFFImage (distLF, ampLF, LFargs, nvargs)
    % uses the proposed approach to compute a correct image from the centre view of the LF
    % has a few different options for no use of pipeline, merge only and occlusion aware
    arguments
        distLF (:,:,:,:) double
        ampLF (:,:,:,:) double
        LFargs {isfield}

        nvargs.useOcclusionDetect bool = true
    end


end