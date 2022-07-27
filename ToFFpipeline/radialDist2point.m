function [P] = radialDist2point(radialDist, LFargs, pixel)
    % converts a radial distance to a planar depth from the camera
    arguments
        radialDist double
        LFargs
        pixel (2,1) double
    end

    P = LFargs.K\[pixel(1);pixel(2);1];
    P = radialDist*P/norm(P);
end