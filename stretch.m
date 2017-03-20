% function for stretching the image
function y = stretch(x)

[m n k] = size(x);

newx = zeros(m,n);

% finding the min and max
for i=1:k
    xmin = min(min(x(:,:,i)));
    xmax = max(max(x(:,:,i)));
end

lowerthres = xmin;
upperthres = xmax;

slope = 256/(upperthres+abs(lowerthres));

for i=1:m
    for j=1:n
        newx(i,j) = slope*((x(i,j))+abs(lowerthres));
    end
end

y = newx;
