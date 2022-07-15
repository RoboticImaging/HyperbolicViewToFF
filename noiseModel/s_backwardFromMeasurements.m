clear;
clc;
close all;


syms alpha phi sig x z

assume(alpha, 'positive')
assume(phi>0 & phi<2*pi)
assume(sig, 'positive')

% enumerate as 0,pi/2,pi,3pi/2 = 0,1,2,3

% reasoning: at lowest level, is two buckets of pixels being subtracted. At
% large amounts of photons this is likely to be a difference of gaussian
% with mean i_psi and some variance. The variance is the sum of the means
% of each bucket, and thus only depends on integration time. Each quad
% image then has some mean mu_i (given by the true values of alpha, psi and phi)
% and the same variance sig^2

% when summing two PDF's, you convolve. The convution of N_1(mu_1, sig_1^2)
% with N_2(mu_2, sig_2^2) is a new gaussian N(mu_1+mu_2, sig_1^2+sig_2^2)
% =N(mu_1+mu_2, 2sig^2). This is the PDF for each quad difference in the
% expression. 

mu_13 = alpha*cos(phi);

dist_13(x) = 1/(sqrt(2*pi)*sig)*exp(-0.5*((x-mu_13)/sig).^2);
dist_13_squared(x) = 1/(2*sqrt(x))*(dist_13(x) + dist_13(-x));

mu_02 = alpha*cos(phi + pi/2);
dist_02(x) = 1/(sqrt(2*pi)*sig)*exp(-0.5*((x-mu_02)/sig).^2);
dist_02_squared(x) = 1/(2*sqrt(x))*(dist_02(x) + dist_02(-x));

tic
dist_square_sum(z) = int(dist_13_squared(x)*dist_02_squared(z-x),x,-inf,inf)

fn = matlabFunction(subs(dist_square_sum,[alpha,phi, sig],[45,pi/3,5]));

xVals = linspace(0.5,1.5,200)*45^2;

for xIdx = 1:length(xVals)
    res(xIdx) = fn(xIdx);
end
toc
