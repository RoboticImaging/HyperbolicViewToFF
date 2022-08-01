clear
clc
close all

pth = fullfile("..\data\results\mat\gray_head");
[~, ~, LFargs] = readToFFarray(pth);


Pz = 1; %m

P = zeros(3, LFargs.size(3), LFargs.size(4));

% repeat process for every point
for l = 1:LFargs.size(3)
    for k  = 1:LFargs.size(4)

        pixel = [k;l];

        P(:,l,k) = Pz2point(Pz, LFargs, pixel);
        
    end
end

figure
titles = ["Px","Py","Pz"];
for i = 1:3
    subplot(1,3,i)
    imagesc(squeeze(P(i,:,:)))
%     contour(squeeze(P(i,:,:)))
    colorbar
    title(titles(i))
    axis image
end

