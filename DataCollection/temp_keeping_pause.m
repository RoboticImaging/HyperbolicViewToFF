function temp_keeping_pause(camera, duration, printTemps)
    % A drop in replacment for pause() which keeps the Kea warm by dropping frames
    arguments
        camera % a ToF Kea camera object, must be already started with cam.start()
        duration % the duration of the pause in seconds
        printTemps = true
    end

    t0 = clock;
    while etime(clock, t0) < duration
        frames = camera.getFrames();
    end
    if printTemps
        fprintf("Temperatures are [")
        fprintf("%.2f, ",frames(1).temperatures())
        fprintf("\b\b]\n")
    end
end