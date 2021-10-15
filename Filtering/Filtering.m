clear; clc; close all; % Clear workspace and figures
%% Exercise 1
%{
Matlab presents a large variety of different image filtering functions. The 
Matlab filtering function imfilter function performs general image 
filtering. The function takes a filter-kernel h and an image f. Take a look
of the documentation for imfilter.
%}

% help imfilter
% Uses a kernel filter without normalization
% g(x,y) = h(x,y) ∘ f(x,y);


f = [zeros(5,3),ones(5,2)];
h = ones(3,3);

g = imfilter(f, h);
g(2, 4);

%{
 Alternatively, try to use Matlabs array editor to edit your image f or 
your fillter h.   
%}

%% Exercie 2
% Create a simple kernel for a mean filter:
im1 = imread('Gaussian.png');
imshow(im1);

% Specify the filter dimensions
fsize = 5;
%Create a mean filter with normalization
h = ones(fsize)/fsize^2;

% Examine the matrix h. Why should the size of the kernel be odd?
% Because we always have to put the pixel we want to map in the middle.
% Then we will have the same filter pixels on the right than on the left.

%% Exercise 3
%{
Apply the flter h on the image im1. Store the filtered image in a
variable called meanim1. Display both images in the same figure by using:
%}

meanim1 = imfilter(im1, h);
figure
subplot(1,2,1);
imshow(im1), colormap(gca,gray), axis image off;
title('Original image');
subplot(1,2,2);
imshow(meanim1), colormap(gca,gray), axis image off;
title('Filtered image, mean filter');

%{
When the value of an output pixel at the boundary of the image is computed,
a portion of the filter is usually outside the edge of the input image. The
imfilter normally fills in these on-the-edge pixels by assuming they are 0.
This is called zero padding. Since 0 is the value of a black pixel, the 
output image will have a dark edge as seen in the previous result.
%}

figure
subplot(1,2,1);
imshow(im1), colormap(gca,pink), axis image off;
title('Original image')
subplot(1,2,2);
imshow(meanim1), colormap(gca,pink), axis image off;
title('Filtered image, mean filter')

figure
subplot(1,2,1);
imshow(im1), colormap(gca,jet), axis image off;
title('Original image')
subplot(1,2,2);
imshow(meanim1), colormap(gca, jet), axis image off;
title('Filtered image, mean filter')

%% Exercise 4
%{
Find out how to use border replication with imfilter. Filter im1
with h using border replication. Store the filtered image in a variable called
meanim2.
%}

meanim2 = imfilter(im1, h, 'replicate');
figure()
subplot(1,2,1);
imshow(meanim1), colormap(gca,gray), axis image off;
title('Filtered image, mean filter 0 padding')
subplot(1,2,2);
imshow(meanim2), colormap(gca, gray), axis image off;
title('Filtered image, mean filter replicate padding')

% The borders of the image are darker on the 0 padding, in contrast the
% replicate padding has a better approach.

%% Exercise 5-6-7
%{
5 - Compare the two images: What do you see? Is there noise in the
original image? Has it been reduced in the mean filtered version?

6 - Vary the size of h from 5x5 to 15x15 and filter im1. What happens
with the noise when the size increases?
%}

figure
subplot(1,2,1);
imshow(im1), colormap(gca,gray), axis image off;
title('Filtered image, mean filter 0 padding');
subplot(1,2,2);
imshow(meanim2), colormap(gca, gray), axis image off;
title('Filtered image, mean filter replicate padding')

% The noise disapears, but the image becomes a little bit more blured.
% Specify the filter dimensions
fsize = 15;
%Create a mean filter
h = ones(fsize)/fsize^2;

meanim3 = imfilter(im1, h, 'replicate');
figure()
subplot(1,2,1);
imshow(im1), colormap(gca,gray), axis image off;
title('Filtered image, mean filter 0 padding')
subplot(1,2,2);
imshow(meanim3), colormap(gca, gray), axis image off;
title('Filtered image, mean filter replicate padding')

%% Exercise 8
%{
Try using the median filter on im1. Compare the result with the
result of the mean filter. What difference can you see?
%}

% Select the median filter, and specify a 5x5 matrix
medim = medfilt2(im1, [5 5]);
figure()
subplot(1,2,1)
imshow(medim);

% Create a kernel with normalization 
% Specify the filter dimensions
fsize = 5;
%Create a mean filter
h = ones(fsize)/fsize^2;
meanim4 = imfilter(im1, h);
subplot(1,2,2)
imshow(meanim4)

