function [LFargs] = readLFargs(path)
    argsFileName = fullfile(path,"LFargs.mat");
    temp = load(argsFileName);
    LFargs = temp.LFargs;
    LFargs.seperation = LFargs.baseline/(LFargs.N-1);
    
    if mod(LFargs.N,2) == 0
        error("Even N not supported")
    else
        LFargs.middleIdx = (LFargs.N+1)/2;
    end

end