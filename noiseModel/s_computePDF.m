clear;
clc;
close all;


syms x lambda_1 lmbda lambda_2 z

assume(lambda_1, 'positive')
assume(lambda_2, 'positive')
assume(z, 'real')
assume(x, 'real')


pPDF(x, lmbda) = 1/(sqrt(2*pi)*sqrt(lmbda))*exp(-0.5*((x-lmbda)/sqrt(lmbda)).^2);

N_1(x) = pPDF(x, lambda_1);
N_2(x) = pPDF(-x, lambda_2);

tic
N_diff(z) = int(N_1(x)*N_2(z-x), x, -inf,inf);
toc

% cdf method to square this
% https://stats.stackexchange.com/questions/192807/pdf-of-the-square-of-a-standard-normal-random-variable
N_diff_squared(z) = 1/(2*sqrt(z))*N_diff(sqrt(z)) + 1/(2*sqrt(z))*N_diff(-sqrt(z));

return
%% check that the graphs make sense and the width changes with mean
l_1 = 50;
l_2 = 20;

fn_N_1 = matlabFunction(subs(N_1,lambda_1,l_1));
fn_N_2 = matlabFunction(subs(N_2,lambda_2,l_2));

xVals = linspace(-2*l_1,2*l_1,100);
ATplot(xVals,fn_N_1(xVals))
hold on
ATplot(xVals,fn_N_2(xVals))


fn_N_diff = matlabFunction(subs(N_diff,[lambda_1, lambda_2],[l_1,l_2]));
% figure
xVals = linspace(0,2*l_1,100);
ATplot(xVals,fn_N_diff(xVals))


fn_N_diff_sqr = matlabFunction(subs(N_diff_squared,[lambda_1, lambda_2],[l_1,l_2]));
xVals = linspace(0,2*l_1,100);
ATplot(xVals,fn_N_diff_sqr(xVals))


