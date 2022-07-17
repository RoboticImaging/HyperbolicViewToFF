function grid = getInterpGrid(K, ToFFarr, LFSize, Pz, pixel)
    % return a grid that contains the points needed for griddedInterpolant
    % to shift and interpolate
    % Adapted from LF toolbox

    % we have to use N-1 here since the linspace later counts endpoints!
    TVSlope = -K(1,1)*ToFFarr.d/(Pz*(ToFFarr.N));
    SUSlope = -K(2,2)*ToFFarr.d/(Pz*(ToFFarr.N));

    VOffsetVec = linspace(-0.5,0.5, LFSize(1)) * TVSlope*LFSize(1);
    UOffsetVec = linspace(-0.5,0.5, LFSize(2)) * SUSlope*LFSize(2);

    [ss,tt] = meshgrid(1:ToFFarr.N);


%     u = pixel(1) + K(2,2)*ToFFarr.d/(2*Pz);
%     v = pixel(2) + K(1,1)*ToFFarr.d/(2*Pz);
    u = pixel(2);
    v = pixel(1);
    [uu,vv] = meshgrid(u + UOffsetVec, v + VOffsetVec);

    grid = {tt(:), ss(:), vv(:), uu(:)};
end