% m_compareWithDF 
% compares our pipeline with depth fields [S. Jayasuriya 2015]


clear
clc
close all


pth = fullfile("..\data\results\mat\occlusions\");

[dLF, ampLF, LFargs] = readToFFarray(pth); 

[dImg, debug] = ToFFImage(dLF, ampLF, LFargs, "occlusionMethod", 'activecontour');

figure
imagesc(dImg)
colorbar

[dImgNoOcclusion, debugNone] = ToFFImage(dLF, ampLF, LFargs, "occlusionMethod", 'none');

figure
imagesc(dImgNoOcclusion)
colorbar