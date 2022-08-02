function [indexSubset] = rejectInvalidDataPts (distGrid, threshold)
    % rejects saturated and similar points, returning a logical array of points to sample at
    arguments
        distGrid double
        threshold double = 0.08
    end

    indexSubset = (distGrid > threshold);
    indexSubset = indexSubset(:);
end