function [imgsToAnalyse, methodNames, LFargs, dLF] = getAllMethodImgs(dset, nvargs)
    arguments
        dset % string to path or dLF itself

        nvargs.ToFF_threshold double = -0.3
        nvargs.DF_pixel = [154;111]
    end

    if isstring(dset) % check if path
        [dLF, ampLF, LFargs] = readToFFarray(dset); 
        [HQdistImg] = readHQimg(dset);
    else % if not path, unpack struct
        dLF = dset.dLF;
        HQdistImg = dset.HQimg;
        LFargs = dset.LFargs;
        ampLF = zeros(size(dLF));
    end

    
    [ToFFimg, ~] = ToFFImage(dLF, ampLF, LFargs, "occlusionMethod", 'threshold', 'threshold', nvargs.ToFF_threshold);
    

    [DFimg] = DepthFieldImage (dLF, LFargs, nvargs.DF_pixel);
    
    singleImg = squeeze(dLF(LFargs.middleIdx, LFargs.middleIdx, :, :));


%     ToFFimg = singleImg;
    imgsToAnalyse = {singleImg, HQdistImg, DFimg, ToFFimg};
    methodNames = ["Single", "$N^2$", "DF","ToFF"];
end