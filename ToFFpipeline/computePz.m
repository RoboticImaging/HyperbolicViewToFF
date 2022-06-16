function Pz = computePz(K, r, pixel)
    % compute the depth from the radial distance
    arguments
        K (3,3) double % camera intrisic matrix
        r (1,1) double % radial distance
        pixel (1,2) double % the pixels (k,l)
    end
    % [k;l;1] = K*P
    P = K\[pixel(1);pixel(2);1];
    P = r*P/norm(P);
    Pz = P(3);
end