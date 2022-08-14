function plotDepthImg(dImg, clim, nvargs)
    arguments
        dImg double
        clim = []

        nvargs.useCbar = true
        nvargs.useAxisImage = true
    end
    
    if isempty(clim)
        imagesc(squeeze(dImg))
    else
        imagesc(squeeze(dImg), clim)
    end
    if nvargs.useAxisImage
        axis image
    end
    axis off
    
    fp = getFontParams();
    ap = getATaxisParams();

    set(gca, ap{:})

    if nvargs.useCbar
        h = colorbar;
        set(h, ap{:})
        ylabel(h, 'Distance [m]', fp{:})
    end

end

