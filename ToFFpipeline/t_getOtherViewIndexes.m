clear
clc
close all


pth = fullfile("..\data\results\mat\occlusions\");
pixel = [196; 159]; % middle of board

% pth = fullfile("..\data\results\mat\small_N\");

% pth = fullfile("..\data\results\mat\plastic_saturation_2\");
% pixel = [190;112];

[dLF, ampLF, LFargs] = readToFFarray(pth);


% pixel = [94;152];
% pixel = [300;152];

r = dLF(LFargs.middleIdx, LFargs.middleIdx, pixel(2), pixel(1));
P = radialDist2point(r, LFargs, pixel);
Pz = P(3);


grid = getOtherViewIndexes (pixel, LFargs, Pz);

for row=1:4
    grid{row} = reshape(grid{row},[LFargs.N,LFargs.N]);
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
        imagesc(squeeze(dLF(grid{2}(row,col), grid{1}(row,col), :, :)))
        axis image
        set(gca,'YDir','reverse');
        ATplot(grid{3}(row, col), grid{4}(row, col),'rx') % correct way to plot is 3,4 and correct way to index is 4,3
%         pause

    end
end


% get the distGrid
gridInterp = griddedInterpolant(dLF);
distGrid = gridInterp(grid{2}(:), grid{1}(:), grid{4}(:), grid{3}(:));

figure
plot3(grid{1}(:), grid{2}(:), distGrid(:), 'rx');
xlabel('x')
ylabel('y')
grid on



