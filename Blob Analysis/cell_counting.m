clc; clear all;
%% Cell Counting 
%{
count cell nuclei in microscopy images.

The images used for the exercise are acquired by the Danish company 
Chemometec using their image-based cytometers. A cytometer is a machine 
used in many laboratories to do automated cell counting and analysis. 
We'll work with human bone cells, the umage have been imaged using
ultraviolet (UV) microscopy and a fluorescent staining method named DAPI.
%}

I16 = imread('CellData\Sample E2 - U2OS DAPI channel.tiff');
I16c = imcrop(I16, [700 900 500 500]); % Crop region from raw image
Im = im2uint8(I16c); % Convert region into 8-bit grayscale
imshow(Im, [0 150]); title('DAPI Stained U2OS cell nuclei');
% imshow can be used to visualize specific gray scale ranges 

figure
subplot(2,2,1)
imshow(Im, [0 150]);
title('[0 150] scale');

subplot(2,2,2)
imshow(Im, [50 150]);
title('[50 150] scale');

subplot(2,2,3)
imshow(Im, [0 100]);
title('[0 100] scale');

subplot(2,2,4)
imshow(Im, [15 75]);
title('[15 75] scale');
sgtitle('DAPI Stained U2OS cell nuclei');

% The less range that we have, without moving the 0, the more brigth would 
% be the cells. If we also increase the lowest value, the surrounding of
% the cell won't be brightened.

%% Ex 13 create a binary version of the image 

% Plot the original histogram 
figure
subplot(1,2,1)
imhist(Im)

% We will have a lot of 0 values, in order to create a more representative
% threshold we should get rid of the values there will definitely be
% background.
idx = Im > 5;
Im1 = Im(idx);
subplot(1,2,2)
imhist(Im1)

% Seems that if we don't take in account the values from 0 to 5, really
% dark pixels, seems like the histogram follows a binomial distribution.
% Where potential threshold could be 25-30. Let's choose 26

% Display the histogram with the threshold 
figure
imhist(Im1)
xline(26, 'r')

% Binarize the image 
T = 26;
Imb = Im > T;
figure
imshow(Imb)
title('Binarized Image')

% We can use imbinarize it uses otsu's method

L =imbinarize(Im);
figure 
subplot(1,2,1)
imshow(Imb)
title('Selected Threshold')

subplot(1,2,2)
imshow(L)
title("Otsu's Threshold") 

%% Ex 14 remove the border pixels 

% 1st Categorize the image, so when we get rid of the border pixels we
% discard the holw blob that's in the border. 

I = bwlabel(Imb, 8);

% Visualize the image 
figure
imagesc(I)
imagegrid(gca, size(I));
colormap(gca, jet);
title('BLOB segmentation')

% Calculate the number of blobs 
n_blobs = max(I, [], 'all');

% Clear borders 
Ic = imclearborder(I);

% Calculate the number of blobs after cleaning the borders 
n_blobsc = max(Ic, [], 'all');

% Visualize the image 
figure
subplot(1,2,1)
imagesc(I)
axis square
colormap(gca, jet);
title('BLOB segmentation')

subplot(1,2,2)
imagesc(Ic)
axis square
colormap(gca, jet);
title('BLOB segmentation cleaned borders')


% IT SEEMS THAT WE CLEAR 2 BLOBS WITH THE BORDER CLEANER BUT if we get the
% max value of Ic, it only shows us that we erased 1

%% Ex 15-16 Areas 

% Use regionprops to get some basic stats 
stats = regionprops(Ic, 'Area', 'Perimeter');

% store the areas from all the blobs 
areas = [stats(:,:).Area];

% visualize the agrupation of the areas by the histogram 
figure
histogram(areas, 100) 

% We can clearly see that most of the areas between 57 and 126, so we can
% get rid of all the other outliers 

% find the blob elements that fulfill certain condition 
idx = find(areas < 126 & areas > 50);

% Select those from the image
Icf = ismember(Ic, idx);
Icf = bwlabel(Icf);
% Check the areas
stats_f = regionprops(Icf, 'Area', 'Perimeter', 'Circularity');

% Visualize the nucleous cells and histogram 
figure
subplot(2,2,1)
imagesc(I)
axis square
colormap(gca, jet);
title('BLOB segmentation')

subplot(2,2,2)
imagesc(Icf)
axis square
colormap(gca, jet);
title('Blobs filter: borders and areas')

subplot(2,2,3)
histogram(areas, 50, 'FaceColor', 'b') 
title('Histogram before filter')

subplot(2,2,4)
histogram([stats_f(:,:).Area], 50, 'FaceColor', 'r') 
title('Histogram After filter')

%% Circularity 

