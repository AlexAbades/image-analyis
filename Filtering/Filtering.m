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
%{ 
We can create special filters to detect the different edges on a image. We
can use the same filter of prewitt or sobel transposed or with the sign
changed
%}

sobelf = fspecial('prewitt');
prewitf = fspecial('sobel');

% Read the image
CT = imread('ElbowCTSlice.png');

% Apply some filters 
CTSH = imfilter(CT, sobelf); % Horizontal detection 
CTPH = imfilter(CT, prewitf); % Horizontal detection 

% Rotates the kernel 90 degrees
CTSV = imfilter(CT, sobelf'); % Vertical detection 
CTPV = imfilter(CT, prewitf'); % Vertical detection 

% Rotates 
CTSD = imfilter(CT, -sobelf); % Diagonal detection 
CTPD = imfilter(CT, -prewitf); % Diagonal detection 


% Check the normal image and some of the filters specifying gray filter or
% non gray filter
figure 
subplot(1,3,1)
imshow(CT)
title('Original Image')

subplot(1,3,2)
imshow(CTSH);
title('Filtered Image Sobel horitzontal normal cmap')

subplot(1,3,3)
imshow(CTSH, []);
title('Filtered Image Sobel horitzontal gray cmap ')
% where the [] makes the command scale the gray values automatically

% Chec all the different filters so we can understand which edges are
% detecting.

figure
subplot(2,3,1)
imshow(CTSH, []);
ylabel('Sobel Filter')

subplot(2,3,2)
imshow(CTSV, []);

subplot(2,3,3)
imshow(CTSD,[]);

subplot(2,3,4)
imshow(CTPH, []);
ylabel('Prewitt filter')
xlabel('Horizontal detection')

subplot(2,3,5)
imshow(CTPV,[]);
xlabel('Vertical detection')

subplot(2,3,6)
imshow(CTSD,[]);
xlabel('Diagonal Detection')

% Change the cmaps 
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


% Probe to apply horizontal filter and vertical.
CTPHV = imfilter(CTPH, prewitf');

figure
imshow(CTPHV)
title('Probe of double filter')
% Doesn't work

%% Exercise 15 
% mean kernel and edge detection

h1 = fspecial('average', 5);
h2 = fspecial('average', 13);

CT1 = imfilter(CT, h1);
CT2 = imfilter(CT, h2);

% Visualize the different kernels 
figure
subplot(1,2,1);
imshow(CT1);
title(' 5 by 5 dimension');

subplot(1,2,2)
imshow(CT2);
title('13 by 13 dimension');
sgtitle('Mean Kernel filter');

% Apply the edge detection after the kernel filter
edgeP = fspecial('prewitt');
CT1f = imfilter(CT1, edgeP);

subplot(1,2,1)
imshow(CT1f)
title('edge detection AFTER the kernel filter');

% Apply edge detection before kernel filter 
CT1e = imfilter(CT, edgeP);
CT1f = imfilter(CT1e, h1);
subplot(1,2,2);
imshow(CT1f)
title('Edge detection BEFORE the kernel filter')
% ORDER DOESN'T AFFECT THE RESULT 

% Check the differences between the to kernels
CT2f = imfilter(CT2, edgeP);

subplot(1,2,1); 
imshow(CT1f) 
title('5 by 5 Mean kernel')

subplot(1,2,2);
imshow(CT2f);
title('13 by 13 Mean kernel');
sgtitle('Edge detection AFTER the mean kernel')

%% Exercise 16
% median filter and edge detection 

CT1medf = medfilt2(CT, [5 5]);
CT2medf = medfilt2(CT, [13 13]);

edgeP = fspecial('prewitt');
CT1medfe = imfilter(CT1medf, edgeP);
CT2medfe = imfilter(CT2medf, edgeP);

figure
subplot(1,2,1);
imshow(CT1medfe);
title('5 by 5 filter');

subplot(1,2,2)
imshow(CT2medfe);
title('13 by 13 filter');
sgtitle('Median filter');

% Chek rotating the edges kernels 
CT1medfev = imfilter(CT1medf, edgeP');
CT2medfev = imfilter(CT2medf, edgeP');
CT1medfed = imfilter(CT1medf, -edgeP);
CT2medfed = imfilter(CT2medf, -edgeP);

subplot(2,3,1)
imshow(CT1medfe);
ylabel('5 by 5 kernel')

subplot(2,3,2)
imshow(CT1medfev);

subplot(2,3,3)
imshow(CT1medfed);

subplot(2,3,4)
imshow(CT2medfe);
ylabel('13 by 13 kernel')
xlabel('Normal kernel')

subplot(2,3,5)
imshow(CT2medfev);
xlabel('90º roatation')

subplot(2,3,6)
imshow(CT2medfed);
xlabel('-90º rotation')
sgtitle('Median kernel before edge detection')

%% Gaussian Filtering 
%  Removes high frequencies from the image.

hsize = 17;
sigma = 3;

G = fspecial('gaussian', hsize, sigma);
figure
surf(G)

% Check the image with the Gaussian filter 
CTG = imfilter(CT, G);
figure
imshow(CTG)

s2 = 3;
s3 = 11;
hsize3 = 51;

G2 = fspecial('gaussian', hsize, s2);
G3 = fspecial('gaussian', hsize3, s3);

CTG2 = imfilter(CT, G2);
CTG3 = imfilter(CT, G3);

subplot(1,3,1)
imshow(CTG)
title('Sigma = 1, hsize = 17'); 

subplot(1,3,2)
imshow(CTG2)
title('Sigma = 3, hsize = 517');

subplot(1,3,3)
imshow(CTG3)
title('Sigma = 11, hsize = 51');


%% Own images 
A = imread('alex.jpeg');

% Convert the image into a gray scale
Ag = rgb2gray(A); 

% Reshape the image 
Ar = imresize(Ag, [1000 NaN]);

% Show image 
imshow(Ar);

% Create some filters 
h1 = fspecial('average', 5) ;
A1 = imfilter(Ar, h1);

% Edge detection 
p = fspecial('prewitt');
s = fspecial('sobel');
g = fspecial('gaussian', 17, 3);

Ap = imfilter(Ar, p);
As = imfilter(Ar, s');
Ag = imfilter(Ar, g);

subplot(1,3,1)
imshow(Ap);
title('Prewitt filter');

subplot(1,3,2)
imshow(As);
title('Sobel filter 90º Roateted');

subplot(1,3,3);
imshow(Ag);
title('Gauusian filter');
sgtitle('Kernel filters') 

% Apply edge detection before appling gaussian kernel 
A = imfilter(Ag, p);
figure
subplot(1,2,1)
imshow(A);
title('Gaussian kernel + edge detection')

subplot(1,2,2)
imshow(Ap)
title('Prewitt edge detection')





