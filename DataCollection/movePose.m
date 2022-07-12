function movePose(socket, pos, orientation, nvargs)
    % move the arm to pos, with orientation given by orientation input in
    % an axis-angle definition

    arguments
        socket 
        pos (1,3) 
        orientation (1,3) 
        nvargs.a = 1
        nvargs.v = 1
        nvargs.t = 10
        nvargs.r = 0
    end

    fprintf(sprintf('movej(p[%.7f,%.7f,%.7f,%.7f,%.7f,%.7f],a=%.7f, v=%.7f, t=%.7f, r=%.7f)\n',...
        pos(1),pos(2),pos(3),orientation(1),orientation(2),orientation(3),nvargs.a,nvargs.v,nvargs.t,nvargs.r))
    
    fprintf(socket, sprintf('movej(p[%.7f,%.7f,%.7f,%.7f,%.7f,%.7f],a=%.7f, v=%.7f, t=%.7f, r=%.7f)\n',...
        pos(1),pos(2),pos(3),orientation(1),orientation(2),orientation(3),nvargs.a,nvargs.v,nvargs.t,nvargs.r));
    pause(1.05*t)

end