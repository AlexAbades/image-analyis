function [I, n] = CountCellNuclei(Im, lwA, hiA, lwC, hiC)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if nargin < 1
    error('Please add an Image')
elseif nargin < 2
    lwA = 49;
    hiA = 110;
    lwC = 0.91;
    hiC = 1.13;
end
% Binarize the image with Otsu's Threshold 
I_temp = imbinarize(Im);
%Categorize the different Blobs 
I_temp = bwlabel(I_temp, 8);
% Clear borders
I_temp = imclearborder(I_temp);
% Calculate basic properties 
stats = regionprops(I_temp, 'Area');
areas = [stats(:,:).Area];

% fGet the indeces where the BLOB area fulfill the conditions 
idx_area = find(areas < hiA & areas > lwA);

% Get from the image only the desired blobs 
I_temp = ismember(I_temp, idx_area);

% Categorize again the blobs so we can filter again on another 
I_temp = bwlabel(I_temp, 8);

% Calculate again the circularity from the nuceils
stats1 = regionprops(I_temp, 'Circularity');
f_circ = [stats1(:,:).Circularity];

% Get the indexes where the blob circularity fulfill the conditions
idx_circ = find(f_circ < hiC & f_circ > lwC);

% Get from the image only the desired blobs 
I = ismember(I_temp, idx_circ);

% Calculate again the number of blobs
I = bwlabel(I_temp, 8);

% Count number of Blobs
n = numel(unique(I));

end

