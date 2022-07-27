function [distImg, ampImg] = readHQimg(path) 
    % read just the centre view as a high quality ToF image
    arguments
        path string {exist(path,'dir')}
    end

    LFargs = readLFargs(path);

    
    fileName = fullfile(path,"1-1_amplitude.mat");
    temp = load(fileName);

    ampImg = temp.amp;

    
    fileName = fullfile(path,"1-1_phase.mat");
    temp = load(fileName);

    phaseImg = temp.phi;

    distImg = phase2Dist(phaseImg, LFargs.f);

end