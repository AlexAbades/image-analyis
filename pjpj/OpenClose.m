function [A, n] = OpenClose(method, I, h1, h2)
%OPENING Performs the opening operation. Remember to pass the filter, we
%can use the streel function. (streel function to create the filter, two
%options, disk->corss shape, square-> square
%   I: Imatge that you want to open 
%   h: Filter
%   A: Opened Imatge
%   n: number of elements that have.


if nargin < 4
    h2 = h1;
    disp('Using same filter to erode and dilate')
end
    
if strcmp(method, 'opening')
    A = imdilate(imerode(I,h1), h2);
else
    A = imerode(imdilate(I,h1), h2);
end
n = length(find(A));

end

