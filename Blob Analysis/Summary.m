clc; clear all;
%% Summary 

I16 = imread('CellData\Sample E2 - U2OS DAPI channel.tiff');
Im = im2uint8(I16); % Convert region into 8-bit grayscale
imshow(Im, [0 150]); title('DAPI Stained U2OS cell nuclei');
% imshow can be used to visualize specific gray scale ranges 

%  Original modified gray scale
figure
subplot(1,2,1)
imshow(Im, [15 75]);
title('15-75 Gray scale');
sgtitle('DAPI Stained U2OS cell nuclei');

% Otsu's Threshold
O = imbinarize(Im);
subplot(1,2,2)
imshow(O)
title("Otsu's Threshold") 

% Use a 8 neighbour filter to categorize different blobs
I = bwlabel(O, 8);

% Clear borders 
Ic = imclearborder(I);

stats = regionprops(Ic, 'Area');
areas = [stats(:,:).Area];
figure
subplot(1,2,1)
histogram(areas, 100) 
% Plot the thresholds in the graph
x = xline([31 160], '--r', {'Min Area', 'Max Area'});
x(1).LabelHorizontalAlignment = 'left';
x(2).LabelHorizontalAlignment = 'left';
axis square
% Select the nuclei with specific area
Icf = ismember(Ic, find(areas < 160 & areas > 31));
Icf = bwlabel(Icf);
% Check the areas
stats_f = regionprops(Icf, 'Area', 'Perimeter', 'Circularity');

subplot(1,2,2)
imagesc(Icf)
axis square
colormap(gca, jet);
title('Blobs after borders and areas filters')
xlabel("nuclei's areas") 
sgtitle('Analysis U2OS cell nuclei');

% Calculate some cell properties

area = [stats_f(:,:).Area];
perimeter = [stats_f(:,:).Perimeter];

f_circ = 2*sqrt(pi*area)./perimeter;
circularity = [stats_f(:,:).Circularity];



figure
subplot(2,2,1) 
histogram(area, 50, 'FaceColor', 'b')
title('Histogram agrupation')
xlabel("Nuclei's Area") 


% Area histogram
subplot(2,2,3) 
histogram(circularity, 50, 'FaceColor', 'b')
title('Histogram agrupation')
xlabel("Nuclei's circularity") 


% Scatter Plot
subplot(2,2,[2 4])
scatter(circularity, area, ...
                     'MarkerFaceColor', 'b',...
                     'MarkerEdgeColor', 'black')
title('Correlation between circularity and Area') 
xlabel("Nuclei's circulrity") 
ylabel('Area of a cell')
axis square
sgtitle('Analysis on nuclei cells') 