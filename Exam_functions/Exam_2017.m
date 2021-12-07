% Exam 2017 Image analyis

%% Problem 1 Point Tranformartion
% Compute the distance of the point 

A = [10,35];
B = [29,57];

T1 = [1 3; 2 2];
T2 = [7 3; 3 4];

A_fin = T2*T1*A'
B_fin = T2*T1*B'


distance = sum((A_fin - B_fin).^2)
sqrt(distance)

A_fin = PointTrans(A',T1,T2)
B_fin = PointTrans(B',T1,T2)

d = Euclideandist(A_fin,B_fin);


l = [3, 17, 5, 200, 3, 8, 1, 100, 1, 13, 5, 110, 1, 10, 4, 35, 2, 9];
l = reshape(l,2, [])'

t = []
for i = 1:size(l)
    for e = 1:l(i)
        disp(l(i,2))
        t = [t l(i,2)];
    end
end

M = reshape(t,5,5)';
N = zeros(5,5)
L = []

for i = 1:size(M)
    [R C] = size(M);
    c= R + 1 -i;
    disp(c);
    N(c,:) = M(i,:);
    L(c,:) = M(i,:);
    
end



length(l)/2
p = num2cell(l,9)

%% Problem 

D = [5,5];
l = [3, 17, 5, 200, 3, 8, 1, 100, 1, 13, 5, 110, 1, 10, 4, 35, 2, 9];


M = grayrunlength('lowerleft', D, l)


%% Gamma maping and prewit filter 

A = round([208 71 244 202 173 180; ...
           231 139 124 245 193 8; ...
           32 244 204 167 189 71; ...
           233 246 36 9 100 12; ...
           161 40 108 217 167 25; ...
           25 248 234 238 44 210].^1.28)


f = fspecial('prewitt')'

A = imfilter(A,f)


%% Template matching difference between 2 points correlation 
A = [203 192 127; 48 70 245; 125 173 87]

B = [173 87 178; 167 149 227; 41 57 245]

f = [212 234 192; 149 73 97;140 193 145]


corr = sum(sum(A.*f))-sum(sum(B.*f))

%% Normalized correlation

B = [173 87 178; 167 149 227; 41 57 245]
f = [212 234 192; 149 73 97;140 193 145]
corrB = sum(sum(B.*f))
Len_temp = sqrt(sum(sum(f.*f)))
Len_imB = sqrt(sum(sum(B.*B)))

normcorrA = corrB/(Len_imB*Len_temp)









