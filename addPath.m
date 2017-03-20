function seam_x = addPath( origx, x )
%Seams on x are marked with Inf

[m n] = size(x);
seam = zeros(m,n+1);
for i=1:m
    for j=1:n
        if (x(i,j)==Inf)
            if j==1
                seam(i,j) = origx(i,j);
                seam(i,j+1) = origx(i,j);
                seam(i,j+2:n+1) = origx(i,j+1:n);
            elseif j==n
                seam(i,1:n-1) = origx(i,1:n-1);
                seam(i,n) = origx(i,n);
                seam(i,n+1) = origx(i,n);
            else
                seam(i,1:j-1) = origx(i,1:j-1);
                seam(i,j) = floor((origx(i,j-1)+origx(i,j)+origx(i,j+1))/3);
                seam(i,j+1:n+1) = origx(i,j:n);
            end
        end
    end
end
seam_x = seam;