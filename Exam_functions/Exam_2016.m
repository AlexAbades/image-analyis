A = zeros(12,12);
A(9, (4:5)) = 1;
A(8, (3:7)) = 1;
A(7, (4:7)) = 1;
A(6, (5:8)) = 1;
A(5, (6:7)) = 1;

h = strel('disk', 1);
h2 = strel('disk', 1);
[I, n] = OpenClose('opening', A, h);

