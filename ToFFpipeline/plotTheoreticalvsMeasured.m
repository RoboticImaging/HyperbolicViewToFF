function plotTheoreticalvsMeasured(theoreticalGrid, distGrid, validIndicies, nvargs)
    % plots surface and crosses of actual measurement
    % optional add for different colours to show occlusion detection working
    arguments
        theoreticalGrid (:,:) double
        distGrid (:,:) double
        validIndicies logical = []

        nvargs.alpha = 0.4
    end
    
    N = size(theoreticalGrid,1);

    if isempty(validIndicies)
        validIndicies = true(N, N);
    end
    assert(numel(distGrid) == numel(validIndicies));

    [ii,jj] = meshgrid(1:N);

    plot3(ii(validIndicies), jj(validIndicies), distGrid(validIndicies), 'rx', LineWidth=1.2);
    hold on
    plot3(ii(~validIndicies), jj(~validIndicies), distGrid(~validIndicies), 'bx', LineWidth=1.2);
    surf(theoreticalGrid)
    alpha(nvargs.alpha)

    % formatting
    fp = getFontParams();
    ap = getATaxisParams();
    xlabel('j', fp{:})
    ylabel('i', fp{:})
    zlabel('Distance [m]', fp{:})
    set(gca, ap{:})
    grid on


end