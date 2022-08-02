function [centreViewDistImg, debug] = ToFFImage (distLF, ampLF, LFargs, nvargs)
    % uses the proposed approach to compute a correct image from the centre view of the LF
    % has a few different options for no use of pipeline, merge only and occlusion aware
    arguments
        distLF (:,:,:,:) double
        ampLF (:,:,:,:) double
        LFargs {}

        nvargs.occlusionMethod = 'none'
        nvargs.contour = 'edge'
        nvargs.useWbar = true
    end

    centreViewDistImg = zeros(LFargs.size(3), LFargs.size(4));

    if nvargs.useWbar
        w = waitbar(0,"starting ToFF");
        wCount = 0;
    end

    % repeat process for every point
    for l = 1:LFargs.size(3)
        for k  = 1:LFargs.size(4)
            if nvargs.useWbar
                w = waitbar(wCount/(LFargs.size(3)*LFargs.size(4)), w, "computing ToFF...");
                wCount = wCount + 1;
            end
%             fprintf("%d,%d\n",k,l);

            pixel = [k; l];

            [finalDist, singleDebug] = combineSinglePixelField(distLF, LFargs, pixel);

            centreViewDistImg(l,k) = finalDist;
            debug(l,k) = singleDebug;
        end
    end

end