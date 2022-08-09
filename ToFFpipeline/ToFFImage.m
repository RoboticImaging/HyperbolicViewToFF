function [centreViewDistImg, debug] = ToFFImage (distLF, ampLF, LFargs, useWbar, nvargs)
    % uses the proposed approach to compute a correct image from the centre view of the LF
    % has a few different options for no use of pipeline, merge only and occlusion aware
    arguments
        distLF (:,:,:,:) double
        ampLF (:,:,:,:) double
        LFargs {}

        useWbar = true

        nvargs.occlusionMethod = 'none'
        nvargs.contour = 'edge'
        nvargs.threshold = -0.05
    end
    
    % need to convert to cell to pass it down
    nvargsCell = namedargs2cell(nvargs);

    centreViewDistImg = zeros(LFargs.size(3), LFargs.size(4));

    if useWbar
        w = waitbar(0,"starting ToFF");
        wCount = 0;
    end

    % repeat process for every point
    for l = 1:LFargs.size(3)
        for k  = 1:LFargs.size(4)
            if useWbar
                w = waitbar(wCount/(LFargs.size(3)*LFargs.size(4)), w, "computing ToFF...");
                wCount = wCount + 1;
            end
%             fprintf("%d,%d\n",k,l);

            pixel = [k; l];

            [finalDist, singleDebug] = combineSinglePixelField(distLF, LFargs, pixel, nvargsCell{:});

            centreViewDistImg(l,k) = finalDist;
            debug(l,k) = singleDebug;
        end
    end
    if useWbar
        close(w)
    end

end