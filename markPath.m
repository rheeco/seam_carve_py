function out = markPath( row,col,path,x )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

[height width] = size(x);
H = height;
outx = x;
while (H>1)
    if     (path(row,col) == -1)
        row = row-1;
        col = col-1;
        outx(row,col) = Inf;
        H = H-1;
    elseif (path(row,col) == 0)
        row = row-1;
        outx(row,col) = Inf;
        H = H-1;
    elseif (path(row,col) == 1)
        row = row-1;
        col = col+1;
        outx(row,col) = Inf;
        H = H-1;
    end
end

out = outx;
imwrite(uint8(out), 'showSeam.png','png');