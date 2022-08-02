function plotTheoreticalvsMeasured(theoreticalGrid, distGrid, validIndicies)
    % plots surface and crosses of actual measurement
    % optional add for different colours to show occlusion detection working
    arguments
        theoreticalGrid (:,:) double
        distGrid (:,:) double
        validIndicies double = []
    end
    
    N = size(theoreticalGrid,1);

    if isempty(validIndicies)
        validIndicies = true(N, N);
    end
    assert(numel(distGrid) == numel(validIndicies));

    [ii,jj] = meshgrid(1:N);

    figure
    plot3(jj(:), ii(:), distGrid(:), 'rx', LineWidth=1.2);
    hold on
    surf(theoreticalGrid)

    xlabel('x')
    ylabel('y')
    grid on


end