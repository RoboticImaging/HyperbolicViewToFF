clear
clc
close all


pth = fullfile("..\data\results\mat\occlusions\");
[dLF, ampLF, LFargs] = readToFFarray(pth); 

pixel = [245,18];

[finalDist, singleDebug] = combineSinglePixelField (dLF, LFargs, pixel, "occlusionMethod", 'threshold');

plotTheoreticalvsMeasured(singleDebug.theoreticalGrid, singleDebug.distGrid, singleDebug.indexSubset)



Pzvals = linspace(1.2,1.55,20);
errors = zeros(size(Pzvals));
nPts = errors;
distanceLFinterp = griddedInterpolant(dLF, 'linear', 'nearest');

for i = 1:length(Pzvals)
    [e, distGrid, theoreticalGrid, indexSubset] = computeSinglePixelFieldSingleDepth (distanceLFinterp, LFargs, pixel, Pzvals(i), "occlusionMethod", 'threshold');
    errors(i) = e;
    nPts(i)= sum(indexSubset,'all');
end

figure
ATplot(Pzvals, errors);

figure
ATplot(Pzvals, nPts);

radialDist = dLF(LFargs.middleIdx,LFargs.middleIdx, pixel(2), pixel(1));
P = radialDist2point(radialDist, LFargs, pixel);

[e, distGrid, theoreticalGrid, indexSubset] = computeSinglePixelFieldSingleDepth (distanceLFinterp, LFargs, pixel, P(3), "occlusionMethod", 'threshold');
plotTheoreticalvsMeasured(theoreticalGrid, distGrid, indexSubset)