area = [stats_f(:,:).Area];
perimeter = [stats_f(:,:).Perimeter];

f_circ = 2*sqrt(pi*area)./perimeter;

figure
subplot(1,2,1) 
histogram(f_circ, 20, 'FaceColor', 'c')
title('Histogram agrupation')
xlabel('Circulrity of a nuclei') 
axis square


subplot(1,2,2)
scatter(f_circ, area, ...
                     'MarkerFaceColor', 'c',...
                     'MarkerEdgeColor', 'b')
title('Correlation between circularity and Area') 
xlabel('Circulrity of a nuclei') 
ylabel('Area of a cell')
axis square
sgtitle('Analysis on nuclei cells') 

%% Select good cells 
% Select thresholds 
lwA = 49;
hiA = 110;
lwC = 0.91;
hiC = 1.17;

% find index positions
idx_area = find(areas < hiA & areas > lwA);
% idx = find(areas < 126 & areas > 50);
% Get from the image only the desired blobs 
Icfa = ismember(Icf, idx_area);

% Categorize again the blobs so we can filter again 
Icfac = bwlabel(Icfa, 8);

% Blobs erased with the area filter
a = length(idx_area)-length(unique(Icfac));

% Calculate again the circularity from the nuceils
stats1 = regionprops(Icfac, 'Circularity', 'Area');
f_circ1 = [stats1(:,:).Circularity];
areas1 = [stats1(:,:).Area];

% Get the indexes where the circularity fulfill the conditions
idx_circ = find(f_circ1 < hiC & f_circ1 > lwC);
% Get from the image only the desired blobs 
Icfacf = ismember(Icfac, idx_circ);
% Basic Stats of bolobs
stats2 = regionprops(Icfacf, 'Circularity', 'Area');
f_circ2 = [stats2(:,:).Circularity];
areas2 = [stats2(:,:).Area];

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % IS THERE ANY WAY WHERE WE CAN FILTER THE IMAGE WITH THE INDEX
        % AREA AND MAINTAIN THE BLOB CATEGORIES. IF NOT WE HAVE TO
        % CALCULATE AGAIN THE PERIMETERS, AREA OR CIRCULARITY OF EACH
        % ELEMENT TO FILTER AGAIN ON THE OTHER BLOBS PROPERTIES.
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
figure
% Blob Display
subplot(2,3,1)
imshow(Icf)
title('Binarized Image')

subplot(2,3,2)
imshow(Icfa)
title('Area filter')

subplot(2,3,3)
imshow(Icfacf)
title('Circularity')
sgtitle('Transition of ereased Blobs')

% Scatter Plots
subplot(2,3,4)
scatter([stats_f(:,:).Circularity], area, ...
                     'MarkerFaceColor', 'c',...
                     'MarkerEdgeColor', 'b')
title('Correlation between circularity and Area') 
xlabel('Circulrity of a nuclei') 
ylabel('Area of a cell')
axis square

subplot(2,3,5)
scatter(f_circ1, areas1, ...
                     'MarkerFaceColor', 'c',...
                     'MarkerEdgeColor', 'b')
title('Correlation between circularity and Area') 
xlabel('Circulrity of a nuclei') 
ylabel('Area of a cell')
axis square

subplot(2,3,6)
scatter(f_circ2, areas2, ...
                     'MarkerFaceColor', 'c',...
                     'MarkerEdgeColor', 'b')
title('Correlation between circularity and Area') 
xlabel('Circulrity of a nuclei') 
ylabel('Area of a cell')
axis square

%% Ex 20 Implement function 

I2 = imread('CellData\Sample E2 - U2OS DAPI channel.tiff');
[I, n] = CountCellNuclei(I2);

I16 = imread('CellData\Sample E2 - U2OS DAPI channel.tiff');
Im = im2uint8(I16); % Convert region into 8-bit grayscale
Io = imbinarize(Im);

figure
subplot(2,2,1)
imshow(Io)
title('Binarized image without outliers')

subplot(2,2,2)
imshow(I)
title('Filtered Image with Area and Circularity')

f = ones(3,3);
Ie = imerode(Io, f);
Id = imdilate(Ie,f);
subplot(2,2,3)
imshow(Id)
title('closing operation');

%I3 = CountCellNuclei(Id);

subplot(2,2,4)
imshow(I3)
title('Filtered Image after closing operation')
%% Closing Operation 
% Create a filter 
f = ones(3,3);
% Applicate erosion to the image
L5 = imerode(Icf,f);
% Aplicate dilatation to the image 
L6 = imdilate(L5,f);

figure
subplot(1,3,1)
imshow(Icf);
title('Original')

subplot(1,3,2)
imshow(L5)
title('Eroded Image')

subplot(1,3,3)
imshow(L6);
title('Opening')


