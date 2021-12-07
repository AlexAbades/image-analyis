function [d] = Euclideandist(A,B)
%EUCLIDEANDIST Returns the Euclidean distance between 2 points
%   A -> Poin 1
%   B-> Point B
d = sqrt(sum((A - B).^2));
sprintf(num2str(d))
end