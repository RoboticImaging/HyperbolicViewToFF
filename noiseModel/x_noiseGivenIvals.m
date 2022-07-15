clear
clc
close all

rng(0)

% pick alpha and phi
alpha = 70;
phi = 1.3;

% simulate a draw from i given psi
psiVals = (0:3)*pi/2;
% iVals = alpha/2*cos(psiVals - phi);
% iVals = alpha/2*cos(psiVals - phi) + randn(1e6, length(psiVals));
iTrue = alpha/2*cos(psiVals - phi);

iVals = iTrue + normrnd(0, repmat(1*sqrt(abs(iTrue)),[1e7,1]));

% infer alpha and phi again
alphaGuess = sqrt((iVals(:,4)-iVals(:,2)).^2 + (iVals(:,3)-iVals(:,1)).^2);
phiGuess = atan((iVals(:,4)-iVals(:,2))./(iVals(:,3)-iVals(:,1)));


histogram(alphaGuess)
figure
histogram(phiGuess)

jbtest(alphaGuess)
jbtest(phiGuess)
