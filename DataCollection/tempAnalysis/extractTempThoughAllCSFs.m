function [tmps] =  extractTempThoughAllCSFs(pth, N)
    csfRead = tof.CsfReader(fullfile(pth,"centerHQ.csf"));
    

    j = 1;

    while csfRead.frameIndex ~= csfRead.numberOfFrames()
        frames = csfRead.readFrame();
        if frames.frameType() == tof.FrameType.PHASE
            tmps(j,:) = frames.temperatures;
            j = j + 1;
        end
    end
    
    % now to reading the array
    
    row = 1;
    posCounter = 1;
    while row <= N
        if mod(row,2) == 0
            col = N;
        else
            col = 1;
        end
        while col <=N && col >=1
            fprintf('%d-%d\n',row, col)
            csfRead = tof.CsfReader(fullfile(pth,sprintf('%d-%d.csf',row,col)));

            while csfRead.frameIndex ~= csfRead.numberOfFrames()
                frames = csfRead.readFrame();
                if frames.frameType() == tof.FrameType.PHASE
                    tmps(j,:) = frames.temperatures;
                    j = j + 1;
                end
            end
            

            % update cols
            col = col + (-1)^(row-1);
            posCounter = posCounter + 1;
        end
        row = row + 1;
    end




end