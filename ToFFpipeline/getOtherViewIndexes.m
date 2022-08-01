function [grid] = getOtherViewIndexes (pixel, LFargs, Pz)
    % shifts through the LF and finds the pixel in other views, returning a matrix of pixel values from other views
    % Adapted from LF toolbox
    arguments
        pixel (2,1) double
        LFargs 
        Pz double
    end

    % we have to use N-1 here since the linspace later counts endpoints!
    TVSlope = -LFargs.K(1,1)*LFargs.baseline/(Pz*(LFargs.N));
    SUSlope = -LFargs.K(2,2)*LFargs.baseline/(Pz*(LFargs.N));

    VOffsetVec = linspace(-0.5,0.5, LFargs.size(1)) * TVSlope*LFargs.size(1);
    UOffsetVec = linspace(-0.5,0.5, LFargs.size(1)) * SUSlope*LFargs.size(2);

    [ii,jj] = meshgrid(1:LFargs.N);

    u = pixel(2);
    v = pixel(1);
    [uu, vv] = meshgrid(u + UOffsetVec, v + VOffsetVec);

    grid = {jj(:), ii(:), vv(:), uu(:)};
end