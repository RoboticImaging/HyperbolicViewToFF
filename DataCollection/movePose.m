function movePose(socket, pos, orientation, a, v, t, r)
    % move the arm to pos, with orientation given by orientation input in
    % an axis-angle definition

    arguments
        socket 
        pos (1,3) 
        orientation (1,3) 
        a
        v
        t
        r
    end

    
    fprintf(socket, sprintf('movej(p[%.7f,%.7f,%.7f,%.7f,%.7f,%.7f],a=%.7f, v=%.7f, t=%.7f, r=%.7f)\n',...
        pos(1),pos(2),pos(3),orientation(1),orientation(2),orientation(3),a,v,t,r));
    pause(1.05*t)

end