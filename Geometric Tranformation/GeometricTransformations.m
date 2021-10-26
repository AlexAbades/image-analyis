clc; clear all;
%% Exercise 1
% Create a grid --> meshgrid 
x = -6:6;
y = -6:6;

[X,Y] = meshgrid(x,y);

%% Ex 3 
% Reshape the grid into a 2xn matrix 

XY = [X(:) Y(:)]';

%% Exercise 3 
% Plot

PlotGrid(XY);

%% Exercise 4 
% Rescale 
Sx = 0.7;
Sy = 1.3;

% Create a Liear tranformation matrix 
T = [Sx 0; 0 Sy];
% Apply Trenformation 
B = A * XY;
% Plot the New Matrix vs the old 
PlotGrid(B)

%% Ex 5 
% Rotate the grid  

% Specify rotation parameters
alpha = 20;
c = cos(-alpha);
s = sin(-alpha);
% Create a Rotation matrix 
T2 = [c -s; s c];

% Apply tranformation 
C = T2* XY;

% Plot 
PlotGrid(C)








