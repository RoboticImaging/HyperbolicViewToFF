function [dist] = phase2Dist(phase, frequency)
    % convert to distance
    c = 3e8;
    dist = phase*c/(4*pi*frequency);
end