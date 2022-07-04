function res = getUpwardsVec(v)
    % takes unit vector in R3 and updates the upward pointing vector
    direction = cross(v,[0,0,1]);
    res = vrrotvec2mat([direction./norm(direction),pi/2])*v./norm(v);
end