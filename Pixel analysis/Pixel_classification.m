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

%% Exercise 1 Write the pattern images
%{
Use roipoly to select representative regions of each of the seven
classes. For example, to select a region for the liver and extract the raw
16-bit values, you can do like:

roipoly: opens the image with imtool or something similar and it gives us
the option to select specific regions from that image. We want to select 
the different organs:
To specify the region double click.
%}
LiverROI = roipoly(I2);

% Now, we create a binary image with the values obtained from the previuous
% function. The selected regions have a value of 1 and the non selected 0.

imwrite(LiverROI, 'LiverROI.png');

% We create a column vector passing as a filter our binary image, all the
% selected regions, which have a value of 1, will be stored (theor original
% values) and the 0 will be set as background.
LiverVals = double(ct2(LiverROI));

% We have to create an array for each organ we want to detect.

% FAT
FatROI = roipoly(I2);
imwrite(FatROI, 'FatROI.png');
FatVals = double(ct2(FatROI));

% KIDNEY
KidneyROI = roipoly(I2);
imwrite(KidneyROI, 'KidneyROI.png');
KidneyVals = double(ct2(KidneyROI));

% SPLEEN
SpleenROI = roipoly(I2);
imwrite(SpleenROI, 'SpleenROI.png');
SpleenVals = double(ct2(SpleenROI));

% TRABECULAR BONE
TraboROI = roipoly(I2);
imwrite(TraboROI, 'TraboROI.png');
TraboVals = double(ct2(TraboROI));

% HARD BONE
HardboROI = roipoly(I2);
imwrite(HardboROI, 'HardboROI.png');
HardboVals = double(ct2(HardboROI));

% BACKGROUND
BackgROI = roipoly(I2);
imwrite(BackgROI, 'BackgROI.png');
BackgVals = double(ct2(BackgROI));

%% Once we've done it one time

LiverROI = imread('LiverROI.png');
LiverVals = double(ct2(LiverROI));

% FAT
FatROI = imread('FatROI.png');
FatVals = double(ct2(FatROI));

% KIDNEY
KidneyROI = imread('KidneyROI.png');
KidneyVals = double(ct2(KidneyROI));

% SPLEEN
SpleenROI = imread('SpleenROI.png');
SpleenVals = double(ct2(SpleenROI));

% TRABECULAR BONE
TraboROI = imread('TraboROI.png');
TraboVals = double(ct2(TraboROI));

% HARD BONE
HardboROI = imread('HardboROI.png');
HardboVals = double(ct2(HardboROI));

% BACKGROUND
BackgROI = imread('BackgROI.png');
BackgVals = double(ct2(BackgROI));

%% Exercise 2 Plot histograms and some statistic values 

figure
subplot(3,3,1)
histogram(LiverVals, length(LiverVals));
title('Liver Values')

subplot(3,3,2)
histogram(FatVals, length(FatVals));
title('Fat Values')

subplot(3,3,3)
histogram(KidneyVals, length(KidneyVals));
title('Kidney Values')

subplot(3,3,4)
histogram(SpleenVals, length(SpleenVals));
title('Spleen Values')

subplot(3,3,5)
histogram(TraboVals, length(TraboVals));
title('Trabecular bone Values')

subplot(3,3,6)
histogram(HardboVals, length(HardboVals));
title('Hard Bone Values')

subplot(3,3,7)
histogram(BackgVals, length(BackgVals));
title('Backgroung Values')
sgtitle('Histogram from selected areas')

% We can clearly see that the Liver, Kindney and spleen follow a gaussian
% distribution whereas fat has a some skewed distribution. The hard bone,
% seems that also follow a gauusian distribution, but has some noise in
% between, there are some values within the histogram that appear to be
% contant. Hard bone and background doesn't follow a distribution at all,
% but it can be said that have relatively larga and small values 
% respectively.

sprintf('Liver mean %g std %g min %g max %d',...
mean(LiverVals), std(LiverVals), ...
min(LiverVals), max(LiverVals))
L_stats = datastats(LiverVals);