%% Exercise 9
%{
Try changing the size of the kernel for the median filter and the
mean filter. 
%}

figure()
subplot(2,2,1);
imshow(medim);
title('Median kernel [5 5]');

medim2 = medfilt2(im1, [15 15]);
subplot(2,2,2);
imshow(medim2);
title('Median Kernel [15 15]');

fsize = 5;
h = ones(fsize)/fsize^2;
meanim5 = imfilter(im1, h);
subplot(2,2,3);
imshow(meanim5);
title('Mean Kernel [5 5]');


fsize = 15;
h = ones(fsize)/fsize^2;
meanim15 = imfilter(im1, h);
subplot(2,2,4);
imshow(meanim15);
title('Mean Kernel [15 15]');

% We can see that as bigger the kernel, the more blur it gets the image, at
% some point it's not worth to increase the kernel. Comparing the filters
% of size 15, the median kernel works better than the mean, at least it
% seems less blur.
% It also remark more the edges from the image. 

%% Exercise 10
%{
Try to use both the mean filter and the median filter on the image
called SaltPepper.png
%}

sp = imread('SaltPepper.PNG');

% Apply meanfilter
fsize = 5;
h = ones(fsize)/fsize.^2;
meanim = imfilter(sp, h);

% Apply median filter 
medim = medfilt2(sp, [5 5]);

figure()
subplot(1,3,1)
imshow(sp)
title('Original Image')

subplot(1,3,2)
imshow(meanim);
title('Mean kernel [5 5]');

subplot(1,3,3)
imshow(medim);
title('Median kernel [5 5]');

%% Conclusions Part 1
% With salt and pepper noise median doesn't make a good work, it separates
% well the different areas of the image but it's not faithful to the
% origianl image. The colors change, it's like an aquarela effect.

%% Exercise 12

fspec = fspecial('average', 5);
fspecim = imfilter(sp,fspec);

figure()
subplot(1,3,1)
imshow(sp);
title('Original Image');

subplot(1,3,2)
imshow(meanim);
title('Predifined filter');

subplot(1,3,3)
imshow(fspecim);
title('Fspecial filter');

fspec = fspecial('average', 15);
fspecim = imfilter(sp,fspec);
subplot(1,3,3)
imshow(fspecim)
title('fspecial filter size 15') 

% It creates basicaaly the same kernel filter with normalization.

fspec = fspecial('disk', 2);
fspecim = imfilter(sp,fspec);
figure
imshow(fspecim)
title('fspecial filter size 15') 

% diference gaussian and average kernel 

fspecmean = fspecial('average', 5);
fspecdisk = fspecial('disk', 5);
fspecgaus = fspecial('gaussian', 5);

%% Edge detection 


sobelf = fspecial('prewitt');
prewitf = fspecial('sobel');

% Read the image
CT = imread('ElbowCTSlice.png');
figure 
imshow(CT)
title('Original Image')

CTSH = imfilter(CT, sobelf);
CTPH = imfilter(CT, prewitf);
CTSV = imfilter(CT, sobelf');
CTPV = imfilter(CT, prewitf');

figure
subplot(2,3,1)
imshow(CTSH);
title('Filtered Image Sobel horitzontal cmap normal')

subplot(2,3,2)
imshow(CTSH,[]);
title('Filtered Image Sobel horitzontal cmap gray')
% where the [] makes the command scale the gray values automatically

subplot(2,3,3)
imshow(CTSV,[]);
title('Filtered Image Sobel vertical cmap gray')

subplot(2,3,4)
imshow(CTPH);
title('Filtered Image Prewitt horitzontal cmap normal')

subplot(2,3,5)
imshow(CTPH,[]);
title('Filtered Image Prewitt horitzontal cmap gray')

subplot(2,3,6)
imshow(CTSV,[]);
title('Filtered Image Prewitt vertical cmap gray')

% change the cmaps 
figure
subplot(1,3,1) 
imshow(CTPH, [])
title('Filtered Image Prewitt horitzontal cmap gray')

subplot(1,3,2)
imshow(CTPH,colormap(gca, jet));
title('Filtered Image Prewitt horitzontal cmap jet')

subplot(1,3,3)
imshow(CTPH,colormap(gca, hot));
title('Filtered Image Prewitt horitzontal cmap hot')



CTPV = imfilter(CT, -prewitf');
figure
imshow(CTPV, [])



% Probe to apply horizontal filter and vertical.
CTPHV = imfilter(CTPH, prewitf');

figure
imshow(CTPHV)
title('Probe of double filter')
% Doesn't work






