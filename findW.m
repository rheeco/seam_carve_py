function [c1 c2] = findW( x )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[H W] = size(x);
x= double(x);
c1 = -Inf;
c2 = -Inf;

for i=1:H
    for j=1:W
        if x(i,j)==0
            x(i,j) = -Inf;
        end
    end
end

for i=1:W
    if (min(x(:,i)==255)==0)   % there is a false statement!
        if c1==-Inf
            c1 = i;
        elseif (c1~=-Inf && c2==-Inf)
            c2 = i;
        elseif (c1~=-Inf && c2~=Inf)
            if i>c2
                c2 = i;
            end
        end
    end
end

