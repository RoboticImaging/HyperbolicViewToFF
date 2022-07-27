function [dLF, ampLF, LFargs] = readToFFarray(path)
    % read the mat folder and extract the LF as a 4D array
    arguments
        path string {exist(path,'dir')}
    end
    
    fileName = fullfile(pathToMat,"1-1_amplitude.mat");
    temp = load(fileName);

    phaseLF = zeros(N,N,size(temp.amp,1),size(temp.amp,2));
    ampLF = zeros(N,N,size(temp.amp,1),size(temp.amp,2));

    for l = 1:N
        for k = 1:N
            fileName = fullfile(pathToMat, sprintf("%d-%d_amplitude.mat",l,k));
    
            temp = load(fileName);
            ampLF(l,k,:,:) = temp.amp;
    
            fileName = fullfile(pathToMat, sprintf("%d-%d_phase.mat",l,k));
    
            temp = load(fileName);
            phaseLF(l,k,:,:) = temp.phi;
        end
    end

    phaseLF = flip(phaseLF,1);
    ampLF = flip(ampLF,1);

end