fprintf('Fat statistics values are: \n\n');
F_stats = datastats(FatVals);
disp(F_stats);

fprintf('Kidney statistics values are: \n\n');
K_stats = datastats(KidneyVals);
disp(K_stats);

fprintf('Spleen statistics values are: \n\n');
S_stats = datastats(SpleenVals);
disp(S_stats);

fprintf('Trabecular bone statistics values are: \n\n');
T_stats = datastats(TraboVals);
disp(T_stats);

fprintf('Hard bone statistics values are: \n\n');
H_stats = datastats(HardboVals);
disp(H_stats);

fprintf('Background statistics values are: \n\n');
B_stats = datastats(BackgVals);
disp(B_stats);

%% Exercise 3 Gaussian distributions
%{
To create a fitted Gaussian distribution of one of our histograms
the following can be used

normpdf-->represents a Gaussian probability density function. It can for 
example be used to plot Gaussian distributions with given mean and standard
deviation.
%}

figure;
xrange = -1200:0.1:1200; % Fit over the complete Hounsfield range
pdfLiver = normpdf(xrange, mean(LiverVals), std(LiverVals));
S = length(LiverVals); % A simple scale factor
hold on;
histogram(LiverVals,xrange);
plot(xrange, pdfLiver * S,'r');
hold off;
xlim([-10, 100]);

% Fit gaussian distributions to all the values
pdfFat = normpdf(xrange, F_stats.mean, F_stats.std);
Sf = length(FatVals);

pdfKidney = normpdf(xrange, K_stats.mean, K_stats.std);
Sk = length(KidneyVals);

pdfSpleen = normpdf(xrange, S_stats.mean, K_stats.std);
Ss = length(SpleenVals);

pdfTrabo = normpdf(xrange, T_stats.mean, T_stats.std);
St = length(TraboVals);

pdfHard = normpdf(xrange, H_stats.mean, H_stats.std);
Sh = length(HardboVals);

pdfBack = normpdf(xrange, B_stats.mean, H_stats.std);
Sb = length(BackgVals);


plot(xrange, pdfLiver * S, xrange, pdfFat * Sf, xrange, pdfKidney * Sk,...
    xrange, pdfSpleen * Ss, xrange, pdfTrabo * St, xrange, pdfHard * Sh, ...
    xrange, pdfBack * Sb);
legend('Liver', 'Fat', 'Kidney', 'Spleen', 'Trabecular Bone', ...
       'Hard Bone', 'Background');


% We can distinguish between the Fat, Hard bone, and Trabecular bone very
% easily, while the gaussian distribution from the kidney, spleen and 
% liver overlap. Threfore, we can classidfy the last 3 organs as soft
% tissue category.

%% Minimum Distance Classification

% Assumptions: Each pixel follows a Gaussian distribution. 
% Following the previous assumption we can classify the pixel only using
% the mean for each category. Then, we just have to separate each category
% based only on the distance from the mean.
%  is only the location of the top of the fitted Gaussian that is used.


T1 = (B_stats.mean + F_stats.mean)/2;
T2 = (F_stats.mean + L_stats.mean)/2;
T3 = (L_stats.mean + T_stats.mean)/2;
T4 = (T_stats.mean + H_stats.mean)/2;

% Create a table with the values 

tablerange = [-255, T1, T2, T3, T4;
              T1, T2, T3, T4, 255]';

%% Ex 6 Pixel assigment

