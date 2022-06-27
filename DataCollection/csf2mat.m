clear;
clc;


N = 15;

dataFolder = "Results/ToFF/CsfFiles/blocksWithSat/";
resultsFolder = "Results/ToFF/matFiles/blocksWithSat/";

mkdir(resultsFolder)

copyfile(strcat(dataFolder,"info.txt"),resultsFolder)

cameraParams = load("cameraParams.mat");


for j = 1:N
    for k = 1:N
        fileName = strcat(dataFolder,sprintf('%d-%d.csf',j,k));
        csf_type = CSFType(); 
        [~,frames_phi] = bufferCSF(fileName, csf_type('phi') ); 
        [~,frames_amp] = bufferCSF(fileName, csf_type('amp') ); 
        
        % flip things so they are the right way around and average across
        % all frames
        amp = flip(mean(frames_amp,3)',2);
        phi = flip(mean(frames_phi,3)',2);

        % rectifications
        [amp,~] = undistortImage(amp,cameraParams);
        [phi,~] = undistortImage(phi,cameraParams);
        
        save(strcat(resultsFolder,sprintf('%d-%d_phase.mat',j,k)), 'phi')
        save(strcat(resultsFolder,sprintf('%d-%d_amplitude.mat',j,k)), 'amp')
    end
end



