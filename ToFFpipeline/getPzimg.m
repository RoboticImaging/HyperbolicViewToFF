function [Pimg] = getPzimg(dImg, LFargs)
    Pimg = zeros(LFargs.size(3), LFargs.size(4));

    for l = 1:LFargs.size(3)
        for k = 1:LFargs.size(4)
            pixel = [k; l];
            r = dImg(pixel(2), pixel(1));
            P = radialDist2point(r, LFargs, pixel);
            Pimg(l,k) = P(3);
        end
    end
end