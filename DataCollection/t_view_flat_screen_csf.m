clear
clc
close all



addpath('../ToFFpipeline/')


N = 15; 
% N = 3; 

folderName = 'side_wall_HQ';
resultsLoc = "../data/results";
% resultsLoc = "G:\ACFR Winter storage\NewResults\";
dataFolder = fullfile(resultsLoc,"csf",folderName);

tmp = load("cameraParams_july_2022.mat");
cameraParams = tmp.cameraParams_july_2022;

[~, ~, LFargs] = readToFFarray(fullfile(resultsLoc,"mat",folderName));


fileName = fullfile(dataFolder,"centerHQ.csf");
cell_of_imgs = readCSF(fileName, [tof.FrameType.AMPLITUDE, tof.FrameType.PHASE]);
amp = mean(cell_of_imgs{1}, 3);
phi = mean(cell_of_imgs{2}, 3);


dist_stack = phase2Dist(cell_of_imgs{2}, LFargs.f);

kVals = 95:214;
lVals = 67:148;

clim = 1.04 + 0.04*[-1,1];


figure
j=1;
% for i = 1:size(dist_stack, 3)
for i = [1:30, 30:20:size(dist_stack, 3)]
    Pzimg = getPzimg(squeeze(dist_stack(:,:,i)),LFargs);

    imCropped = Pzimg(lVals, kVals);
    imagesc(imCropped,clim)
    title(sprintf("frame %d",i))
    colorbar
    drawnow

    frame = getframe(gcf);
    im{j} = frame2im(frame);
    j = j+1;
end

%%
fname = 'animSimple.gif';
frame_rate = 30;
for idx = 1:length(im)
    [A, map] = rgb2ind(im{idx}, 256);
    if idx == 1
        imwrite(A,map, fname, 'gif', 'LoopCount', Inf, 'DelayTime', 3)
    else
        imwrite(A,map, fname, 'gif', 'WriteMode', 'append', 'DelayTime', 1/frame_rate)
    end 
end
imwrite(A,map, fname, 'gif', 'WriteMode', 'append', 'DelayTime', 3)

