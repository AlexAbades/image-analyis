clc; clear all;
%% Blob Analysis and cell counting
%{
bwlabel uses the grassfire concept to categorize different objects on the
image, matrix. (Connected component analysis. It can use a 4 or 8 connected
neighbours). It has to be a binary image
%}

%% Load image

load Image1.mat % It's a Binary matrix that represents a image.
imagesc(Image1);
imagegrid(gca,size(Image1));  % We specify gca to select a colormap 
colormap(gca, hot);

%% Exercise 1 
%{
Apply bwlabel on Image1 using 4 neighbours
%}

L4 = bwlabel(Image1, 4);
figure
subplot(1,2,2)
imagesc(L4);
imagegrid(gca, size(L4));
colormap(gca, hot);
title('BLOB segmentation')

subplot(1,2,1);
imagesc(Image1);
imagegrid(gca,size(Image1));  
colormap(gca, hot);
title('Original Image');
sgtitle('4 Neighbours');

% We can clearly see that we 
%% Exercise 2
%{
Apply bwlabel on Image1 using 8 neighbours. Show it together
with the original and the result of the 4-neighbour operation using the subplot
command. Plot all in a subplot to see the differences
%}
% Filter the image with 8 neighbours
L8 = bwlabel(Image1, 8);

% We can specify different colormaps 
%L8 = label2rgb(L8);

figure
subplot(1,3,1);
imagesc(Image1);
imagegrid(gca,size(Image1));  
colormap(gca, hot);
title('Original image');

subplot(1,3,2)
imagesc(L4);
imagegrid(gca, size(L4));
colormap(gca, hot);
title('4 neighbours');

subplot(1,3,3);
imagesc(L8);
imagegrid(gca,size(L8));  
colormap(gca, hot);
title('8 neighbours');

sgtitle('Blob segmentation using grassfire')

% While the 4 neighbours segment the image into 8 different objects, the 8
% neighbour segments the image into 5 objects.

% We can specify with the label2rgb to make more clear the previouos images
L8_rgb = label2rgb(L8, 'spring', 'c', 'shuffle');
figure
imagesc(L8_rgb);
imagegrid(gca,size(L8_rgb));

%% OBJECT PROPERTIES
%% Exercise 4-5-6-7
%{
Regionprops allows you to get diferent summary values of the labelled 
components. Basically gets the different objects classified with the
bwlabel and calculates some basic stats like are... 
%}

% Creates a cell array with the number of objects found on bwlabel, in this
% case 5.
stats8 = regionprops(L8, 'Area');

% Inspect a value for the first element (element categorized with blob,
% first blob element)
val = stats8(1).Area;

% We can get the area of all the components and store them into a list
all_val = [stats8(:,:).Area];

% Create an array that returns the index position of those elements that
% fulfill a certain condition. 
idx = find(all_val > 16);

% Select on the original image the rows and columns from the objects stored
% on the idx array 
BW2 = ismember(L8,idx);

% Show the image where only the blobs above area 37 are selected
imagesc(BW2);
imagegrid(gca,size(BW2));  
colormap(gca, hot);
title('Bloobs with an area above 16');

% We can instead chose the ones that are above some area 
idx1 = find(all_val < 10);
BW3 = ismember(L8, idx1);
imagesc(BW3);
imagegrid(gca,size(BW3));  
colormap(gca, hot);
title('Bloobs with an area bellow 10');

%% Exercise 8
% Find the Perimeter of the different BLOBs on the image.

% Using regionprops
stats8 = regionprops(L8, 'Area', 'Perimeter');
perimeters = [stats8(:).Perimeter];


% Using erosion and counting element of pixels. 
% Use the L8 image, the labaled image to get the different Blobs on the
% image.
% Number of Blobbs
n_blob = max(L8, [], 'all');
% predefined array so it computes faster 
per = zeros(1,n_blob);
% Filter for the erosion 
f = ones(3,3);

% Iterate through all the Blobs on the image
for i = 1:n_blob
    % Get the desired Blob
   A = ismember(L8, i);
   % Get the erosioned Blob
   B = imerode(A, f);
   % substract the erosioned Blob form the original Blob
   C = A - B;
   % Count number of elements and store them into a list
   per(1,i) = nnz(C);
end


%% Ex 9 Number of elements bigger than

% Create a binary array, 1 for the ones that fulfill the condition 
elements = per > 20;
% If we put that condition inside the numel function we'll count only the
% elements that fullfill that condition 
n_elements = numel(elements, per>20);

% another way to do it 
e = find(per > 20);
n_e = numel(e);

%% Exercise 10 Plot Area in function of perimeter 
y = [stats8(:,:).Area]';
x = [ones(length(per),1) [stats8(:,:).Perimeter]'];

b = x\y;
y_pred = x*b;

figure
subplot(1,2,1)
plot(sort([stats8(:,:).Area]), sort([stats8(:,:).Perimeter]), 'r*')
hold on 
plot(sort(y_pred), sort(x(:,2)))
hold off 

% Calclate the linear regression 
x1 = [ones(length(per),1) per'];
b1 = x1\y;

y_pred1 = x1*b1;
subplot(1,2,2)
plot([stats8(:,:).Area], per, 'b*')
hold on 
plot(sort(y_pred1), sort(x1(:,2)))
hold off






