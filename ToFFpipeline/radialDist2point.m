function [P] = radialDist2point(radialDist, LFargs, pixel, viewIdx)
    % converts a radial distance to a planar depth from the camera
    arguments
        radialDist double
        LFargs
        pixel (2,1) double
        viewIdx = []
    end
    % if view index not supplied, assume we are looking at the middle index
    % of the LF array
    if isempty(viewIdx)
        viewIdx = [LFargs.middleIdx; LFargs.middleIdx];
    end

    P = LFargs.K\[pixel(1);pixel(2);1];
    P = radialDist*P/norm(P);

    % add offset due to middle index being used
    P = P + ([viewIdx(2); viewIdx(1); 0] - [1;1;0])*LFargs.seperation; % minus 1 due to indexing from 1
end