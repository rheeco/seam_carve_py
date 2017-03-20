function out = sobelseam( x )
%sobel takes in an image x and produces the filtered version of it

[m n] = size(x);

% Creating an empty matrix
sb_x = zeros(m,n);

% Defining the kernel n to s
kernel = [-1 -2 -1; 0 0 0; 1 2 1];
[krow kcol] = size(kernel);

% Creating the new filtered image sb_x
for i=1+ceil(krow/2):m-ceil(krow/2)
    for j=1+ceil(kcol/2):n-ceil(kcol/2)
        window = double(x(i-floor(krow/2)-1:i+floor(krow/2)-1,...
            j-floor(kcol/2)-1:j+floor(kcol/2)-1));
        convolu = window.*kernel;
        c_sum = sum(convolu(:));
        sb_x(i,j) = c_sum;
    end
end

% Defining the kernel e to w
kernel = [-1 0 1; -1 0 1; -1 0 1];

threshold = 21;
lzero_x = zeros(m,n);
kern_x = 3;
kern_y = 3;
for i=1:m-kern_y;
    for j=1:n-kern_x;
        min = realmax;
        max = -1*realmax;
        for k=1:kern_y
            for l=1:kern_x
                val = sb_x(i+k,j+l);
                if (val<min)
                    min = val;
                elseif (val>max)
                    max=val;
                end
            end
        end
        if (min < (-1*threshold)) && (max > threshold)
            lzero_x(i,j) = 255;
        else
            lzero_x(i,j) = 0;
        end
    end
end

imwrite(uint8(lzero_x),'seam_grad.png','png');

out = lzero_x;