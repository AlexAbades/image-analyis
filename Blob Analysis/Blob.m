%% Blob Analysis and cell counting
%{
bwlabel uses the grassfire concept to categorize different objects on the
image, matrix. (Connected component analysis. It can use a 4 or 8 connected
neighbours.
%}

%% Load image

load Image1.mat
imagesc(Image1);
imagegrid(gca,size(Image1));  % We specify gca to select a colormap 
colormap(gca, hot);

%% Exercise 1 
%{
Apply bwlabel on Image1 using 4 neighbours
%}

L4 = bwlabel(Image1, 4);
figure
subplot(1,2,1)
imagesc(L4);
imagegrid(gca, size(L4));
colormap(gca, hot);

subplot(1,2,2);
imagesc(Image1);
imagegrid(gca,size(Image1));  
colormap(gca, hot);

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
title('grassfire 4 neighbours');

subplot(1,3,3);
imagesc(L8);
imagegrid(gca,size(L8));  
colormap(gca, hot);
title('grassfire 8 neighbours');

% We can specify with the label2rgb to make more clear the previouos images
L8_rgb = label2rgb(L8, 'spring', 'c', 'shuffle');

%% OBJECT PROPERTIES
%% Exercise 4-5-6-7
%{
Regionprops allows you to get diferent summary values
of the labelled components
%}

stats8 = regionprops(L8, 'Area');

% Inspect a value for the first element (element categorized with blob,
% first blob element)

val = stats8(1).Area;

% We can get the area of all the components 

all_val = [stats8(:,:).Area];

% create a binary array where a certain condition is true, find where the
% values are true.
idx = find(all_val > 16);
% Select on the image based on the above condition
BW2 = ismember(L8,idx);

% Show the image where only the blobs above area 37 are selected
imagesc(BW2);
imagegrid(gca,size(BW2));  
colormap(gca, hot);
title('Bloobs with an area above 16.');

%% Exercise 8