% LabelImage goes tghrough each pixel in the image and assigns the pixel to
% a class or category depending its value. If the value is less than T1
% (the threshold between background and the fat category it will be
% assigned to background. The same occurs on other categories. If a pixel
% is between T1 and T2 it will be assigned to Fat and so. 
% Function needs 6 inputs in total.

ILabel = LabelImage(ct2, T1, T2, T3, T4, T4); 
% Why we have to specify again the last one?

%% Ex 7 Visualize the classes
figure
imagesc(ILabel)
hcb=colorbar;
set(hcb,'YTick',[0,1,2,3,4,5]);
set(hcb,'YTickLabel',{'Class 0', 'Class 1','Class 2',...
'Class 3','Class 4','Class 5'});
axis square
title('Minimum Distance Classification')

%% Parametric classification 
% Estimate the class boundaries by finding the intersection of the PDF's. 
figure
plot(xrange, pdfLiver * S, xrange, pdfFat * Sf, xrange, pdfKidney * Sk,...
    xrange, pdfSpleen * Ss, xrange, pdfTrabo * St, xrange, pdfHard * Sh, ...
    xrange, pdfBack * Sb);
legend('Liver', 'Fat', 'Kidney', 'Spleen', 'Trabecular Bone', ...
       'Hard Bone', 'Background');
   

% Looking at the cumuluative histograms we can see that a good separation
% between fat and soft tissue could be -45.4
% A threshold for soft tissue and Trabecular bone could be 78.7 
% Threshold between trabecular bone and hard bone could be 356.7
% The threshold between background and fat could be -160.2

% Specify the thresholds
Tbackg = -160.2; 
Tfat = -45.4;
Tstissue = 78.7;
Ttbone = 356.7;

% Plot the thresholds in the graph
x = xline([Tbackg Tfat Tstissue Ttbone], '--r', {'Threshold Background', ...
    'Threshold Fat','Threshold soft tissue', 'Threshold Trabecular bone'});
x(1).LabelHorizontalAlignment = 'left';
x(2).LabelHorizontalAlignment = 'left';
x(3).LabelHorizontalAlignment = 'left';
x(4).LabelHorizontalAlignment = 'left';

% Create a table with the thresholds
T = [-255 Tbackg Tfat Tstissue Ttbone; 
     Tbackg Tfat Tstissue Ttbone 255]';  
% We have to specify the min value and the max value on the table in order
% to categorize the background and the hardbone. limits threshold


%% Ex 9 Create a classifier 

I2Label = LabelImage(ct2, Tbackg, Tfat, Tstissue, Ttbone, Ttbone);

% Visualize the new classes classifying the classes with the deviation 
figure
subplot(2,2,2)
imagesc(I2Label)
hcb=colorbar;
set(hcb,'YTick',[0,1,2,3,4,5]);
set(hcb,'YTickLabel',{'Class 0', 'Class 1','Class 2',...
'Class 3','Class 4','Class 5'});
axis square
title('Separation considering the std deviation')

% Minimum Distance Classification
subplot(2,2,1)
imagesc(ILabel)
hcb=colorbar;
set(hcb,'YTick',[0,1,2,3,4,5]);
set(hcb,'YTickLabel',{'Class 0', 'Class 1','Class 2',...
'Class 3','Class 4','Class 5'});
axis square
title('Minimum Distance Classification')

% Another option 

T1 = -161.2;
T2 = -15.8;
T3 = 97.4;
T4 = 241.9;

ILabel = LabelImage(ct2, T1, T2, T3, T4, T4);

subplot(2,2,3)
imagesc(ILabel)
hcb=colorbar;
set(hcb,'YTick',[0,1,2,3,4,5]);
set(hcb,'YTickLabel',{'Class 0', 'Class 1','Class 2',...
'Class 3','Class 4','Class 5'});
axis square
title('Threshold values 2')



%% DTU sign Classification 
% Build a classification in order to detect different objects in the image 
% Look out because in this case we have a RGB. we have to substract the
% representative regions of each component.

I = imread('DTUSigns055.JPG');

% Select the different categories for the first time and store them into
% images 


% Blue sign 
BSROI = roipoly(I); 
% It's simply a binary array that sets one to the values we've selected.
imwrite(BSROI, 'BluesignROI.png');

% Red sign
RSROI = roipoly(I);
imwrite(RSROI, 'RedsignROI.png');

% White car
WCROI = roipoly(I);
imwrite(WCROI, 'WhiteCarROI.png');

% Green leaves.
GLROI = roipoly(I);
imwrite(GLROI, 'GreenLeavesROI.png');

% Yellow grass.
YGROI = roipoly(I);
imwrite(YGROI, 'YellowGrassROI.png');

%% Read the pestored images 

% Blue sign 
BSROI = imread('BluesignROI.png');

% Red sign
RSROI = imread('RedsignROI.png');

% White car
WCROI = imread('WhiteCarROI.png');

% Green leaves.
GLROI = imread('GreenLeavesROI.png');

% Yellow grass.
YGROI = imread('YellowGrassROI.png');

%% Substract components and filter blue image
% Now to substract the values on each component we have to pass the binary
% matrix into each component 

% Separate each rgb compoenent
Ired = I(:,:,1);
Igreen = I(:,:,2);
Iblue = I(:,:,3);

% Select only the pixels of the previous selected area with roipoly
redVals = double(Ired(BSROI));
blueVals = double(Iblue(BSROI));
greenVals = double(Igreen(BSROI));

% We can plot the different compoenents with
figure;
totVals = [redVals greenVals blueVals];
nbins = 255;
hist(totVals,nbins); % WITH HISTOGRAM DOESN'T WORK WHY???
h = findobj(gca,'Type','patch');
set(h(3),'FaceColor','r','EdgeColor','r','FaceAlpha',0.3,'EdgeAlpha',0.3);
set(h(2),'FaceColor','g','EdgeColor','g','FaceAlpha',0.3,'EdgeAlpha',0.3);
set(h(1),'FaceColor','b','EdgeColor','b','FaceAlpha',0.3,'EdgeAlpha',0.3);
xlim([0 255]);

% Select the edges 
Rmin = 0;
Rmax = 10;
Gmin = 87;
Gmax = 109; 
Bmin = 179;
Bmax = 196;

BlueSign = Ired > Rmin & Ired < Rmax & Igreen > Gmin & Igreen < Gmax & ...
Iblue > Bmin & Iblue < Bmax;

figure
imshow(BlueSign)

%% Filter Red Sign 

% Select only the pixels of the previous selected area with roipoly
redVals = double(Ired(RSROI));
blueVals = double(Iblue(RSROI));
greenVals = double(Igreen(RSROI));

% We can plot the different compoenents with
figure;
totVals = [redVals greenVals blueVals];
nbins = 255;
hist(totVals,nbins); % WITH HISTOGRAM DOESN'T WORK WHY???
h = findobj(gca,'Type','patch');
set(h(3),'FaceColor','r','EdgeColor','r','FaceAlpha',0.3,'EdgeAlpha',0.3);
set(h(2),'FaceColor','g','EdgeColor','g','FaceAlpha',0.3,'EdgeAlpha',0.3);
set(h(1),'FaceColor','b','EdgeColor','b','FaceAlpha',0.3,'EdgeAlpha',0.3);
xlim([0 255]);


Rmin = 161;
Rmax = 176;
Gmin = 49.5;
Gmax = 65.9;
Bmin =52.8;
Bmax = 67;

RedSignal = Ired > Rmin & Ired < Rmax & Igreen > Gmin & Igreen < Gmax & ...
    Iblue > Bmin & Iblue < Bmax;

figure
imshow(RedSignal)

%% Filter White Car

% Select only the pixels of the previous selected area with roipoly
redVals = double(Ired(WCROI));
blueVals = double(Iblue(WCROI));
greenVals = double(Igreen(WCROI));

% We can plot the different compoenents with
figure;
totVals = [redVals greenVals blueVals];
nbins = 255;
hist(totVals,nbins); % WITH HISTOGRAM DOESN'T WORK WHY???
h = findobj(gca,'Type','patch');
set(h(3),'FaceColor','r','EdgeColor','r','FaceAlpha',0.3,'EdgeAlpha',0.3);
set(h(2),'FaceColor','g','EdgeColor','g','FaceAlpha',0.3,'EdgeAlpha',0.3);
set(h(1),'FaceColor','b','EdgeColor','b','FaceAlpha',0.3,'EdgeAlpha',0.3);
xlim([0 255]);

Rmin = 92;
Rmax = 171;
Gmin = 101;
Gmax = 177;
Bmin = 106;
Bmax = 175;

WhiteCar = Ired > Rmin & Ired < Rmax & Igreen > Gmin & Igreen < Gmax & ...
    Iblue > Bmin & Iblue < Bmax;

figure
imshow(WhiteCar)

%% Filter Green Leaves

% Select only the pixels of the previous selected area with roipoly
redVals = double(Ired(GLROI));
blueVals = double(Iblue(GLROI));
greenVals = double(Igreen(GLROI));

% We can plot the different compoenents with
figure;
totVals = [redVals greenVals blueVals];
nbins = 255;
hist(totVals,nbins); % WITH HISTOGRAM DOESN'T WORK WHY???
h = findobj(gca,'Type','patch');
set(h(3),'FaceColor','r','EdgeColor','r','FaceAlpha',0.3,'EdgeAlpha',0.3);
set(h(2),'FaceColor','g','EdgeColor','g','FaceAlpha',0.3,'EdgeAlpha',0.3);
set(h(1),'FaceColor','b','EdgeColor','b','FaceAlpha',0.3,'EdgeAlpha',0.3);
xlim([0 255]);

Rmin = 18;
Rmax = 68;
Gmin = 24;
Gmax = 72;
Bmin = 15;
Bmax = 40;

GreenLeaves = Ired > Rmin & Ired < Rmax & Igreen > Gmin & Igreen < Gmax & ...
    Iblue > Bmin & Iblue < Bmax;

figure
imshow(GreenLeaves)

%% Filter Yellow Grass

% Select only the pixels of the previous selected area with roipoly
redVals = double(Ired(YGROI));
blueVals = double(Iblue(YGROI));
greenVals = double(Igreen(YGROI));

% We can plot the different compoenents with
figure;
totVals = [redVals greenVals blueVals];
nbins = 255;
hist(totVals,nbins); % WITH HISTOGRAM DOESN'T WORK WHY???
h = findobj(gca,'Type','patch');
set(h(3),'FaceColor','r','EdgeColor','r','FaceAlpha',0.3,'EdgeAlpha',0.3);
set(h(2),'FaceColor','g','EdgeColor','g','FaceAlpha',0.3,'EdgeAlpha',0.3);
set(h(1),'FaceColor','b','EdgeColor','b','FaceAlpha',0.3,'EdgeAlpha',0.3);
xlim([0 255]);

Rmin = 154;
Rmax = 202;
Gmin = 131;
Gmax = 176;
Bmin = 87;
Bmax = 130;

YellowGrass = Ired > Rmin & Ired < Rmax & Igreen > Gmin & Igreen < Gmax & ...
    Iblue > Bmin & Iblue < Bmax;

figure
imshow(YellowGrass)


%% Exercise 13
clc; close all;
figure;
subplot(2,3,1)
imshow(BlueSign);
title('Blue Sign')

subplot(2,3,2)
imshow(RedSignal);
title('Red Sign')

subplot(2,3,3)
imshow(WhiteCar);
title('White Car')

subplot(2,3,4)
imshow(GreenLeaves);
title('Green Leaves')

subplot(2,3,5)
imshow(YellowGrass);
title('Yellow Grass')


% It can be seen that overall, the segmentations does
% find at least some of their intended objects. The 
% classifications that work the best are the sign 
% classifications. The grass and leaves classifications
% does also find some of the grasses and leaves but 
% because they are large patches that vary a lot in color
% based on lighting conditions, they are not completely
% classified. Also, some false positives are found here 
% as well. Lastly, the white car classification is the
% hardest type as white of course contains a mix of every
% color, meaning that trying to classify a white car 
% will also end up classifying a lot of other objects 
% wrongly.
% It is of course possible to improve on the 
% classification range limits to get a better 
% classification of objects.





