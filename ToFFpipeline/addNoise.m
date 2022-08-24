function [newLF] = addNoise(dLF, sigma)
    % add noise with zero mean and variance sigma to the LF for processing
    arguments
        dLF (:,:,:,:)
        sigma double 
    end

    newLF = dLF + sigma*randn(size(dLF));
end