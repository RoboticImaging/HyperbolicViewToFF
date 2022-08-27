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


%% plots per method

[imgsToAnalyse, methodNames, LFargs, dLF, imEnum] = getAllMethodImgs(pth);

figure
for imgIdx = 1:length(imgsToAnalyse)
    subplot(1,length(imgsToAnalyse),imgIdx)

    [Pstack] = getPstack(imgsToAnalyse{imgIdx}, LFargs, kVals=kVals, lVals=lVals);
    errors = plane.n'*(Pstack(:,:)- plane.centroid);
    
    errors = reshape(errors, [length(kVals), length(lVals)])';
    
    imagesc(errors, 0.03*[-1,1]);
    colorbar
    axis image
end







