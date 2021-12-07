function [M] = grayrunlength(s,D,l)
%GRAYRUNLENGTH Computes the algortithm gray run length. We can specify if
%it's 0 based (lower left corner) or 1 based (top left corner)
%   s-> string: 'upperleft' or ' lowerleft'
%   D-> Dimesions of the Image
%   l-> List of the 

% Initialize a list
t = [];
% Transform the list they provide into a matrix so we can recreate a list
% with the entire elements
l = reshape(l,2, [])';
% 1xD(1)*D(2)
for i = 1:size(l)
    for e = 1:l(i)
        t = [t l(i,2)];
    end
end

% reshape the list depending on the origin.
if strcmp(s,'upperleft')
    M = reshape(t,D(1),D(2))';
else
    N = reshape(t,D(1), D(2))';
    M = zeros(D);

    for i = 1:size(M)
        [R, ~] = size(M);
        c= R + 1 -i;
        M(c,:) = N(i,:);
    end
end

end