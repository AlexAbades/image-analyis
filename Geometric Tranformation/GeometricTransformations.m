clc; clear all;
%% Exercise 1
% Create a grid --> meshgrid 
x = -6:6;
y = -6:6;

[X,Y] = meshgrid(x,y);

%% Ex 3 
% Reshape the grid into a 2xn matrix, such that each column
% in the matrix corresponds to a 2D point

XY = [X(:) Y(:)]';

%% Exercise 3 
% Plot
figure
PlotGrid(XY);

%% Exercise 4 
% Rescale 
Sx = 0.7;
Sy = 1.3;

% Create a Liear tranformation matrix 
T = [Sx 0; 0 Sy];
% Apply Trenformation 
B = T * XY;
% Plot the New Matrix vs the old 
figure
PlotGrid(B)

%% Ex 5 
% Rotate the grid  

% Specify rotation parameters. By default a rotation matrix aas defined
% rotates the space counterclockwise 
alpha = 20;
c = cosd(alpha);
s = sind(alpha);
% Create a Rotation matrix 
T2 = [c -s; s c];

% Apply tranformation 
C = T2* B;

% Plot 
PlotGrid(C)

%% GEOMETRIC TRANSFORMATIONS ON IMAGES
%% EX 6

I = imread('Im.png');
figure()
imshow(I)
title('Original Image')

[M, N] = size(I);
sx = 3;
sy = 2;
% Create a matrix of the new size
P = zeros(M*sy, N*sx);

for i = 1:M
    for j = 1:N
        P(((i-1)*sy)+1, ((j-1)*sx)+1) = I((i),(j));
    end
end
% Tranform to unit8
P = uint8(P);
% Show figure with imagesc
figure; imagesc(P); colormap('gray')


%{
Alternative

[row, col] = size(I); % (384,512)

sx = 3;
sy = 2;

P = zeros(row*sy, col*sx); % (768,1536)

r = 1:row; % (1,...,384) --> len: 384
c = 1:col; % (1,...,768) --> len: 512

r_im = (r -1)*sy+1; % (0,...,767) --> len: 384
c_im = (c -1)*sx+1; % (0,...,1534) --> len: 512


row = 384
col = 512

for i = 1:row
    for j=1:col
        P(r_im(i), c_im(j)) = I(r(i),c(j));
    end
end
%}

% Alternative 

%% Ex 7 

% In order to use ineterpolation we need to create two grids 

% We create two grids of the Image size, The first one will have columns
% from 1 to M with the same value on the rows for each column. The second 
% matrix will have rows from 1 to N with the same value on each column per
% r.ow
[X,Y] = meshgrid(1:N,1:M);  % --> Remember to that the dimensions of an 
% image are inversed 

% We combine both meshes in order to create a matrix that stores the
% location of eah element of the matrix I ('cause it has its dimensions).
XY = [X(:) Y(:)]';
% We transpose the matrix in order to compute the transformation:
% T * v --> Being T the tranformation matrix and v the x,y vector 

% Calculate the inverse of the matrix T
% T = [sx 0; 0 sy];  As it is a diagonal matrix, we just have to divide by
% its elements on the diagonal 
T = [1/sx 0; 0 1/sy];

% Create the grid for the scaled Image
[Xsc,Ysc] = meshgrid(1:N*sx,1:M*sy);

% Create a matrix that stores the location of the scaled matrix
XYsc = [Xsc(:) Ysc(:)]';

% Calculate which location each pixel (or elemenent) should have the scaled
% matrix on the original image. 
XYscOrLoc = T * XYsc;

% Reshape the scaled matrix that stores the location that should have each
% pixel in the original matrix to two it's original size
XscL = reshape(XYscOrLoc(1,:), size(Xsc));
YscL = reshape(XYscOrLoc(2,:), size(Ysc));

% Now we have two grids that store the positions the scaled matrix should
% have in the original matrix and two grids that store the locations or
% positions of the original matrix.
% Now we can calculate which values would have the scaled matrix by
% interpolating between the values on the nearest locations. 
Isc = interp2(X,Y,im2double(I),XscL,YscL);

% Show the image 
figure
imagesc(Isc);
colormap('gray')


%% REGISTRATION

%% Hand tranformation
%Load both hands 
hand1 = imread("Hand1.jpg");
hand2 = imread("Hand2.jpg");

% Show the hands to compare them 
figure
subplot(1,2,1)
imshow(hand1)
title('Hand 1')

subplot(1,2,2)
imshow(hand2)
title('Hand 2')

%% Select landmarks on both images 
% We have to select landmarks in order to be ables to make the
% tranformations. We have to select the same positions on both images, or
% at least the in as much as possible. 

% First argument, the moving image (the one that we are going to tranform
% to match th original, hand1).
%cpselect(hand2, hand1)  

% Get the moving and the fixed points
%movingpoints = cpstruct.basePoints;
%fixedpoints = cpstruct.inputPoints;

% Save the landmarks 
%save('fixedPoints.mat', 'fixedpoints');
%save('movingPoints.mat', 'movingpoints');

load('fixedPoints.mat');
load('movingPoints.mat');

% Plot both hands. Separate the points on x and y coordinates
figure;
plot(fixedpoints(:,1), fixedpoints(:,2), 'b*-', ...
     movingpoints(:,1), movingpoints(:,2), 'r*-');
% Add legend 
legend('Hand 1 - The fixed image', 'Hand 2 - The moving image');
% We have to reverse the axis upside down. 
axis ij; 

%% Compute the error 
% In order to calculate how well are alligned the two images we have to
% calculate the distance between the locations we've selected. 
% We'll compute them separately 

error = abs(fixedpoints-movingpoints);
A = sum(sum(error.*error));

%% Compute center of mass 

fixed_COM = mean(fixedpoints);
moving_COM = mean(movingpoints);
figure;
plot(fixedpoints(:,1), fixedpoints(:,2), 'b*-', ...
     movingpoints(:,1), movingpoints(:,2), 'r*-');
hold on 
plot(fixed_COM(1,1), fixed_COM(1,2), 'b+', 'MarkerSize', 12)
plot(moving_COM(1,1), moving_COM(1,2), 'r+', 'MarkerSize', 12)


















