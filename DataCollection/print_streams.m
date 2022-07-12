%% Print the available streams on a camera
function print_available_streams(cam)
    streams = cam.getStreamList();

    fprintf("Streams:\n")

    for stream = streams
        fprintf("\ttype: %s frame_id: %i frequency: %d integration time: %i\n", tof.frameTypeToString(stream.frameType()), stream.frameId(), stream.modulationFrequency(), stream.integrationTime());
    end

end
