function [rmse] = evaluateGoF (distGrid, surfGrid, indexSubset)
    % evaluate the goodness of fit of the surface to the measured data
    arguments
        distGrid (:,:) double
        surfGrid (:,:) double
        indexSubset double
    end
    assert(numel(distGrid) == numel(indexSubset));
    assert(numel(surfGrid) == numel(indexSubset));

%     rmse = rms(indexSubset.*(distGrid - surfGrid), 'all');

%     indexSubset
    rmse = rms(distGrid(indexSubset == true) - surfGrid(indexSubset == true), 'all');
end