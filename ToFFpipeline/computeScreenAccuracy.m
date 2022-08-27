function rmse = computeScreenAccuracy(dImg, LFargs, kVals, lVals, plane, doFilter)
    % compute the rmse of a flat screen from a depth image with given pixel
    % crop and true Pz value
    arguments
        dImg
        LFargs
        kVals
        lVals
        plane
        doFilter = true
    end


    [Pstack] = getPstack(dImg, LFargs, kVals=kVals, lVals=lVals);
    if doFilter
        Pstack = Pstack(:,Pstack(3,:) > 0.08);
    end
    rmse = rms(plane.n'*(Pstack(:,:)- plane.centroid));
end


% ----
% old version of this function, which assumed perfect calib
%     Pzimg = getPzimg(dImg, LFargs);
% 
%     imCropped = Pzimg(lVals,kVals);

%     rmse = rms(imCropped(rejectInvalidDataPts(imCropped)) - truePz,'all');