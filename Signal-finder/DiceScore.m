function [DSC, I, res] = DiceScore(Iin, GT)

% Get the number of pixels with values different from 0. Take in an account
% that the blob could have values grater than 1.
AIin = sum(sum(Iin));
AGT = sum(sum(GT));

% Overlap between two images. Passes the pixels where we have the same
% value
I = Iin & GT;

% Get the number of pixels with values different from 0.
Acom = sum(sum(I));
%Ares = (AIin | AGT);
%resT = 2*(Iin | GT) - I;

resT = 2*abs((Iin - I ))+ abs((GT - I));
res = label2rgb(resT);

% Dice Coefficient is 2 * the Area of Overlap divided by the total number 
% of pixels in both images.
DSC = 2*Acom / (AIin + AGT);

%sprintf('Area: GT: %f  Iin: %f com: %f  DSC: %f', AGT, AIin, Acom, DSC)
