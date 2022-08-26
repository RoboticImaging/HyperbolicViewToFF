function temp_keeping_pause(camera, duration)
    t0 = clock;
    while etime(clock, t0) < duration
        frames = camera.getFrames();
    end
    fprintf("Temperatures are [")
    fprintf("%.2f, ",frames(1).temperatures())
    fprintf("\b\b]\n")
end