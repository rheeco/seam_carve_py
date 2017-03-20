function out = tobandw( x, thres )
%tobandw takes in an image x and outputs the new picture of the thresholded
%image

[m n] = size(x);

% Creating the empty arrays of histograms and densities to fill
bw_x = zeros(m,n);

for i=1:m
    for j=1:n
        if (x(i,j) > thres)
            bw_x(i,j) = 255;
        elseif (x(i,j) < thres)
            bw_x(i,j) = 0;
        end
    end
end

out = bw_x;

