function plotTheoreticalvsMeasured(surfFn, distGrid, validIndicies)
    % plots surface and crosses of actual measurement
    % optional add for different colours to show occlusion detection working
    arguments
        surfFn {isa(surfFn, 'function_handle')}
        distGrid (:,:) double
        validIndicies double
    end
    assert(numel(distGrid) == numel(validIndicies));
    
end