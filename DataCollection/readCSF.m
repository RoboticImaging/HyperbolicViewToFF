function [cell_of_imgs] = readCSF(file, fameTypes)
    % returns an image stack in a cell with each cell index corresponding
    % to the frame type passed in

    arguments
        file  % the file to read from 
        fameTypes % a list of the frames we are interested in e.g. [tof.frameType.AMPLITUDE]
    end

    cell_of_imgs = {};

    
    for frameTypeIdx = 1:length(fameTypes)
        csfRead = tof.CsfReader(file);
        frameSize = [320,240];
        frame = zeros(frameSize(2),frameSize(1),1);
        j = 1;

        while csfRead.frameIndex ~= csfRead.numberOfFrames()
            frames = csfRead.readFrame();
            if frames.frameType() == fameTypes(frameTypeIdx)
                frame(:,:,j) = flip(frames.data',2);
                j = j + 1;
            end
        end
        
        cell_of_imgs{frameTypeIdx} = frame;
    end
end