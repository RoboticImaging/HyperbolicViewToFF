
kVals = 36:249;
lVals = 36:197;


[Pstack] = getPstack(distImg, LFargs, kVals=kVals, lVals=lVals);


centroid = mean(Pstack,2)

[u,s,~] = svd((Pstack-centroid));

n = u(:,end)

s




