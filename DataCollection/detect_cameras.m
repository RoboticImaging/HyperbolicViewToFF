% Detect cameras on the network, and print out their serial numbers and IP address.
function detect_cameras
    msgs = tof.GigeInterface().discover();

    for msg = msgs
        disp("Camera Serial: " + msg.serial() + "     IP Address: " + msg.ip());
    end

end
