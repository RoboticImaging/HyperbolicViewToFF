function rmse = computeScreenAccuracy(dImg, kVals, lVals, truePz)
    % compute the rmse of a flat screen from a depth image with given pixel
    % crop and true Pz value

    Pzimg = getPzimg(dImg, LFargs);

    imCropped = Pzimg(lVals,kVals);

    rmse = rms(imCropped - truePz,'all');
end