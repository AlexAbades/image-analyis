function LabelMap = CreateLabelMapFromAnnotations(I, LM)
% I--> Imgage
% LM--> .txt that has specified where is the location of the signal 

% Get the size of the image
Isize = size(I);
% Get the number of signals
nLM = size(LM,1);

% Number of signal, divided by 4 because we want to create squares or
% rectangles to identify the location of each corner of the signal.
nSquares = floor(nLM / 4);
% Initialization of a matrix of the same dimensions than I to improbe
% computation.
LabelMap = zeros(Isize(1),Isize(2),'uint8');

for S = 1:nSquares
    % % Gets the rows for each signal, they are sorted in the txt, the
    % first 4 rows are from the first signal, the following 4 rows from the
    % second and so on.
    ids = (S-1) * 4 + 1:(S-1) * 4 + 4; 
    % column component of the first ids
    cc = LM(ids,1);
    % row component from the ids
    rc = LM(ids,2);
    % creates a binary image that separates the blobs 
    BW = roipoly(I, cc, rc);
    % multiples the blob element by S so they have different labels.
    LabelMap = LabelMap + uint8(BW) * S;
end

