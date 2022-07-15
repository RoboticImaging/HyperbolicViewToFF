clear;
clc;
close all

rng(0)

N_experiments = 1e7;

alpha = 1;
phi = pi/3;

N_phases = 4;

sigma = 0.5;

psi = linspace(0,2*pi,N_phases+1);
psi = psi(1:end-1)';

true_xy = alpha*exp(1i*phi)

quad_out = real(true_xy*exp(1i*psi)) + sigma*randn([N_phases,1,N_experiments]);

% measurement matrix
M = [real(exp(1i*psi)) real(1i*exp(1i*psi))];

% now solving system Mx = i
x = pagemtimes((M'*M)\M',quad_out);

estimated_xy = x(1,1,:) + 1i*x(2,1,:);
estimated_xy = squeeze(estimated_xy);

figure(1)
histogram(real(estimated_xy))
hold on
ATplot(real(true_xy)*[1,1], ylim, 'r')
title(sprintf("x, with var %.3f", var(real(estimated_xy))))
figure(2)
histogram(imag(estimated_xy))
hold on
ATplot(imag(true_xy)*[1,1], ylim, 'r')
title(sprintf("y, with var %.3f", var(imag(estimated_xy))))



jbtest(real(estimated_xy))
jbtest(imag(estimated_xy))


% check x,y are not correlated with each other
R = corrcoef([real(estimated_xy), imag(estimated_xy)])

% now to amp and phase
alpha_guess = abs(estimated_xy);
phi_guess = atan2(imag(estimated_xy),real(estimated_xy));


figure(3)
histfit(alpha_guess)
hold on
ATplot(alpha*[1,1], ylim, 'r')
figure(4)
histfit(phi_guess)
hold on
ATplot(phi*[1,1], ylim, 'r')


jbtest(alpha_guess)
jbtest(phi_guess)
