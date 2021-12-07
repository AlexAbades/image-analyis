clc; clear all;
A = zeros(12,12);
A(9, (4:5)) = 1;
A(8, (3:7)) = 1;
A(7, (4:7)) = 1;
A(6, (5:8)) = 1;
A(5, (6:7)) = 1;

h = strel('disk', 1);
h2 = strel('disk', 1);
[I, n] = OpenClose('opening', A, h);


f = 5;
I = [3200, 2400];
CCD = [8,6];
g = 1000;


G = 10

B = CameraGeometry(g, f, I, CCD)

B.CameraFOV()
B.PixelSizeOnCCD(G)

% 
% B.RealSizeOnCCD(G) % Method called inside of PixelSizeOnCCD, aparently it works
% B.PixelSizeOnCCD(G)
% B.CCDtoReal(obj, B)
% B.SizegivenFOV(obj, theta)