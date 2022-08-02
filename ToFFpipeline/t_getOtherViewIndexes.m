clear
clc
close all


% pth = fullfile("..\data\results\mat\occlusions\");
% pixel = [196; 159]; % middle of board

% pth = fullfile("..\data\results\mat\small_N\");

pth = fullfile("..\data\results\mat\plastic_saturation_2\");
% pixel = [190;112];
pixel = [150;146]; % wooden bird chest

[dLF, ampLF, LFargs] = readToFFarray(pth);


% pixel = [94;152];
% pixel = [300;152];

r = dLF(LFargs.middleIdx, LFargs.middleIdx, pixel(2), pixel(1));
P = radialDist2point(r, LFargs, pixel);
Pz = P(3);


sampleGrid = getOtherViewIndexes (pixel, LFargs, Pz);

for row=1:4
    sampleGrid{row} = reshape(sampleGrid{row},[LFargs.N,LFargs.N]);
end

figure
imagesc(squeeze(dLF(LFargs.middleIdx,LFargs.middleIdx,:,:)));
hold on
ATplot(pixel(1), pixel(2),'rx')


nSubplotRows = 3;
figure
stSubset = round(linspace(1, LFargs.N, nSubplotRows));

for iIdx = 1:length(stSubset)
    row = stSubset(iIdx);
    for jIdx = 1:length(stSubset)
        col = stSubset(jIdx);

        fprintf("%d, %d\n",row,col)

%         subaxis(nSubplotRows, nSubplotRows, sub2ind([nSubplotRows,nSubplotRows], iIdx, jIdx));
        subaxis(nSubplotRows, nSubplotRows, sub2ind([nSubplotRows, nSubplotRows], iIdx, jIdx));

        

        hold on
        imagesc(squeeze(dLF(sampleGrid{2}(row,col), sampleGrid{1}(row,col), :, :)))
        axis image
        set(gca,'YDir','reverse');
        ATplot(sampleGrid{3}(row, col), sampleGrid{4}(row, col),'rx') % correct way to plot is 3,4 and correct way to index is 4,3
%         pause

    end
end


% get the distsampleGrid 
sampleGridInterp = griddedInterpolant(dLF);
distsampleGrid = sampleGridInterp(sampleGrid{2}(:), sampleGrid{1}(:), sampleGrid{4}(:), sampleGrid{3}(:));

figure
plot3(sampleGrid{1}(:), sampleGrid{2}(:), distsampleGrid(:), 'rx');
xlabel('x')
ylabel('y')
grid on



