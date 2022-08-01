function [distGrid] = getTheoreticalSurface (pixel, radialDist, LFargs)
    % return the grid of distances to the pixel from all view, assuming no
    % occlusion
    arguments
        pixel (2,1) double % in form [k; l]
        radialDist double
        LFargs
    end
    
%     P = radialDist2point(radialDist, LFargs, pixel);

    sep = LFargs.baseline/(LFargs.N-1)
    LFargs.seperation

    fn = @(i,j) sqrt(P(3)^2 + (P(1) - (i-1)*sep).^2 + ...
                     (P(2) - (j-1)*sep).^2);

    [ii,jj] = meshgrid(1:LFargs.N);

    distGrid = fn(ii,jj);

end