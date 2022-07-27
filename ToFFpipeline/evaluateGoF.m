function [rmse] = evaluateGoF (distGrid, surfFn, indexSubset)
    % evaluate the goodness of fit of the surface to the measured data
    arguments
        distGrid (:,:) double
        surfFn {isa(surfFn, 'function_handle')}
        indexSubset double
    end
    assert(numel(distGrid) == numel(indexSubset));

end