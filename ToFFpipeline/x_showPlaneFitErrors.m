clear
clc
close all


pth = fullfile("..\data\results\mat\side_wall_HQ_tempsafe\");
% pth = fullfile("..\data\results\mat\side_wall_ACTUAL_HQ_tempsafe\");
[dLF, ampLF, LFargs] = readToFFarray(pth); 
[HQdistImg] = readHQimg(pth);



% old paper (i.e. side_wall_HQ, paper_side wall)
% kVals = 95:214;
% lVals = 67:148;

% new paper (tempsafe ones)
kVals = 111:229;
lVals = 69:148;


[Pstack] = getPstack(HQdistImg, LFargs, kVals=kVals, lVals=lVals);
% [Pstack] = getPstack(HQdistImg + 0.1*randn(size(HQdistImg)), LFargs, kVals=kVals, lVals=lVals);

Pstack = Pstack(:,Pstack(3,:) > 0.08);

plane = getPlaneFit(Pstack);

%%
figure
plot3(Pstack(1,:),Pstack(2,:),Pstack(3,:),'r.')
xlabel('x')
ylabel('y')
zlabel('z')

hold on

plot3(plane.centroid(1),plane.centroid(2),plane.centroid(3),'bx')

P = Pstack';
B = [P(:,1), P(:,2), ones(size(P,1),1)] \ P(:,3);                       % Linear Regression
xv = [min(P(:,1)) max(P(:,1))];
yv = [min(P(:,2)) max(P(:,2))];
zv = [xv(:), yv(:), ones(2,1)] * B;  
patch([min(xv) min(xv) max(xv) max(xv)], [min(yv) max(yv) max(yv) min(yv)], [min(zv) min(zv) max(zv) max(zv)], 'r', 'FaceAlpha',0.5)


%%

%get complete pstack again
[Pstack] = getPstack(HQdistImg, LFargs, kVals=kVals, lVals=lVals);
errors = plane.n'*(Pstack(:,:)- plane.centroid);

errors = reshape(errors, [length(kVals), length(lVals)])';
figure
imagesc(errors, 0.01*[-1,1]);



singleImg = squeeze(dLF(LFargs.middleIdx, LFargs.middleIdx, :, :));

[Pstack] = getPstack(singleImg, LFargs, kVals=kVals, lVals=lVals);
errors = plane.n'*(Pstack(:,:)- plane.centroid);

errors = reshape(errors, [length(kVals), length(lVals)])';
figure
imagesc(errors, 0.01*[-1,1]);


