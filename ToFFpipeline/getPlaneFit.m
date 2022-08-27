function [plane] = getPlaneFit(Pstack)
    % given a set of points Pstack (3,N), find the best plane fit.

    centroid = mean(Pstack,2);

    [u,~,~] = svd((Pstack-centroid));

    n = u(:,end);

    if n(3) < 0
        n = -n;
    end

    plane.centroid = centroid;
    plane.n = n;
end