function plotDepthImg(dImg)
    arguments
        dImg double
    end
    
    imagesc(squeeze(dImg))
    axis image
    axis off
    
    fp = getFontParams();
    ap = getATaxisParams();

    h = colorbar;
    set(gca, ap{:})
    ylabel(h, 'Distance [m]', fp{:})

end

