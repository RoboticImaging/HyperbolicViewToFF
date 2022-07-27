function [indexSubset] = rejectInvalidDataPts (distGrid, threshold)
    % rejects saturated and similar points, returning a logical array of points to sample at
    arguments
        distGrid double
        threshold double = 0.02
    end

    indexSubset = (distGrid > threshold);
end