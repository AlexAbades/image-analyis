function [x] = PointTrans(x,varargin)
%POINTTRANF Tranforms the point with the transformation matrix T 
%   T-> Transformation Matrix
%   x-> Point, must be a column vector

for i= 1:length(varargin)
    x = varargin{i}*x;
end
end