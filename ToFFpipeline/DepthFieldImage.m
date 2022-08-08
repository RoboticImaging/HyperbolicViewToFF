function [ImgOut] = DepthFieldImage (distLF, LFargs, pixel)
    % uses the previous approach [S. Jayasuriya 2015] to get an image from 
    % the centre view at a particular depth
    
    arguments
        distLF (:,:,:,:) double
        LFargs
        pixel (2,1) double
    end

    % calculate Pz
    r = distLF(LFargs.middleIdx, LFargs.middleIdx, pixel(2), pixel(1));
    P = radialDist2point(r, LFargs, pixel);

    % calculate slope
    slope = -LFargs.K(1,1)*LFargs.baseline/(P(3)*(LFargs.N));
    
    % shift and sum the LF
    ImgOut = LFFiltShiftSum(distLF, slope);
    ImgOut = ImgOut(:,:,1);



end