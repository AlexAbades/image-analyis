I = imread('DTUSigns001.jpg');

T = readmatrix('DTUSigns001.txt');


B = CreateLabelMapFromAnnotations(I,T);


unique(B)

imagesc(B);
 
colormap(gca, hot);