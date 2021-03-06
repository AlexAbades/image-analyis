
%% Train the sign finder algorithm
clear; close all; clc;

nSign = 9;
ImageName = sprintf('DTUSignPhotos/DTUSigns%03d.jpg', nSign);
LMName    = sprintf('DTUSignPhotos/DTUSigns%03d.txt', nSign);

%I = imread('DTUSigns065.jpg');
%LM = dlmread('DTUSigns065.txt');

I = imread(ImageName);
LM = dlmread(LMName);

LabelMap = CreateLabelMapFromAnnotations(I, LM);
RGBLabels = label2rgb(LabelMap);

figure;
subplot(1,2,1); imshow(I);  title('Input image')
subplot(1,2,2);imagesc(RGBLabels); axis image; title('Ground truth signs')

%imwrite(LabelMap, 'DTUSigns021_LabelMap.png');
%imwrite(LabelMap, 'DTUSigns065_LabelMap.png');

Ired   = I(:,:,1);
Igreen = I(:,:,2);
Iblue  = I(:,:,3);

L = 1;
redVals = double(Ired(LabelMap == L));
greenVals = double(Igreen(LabelMap == L));
blueVals = double(Iblue(LabelMap == L));

totVals = [redVals greenVals blueVals];

% Inspect histogram
nbins = 255;
figure;
hist(totVals,nbins);
h = findobj(gca,'Type','patch');
set(h(3),'FaceColor','r','EdgeColor','r','FaceAlpha',0.3,'EdgeAlpha',0.3);
set(h(2),'FaceColor','g','EdgeColor','g','FaceAlpha',0.3,'EdgeAlpha',0.3);
set(h(1),'FaceColor','b','EdgeColor','b','FaceAlpha',0.3,'EdgeAlpha',0.3);
xlim([0 255]);

ISigns = Ired > 150 & Ired < 200  & Igreen > 45 & Igreen < 80 & Iblue > 60 & Iblue < 100;
figure;
imshow(ISigns);
