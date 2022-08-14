function [nPts, rmse] = generateDebugFigs(debug, LFargs, rmseClim, isPlot)
    arguments
        debug
        LFargs
        rmseClim
        isPlot = true
    end


    % takes a debug struct array from ToFFImage and produces some figures
    nPts = zeros(LFargs.size(3), LFargs.size(4));

    for k = 1:LFargs.size(3)
        for l = 1:LFargs.size(4)
            nPts(k,l) = sum(debug(k,l).indexSubset, 'all');
        end
    end

    if isPlot
        figure
        imagesc(nPts/LFargs.N^2, [0,1]);
        axis image
        axis off
    
        fp = getFontParams();
        ap = getATaxisParams();
    
        set(gca, ap{:})
        h = colorbar;
        set(h, ap{:})
        ylabel(h, 'Proportion of Points Used [ ]', fp{:})
    end

    rmse = zeros(LFargs.size(3), LFargs.size(4));

    for k = 1:LFargs.size(3)
        for l = 1:LFargs.size(4)
            rmse(k,l) = evaluateGoF (debug(k,l).distGrid, debug(k,l).theoreticalGrid, debug(k,l).indexSubset);
        end
    end

    if isPlot
        figure
        imagesc(rmse, rmseClim);
        set(gca, ap{:})
        h = colorbar;
        set(h, ap{:})
        axis image
        axis off
        ylabel(h, 'RMSE [m]', fp{:})
    end
end