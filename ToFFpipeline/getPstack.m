function [Pstack] = getPstack(dImg, LFargs, nvargs)
    arguments
        dImg
        LFargs

        nvargs.lVals = []
        nvargs.kVals = []
    end


    if isempty(nvargs.lVals)
        nvargs.lVals = 1:LFargs.size(3);
    end

    if isempty(nvargs.kVals)
        nvargs.kVals = 1:LFargs.size(4);
    end

    Pstack = zeros(3, length(nvargs.kVals)*length(nvargs.lVals));

    j = 1;
    for l = nvargs.lVals
        for k = nvargs.kVals
            pixel = [k; l];
            r = dImg(pixel(2), pixel(1));
            P = radialDist2point(r, LFargs, pixel);

            Pstack(:, j) = P(:);
            j = j + 1;
        end
    end
end