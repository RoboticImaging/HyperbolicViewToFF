clear;
clc;
close all;

rng(0)

sz = [1,1e6];

mu = [2,3]*1e2;
sigma = [1,1];

% N_1 = mu(1) + sigma(1)*randn(sz);
% N_2 = mu(2) + sigma(2)*randn(sz);

lambda = [2,3]*1e4;

N_1 = poissrnd(lambda(1),sz);
N_2 = poissrnd(lambda(2),sz);

subaxis(3,1,1)
histogram(N_1)
subaxis(3,1,2)
histogram(N_2)
subaxis(3,1,3)
histogram(N_2-N_1)


fprintf("means: %.3f, %.3f, %.3f\n", mean(N_1), mean(N_2), mean(N_2-N_1))
fprintf("std: %.3f, %.3f, %.3f\n", std(N_1), std(N_2), std(N_2-N_1))


figure
normplot(N_2-N_1)

jbtest(N_2-N_1)

% phase is: atan((i_{3pi/2}-i_{pi/2})/(i_{0}-i_{pi}))
% amp is: 0.5*sqrt((i_{}-i_{})^2 + (i_{}-i_{})^2)

