% Example of reading a camera configuration file.
function print_configuration(config)

    nframes = config.frameSize();

    for i = 0:(nframes - 1)
        roi = config.getRoi(i);

        fprintf("Frame: %i\n\n", i + 1);
        fprintf("Modulation Frequency %f\n", config.getModulationFrequency(i));
%         fprintf("Duty cycle %f\n", config.getDutyCycle(i));
%         fprintf("Start Row %i, Start Column %i, Number of Rows %i, Number of Columns %i\n", roi.getRowOffset(), roi.getColOffset(), roi.getImgRows(), roi.getImgCols());
        disp("Phase steps: ")
        disp(config.getPhaseShifts(i) * 360)
        disp("Integration times:")
        disp(config.getIntegrationTime(i));
    end

end
