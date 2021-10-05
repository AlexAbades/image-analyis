clc; clear all;
%%
%{
The image we are going to work with is a DICOM image of a CT angiography
examination of the liver.
Another image will be uploaded, the same one but with a png format. We are
going to use the .dcm image to extract the pixel values while the png will
be used to separate the different regions, organs 
%}

ct2 = dicomread('CTangio2.dcm');
I2 = imread('CTAngio2Scaled.png');

%{
The goal is to label the different organs and structures seen in the image. 
• Background
• Fat
• Liver
• Kidney
• Spleen
• Trabecular bone
• Hard bone
%}

imshow(I2);

%{
Hounsfield unit 0 has an absorbance equal to water and a pixel with 
Hounsfield unit -1000.
%}

%% Exercise 1
%{
Use roipoly to select representative regions of each of the seven
classes. For example, to select a region for the liver and extract the raw
16-bit values, you can do like:
%}

% roipoli: opens the image with imtool or something similar and it givs us
% the option to select specific regions from that image, specifically we
% wan to select the different organs:
LiverROI = roipoly(I2);
% to specify the region double click.

% Now, we create a binary image with the values obtained from the previuous
% function. The selected regions have a value of 1 and the non selected 0
imwrite(LiverROI, 'LiverROI.png');

% We create a column vector passing as a filter our binary image, all the
% selected regions, which have a value of with value 1 will stored original values and the 0 will be
% set as background
LiverVals = double(ct2(LiverROI));

% check that the image has been stored correctly:
imshow(LiverVals)












