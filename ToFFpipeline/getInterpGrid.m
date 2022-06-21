function grid = getInterpGrid(K, ToFFarr, LFSize, Pz, pixel)
    % return a grid that contains the points needed for griddedInterpolant
    % to shift and interpolate

    TVSlope = -K(2,2)*ToFFarr.d/(Pz*(ToFFarr.N-1));
    SUSlope = -K(1,1)*ToFFarr.d/(Pz*(ToFFarr.N-1));

    VOffsetVec = linspace(-0.5,0.5, LFSize(1)) * TVSlope*LFSize(1);
    UOffsetVec = linspace(-0.5,0.5, LFSize(2)) * SUSlope*LFSize(2);

    [ss,tt] = meshgrid(1:ToFFarr.N);

    u = pixel(1);
    v = pixel(2);
    [uu,vv] = meshgrid(u + UOffsetVec, v + VOffsetVec);

    grid = {ss(:), tt(:), uu(:), vv(:)};

    

end