function numInvalid = computeCompletness(dImg)
    % given an image, compute the proportion of the points that are not
    % saturated
%     fracValid = sum(rejectInvalidDataPts(dImg))/numel(dImg);
    numInvalid = sum(dImg < 0.6, 'all');
%     numInvalid = sum(~rejectInvalidDataPts(dImg));
end