function [ path visual ] = getPathsSimple( origx, x )
% origx = 
% x = 

global visualx pathx

[M N] = size(x(:,:,1));
pathx = zeros(M,N);
visualx = x(:,:,1);
for i=1:M
    for j=1:N
       if (i==1)
           pathx = 0;
       elseif (i==M)
           if (j==1)
               n = visualx(i-1,j);
               ne = visualx(i-1,j+1);
               if (n-origx(i,j)==min(n-origx(i,j),ne-origx(i,j)))
                   visualx(i,j) = x(i,j) + visualx(i-1,j);
                   pathx(i,j) = 0;
               elseif (n-origx(i,j)~=min(n-origx(i,j),ne-origx(i,j)))
                   visualx(i,j) = x(i,j) + visualx(i-1,j+1);
                   pathx(i,j) = 1;
               end
           elseif (j==N)
               n = visualx(i-1,j);
               nw = visualx(i-1,j-1);
               if (n-origx(i,j)==min(n-origx(i,j),nw-origx(i,j)))
                   visualx(i,j) = x(i,j) + visualx(i-1,j);
                   pathx(i,j) = 0;
               elseif (n-origx(i,j)~=min(n-origx(i,j),ne-origx(i,j)))
                   visualx(i,j) = x(i,j) + visualx(i-1,j-1);
                   pathx(i,j) = -1;
               end
           else
               n = visualx(i-1,j);
               ne = visualx(i-1,j+1);
               nw = visualx(i-1,j-1);
               if (n-origx(i,j)==min(min(n-origx(i,j),ne-origx(i,j)),nw-origx(i,j)))
                   visualx(i,j) = x(i,j) + visualx(i-1,j);
                   pathx(i,j) = 0;
               elseif (n-origx(i,j)~=min(min(n-origx(i,j),ne-origx(i,j)),nw-origx(i,j)) && ne-origx(i,j)==min(min(n-origx(i,j),ne-origx(i,j)),nw-origx(i,j)))
                   visualx(i,j) = x(i,j) + visualx(i-1,j+1);
                   pathx(i,j) = 1;
               elseif (n-origx(i,j)~=min(min(n-origx(i,j),ne-origx(i,j)),nw-origx(i,j)) && ne-origx(i,j)~=min(min(n-origx(i,j),ne-origx(i,j)),nw-origx(i,j)))
                   visualx(i,j) = x(i,j) + visualx(i-1,j-1);
                   pathx(i,j) = -1;
               end
           end
       else
           if (j==1)
               n = visualx(i-1,j);
               ne = visualx(i-1,j+1);
               if (n-origx(i,j)==min(n-origx(i,j),ne-origx(i,j)))
                   visualx(i,j) = x(i,j) + visualx(i-1,j);
                   pathx(i,j) = 0;
               elseif (n-origx(i,j)~=min(n-origx(i,j),ne-origx(i,j)))
                   visualx(i,j) = x(i,j) + visualx(i-1,j+1);
                   pathx(i,j) = 1;
               end
           elseif (j==N)
               n = visualx(i-1,j);
               nw = visualx(i-1,j-1);
               if (n-origx(i,j)==min(n-origx(i,j),nw-origx(i,j)))
                   visualx(i,j) = x(i,j) + visualx(i-1,j);
                   pathx(i,j) = 0;
               elseif (n-origx(i,j)~=min(n-origx(i,j),nw-origx(i,j)))
                   visualx(i,j) = x(i,j) + visualx(i-1,j-1);
                   pathx(i,j) = -1;
               end
           else
               n = visualx(i-1,j);
               ne = visualx(i-1,j+1);
               nw = visualx(i-1,j-1);
               if (n-origx(i,j)==min(min(n-origx(i,j),ne-origx(i,j)),nw-origx(i,j)))
%                    disp('n is smallest');
                   visualx(i,j) = x(i,j) + visualx(i-1,j);
                   pathx(i,j) = 0;
               elseif (n-origx(i,j)~=min(min(n-origx(i,j),ne-origx(i,j)),nw-origx(i,j)) && ne-origx(i,j)==min(min(n-origx(i,j),ne-origx(i,j)),nw-origx(i,j)))
%                    disp('ne is smallest');
                   visualx(i,j) = x(i,j) + visualx(i-1,j-1);
                   pathx(i,j) = 1;
               elseif (n-origx(i,j)~=min(min(n-origx(i,j),ne-origx(i,j)),nw-origx(i,j)) && ne-origx(i,j)~=min(min(n-origx(i,j),ne-origx(i,j)),nw-origx(i,j)))
%                    disp('nw is smallest');
                   visualx(i,j) = x(i,j) + visualx(i-1,j+1);
                   pathx(i,j) = -1;
               end
           end
       end
       
    end
end

imwrite(uint8(stretch(visualx)), 'seamWeights.png','png');
imwrite(uint8(stretch(pathx)), 'seamPaths.png','png');
path = pathx;
visual = visualx;
