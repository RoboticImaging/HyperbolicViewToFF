function [pixelGrid] = getOtherViews (LF, pixel, LFargs, Pz)
    % shifts through the LF and finds the pixel in other views, returning a matrix of pixel values from other views
    % Adapted from LF toolbox
    arguments
        LF (:,:,:,:) double
        pixel (2,1) double
        LFargs 
        Pz double
    end

    % we have to use N-1 here since the linspace later counts endpoints!
    TVSlope = -LFargs.K(1,1)*LFargs.baseline/(Pz*(LFargs.N - 1));
    SUSlope = -LFargs.K(2,2)*LFargs.baseline/(Pz*(LFargs.N - 1));

    VOffsetVec = linspace(-0.5,0.5, LFargs.size(1)) * TVSlope*LFSize(1);
    UOffsetVec = linspace(-0.5,0.5, LFargs.size(1)) * SUSlope*LFSize(2);

    [ii,jj] = meshgrid(1:LFargs.N);

    u = pixel(1);
    v = pixel(2);
    [uu, vv] = meshgrid(u + UOffsetVec, v + VOffsetVec);

    grid = {jj(:), ii(:), vv(:), uu(:)};
end