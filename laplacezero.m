function out = laplacezero( x )
%laplacezero takes in an image x and produces the filtered version of it

[m n] = size(x);

% Creating an empty matrix for the filtered image of x, lz_x
lz_x = zeros(m,n);

% Defining the kernel
kernel = [0 1 0;1 -4 1;0 1 0];
%kernel = [1 1 1;1 -8 1;1 1 1];

[krow kcol] = size(kernel);

% Creating the new filtered image lz_x
for i=1+ceil(krow/2):m-ceil(krow/2)
    for j=1+ceil(kcol/2):n-ceil(kcol/2)
        window = double(x(i-floor(krow/2)-1:i+floor(krow/2)-1,...
            j-floor(kcol/2)-1:j+floor(kcol/2)-1));
        convolu = window.*kernel;
        c_sum = sum(convolu(:));
        lz_x(i,j) = c_sum;
    end
end
imwrite(uint8(lz_x),'seamIntensity.png','png');

% threshold = 21;
% lzero_x = zeros(m,n);
% kern_x = 3;
% kern_y = 3;
% for i=1:m-kern_y;
%     for j=1:n-kern_x;
%         min = realmax;
%         max = -1*realmax;
%         for k=1:kern_y
%             for l=1:kern_x
%                 val = lz_x(i+k,j+l);
%                 if (val<min)
%                     min = val;
%                 elseif (val>max)
%                     max=val;
%                 end
%             end
%         end
%         if (min < (-1*threshold)) && (max > threshold)
%             lzero_x(i,j) = 255;
%         else
%             lzero_x(i,j) = 0;
%         end
%     end
% end

% zero_x = stretchlzero(lzero_x);
out = lz_x;

