function seam_x = cutPath( x )
%Seams on x are marked with Inf

[m n] = size(x);
seam = zeros(m,n-1);
for i=1:m
    for j=1:n
        if (x(i,j)==Inf)
            if j==1
                seam(i,j:n-1) = x(i,j+1:n);
            elseif j==n
                seam(i,1:n-1) = x(i,1:n-1);
            else
                seam(i,1:j-1) = x(i,1:j-1);
                seam(i,j:n-1) = x(i,j+1:n);
            end
            
        end
    end
end

seam_x = seam;