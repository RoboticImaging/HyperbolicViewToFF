function [phaseLF,ampLF] = readToFF(pathToMat,N, cameraParams)

    
    % get sizes of LF
    fileName = fullfile(pathToMat,"1-1_amplitude.mat");
    temp = load(fileName);

%     phaseLF = zeros(size(temp.amp,1),size(temp.amp,2),N,N);
%     ampLF = zeros(size(temp.amp,1),size(temp.amp,2),N,N);

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

