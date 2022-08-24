function [dImgStack, tmps] = extractDepthAndTemp(file, LFargs)

    csfRead = tof.CsfReader(file);
    
    frameSize = [320,240];
    dImgStack = zeros(frameSize(2),frameSize(1),1);
    j = 1;

    while csfRead.frameIndex ~= csfRead.numberOfFrames()
        frames = csfRead.readFrame();
        if frames.frameType() == tof.frameType.AMPLITUDE
            dImgStack(:,:,j) = phase2Dist(flip(frames.data',2), LFargs.f);
            tmps(j,:) = frames.temperatures;
            j = j + 1;
        end
    end
end