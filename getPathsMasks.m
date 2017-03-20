function [ path visual ] = getPathsMasks( origx, x )
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
               if (n==min(n,ne))
                   visualx(i,j) = origx(i,j) + visualx(i-1,j);
                   pathx(i,j) = 0;
               elseif (n~=min(n,ne))
                   visualx(i,j) = origx(i,j) + visualx(i-1,j+1);
                   pathx(i,j) = 1;
               end
           elseif (j==N)
               n = visualx(i-1,j);
               nw = visualx(i-1,j-1);
               if (n==min(n,nw))
                   visualx(i,j) = origx(i,j) + visualx(i-1,j);
                   pathx(i,j) = 0;
               elseif (n~=min(n,ne))
                   visualx(i,j) = origx(i,j) + visualx(i-1,j-1);
                   pathx(i,j) = -1;
               end
           else
               n = visualx(i-1,j);
               ne = visualx(i-1,j+1);
               nw = visualx(i-1,j-1);
               if (n==min(min(n,ne),nw))
                   visualx(i,j) = origx(i,j) + visualx(i-1,j);
                   pathx(i,j) = 0;
               elseif (n~=min(min(n,ne),nw) && ne==min(min(n,ne),nw))
                   visualx(i,j) = origx(i,j) + visualx(i-1,j+1);
                   pathx(i,j) = 1;
               elseif (n~=min(min(n,ne),nw) && ne~=min(min(n,ne),nw))
                   visualx(i,j) = origx(i,j) + visualx(i-1,j-1);
                   pathx(i,j) = -1;
               end
           end
       else
           if (j==1)
               n = visualx(i-1,j);
               ne = visualx(i-1,j+1);
               if (n==min(n,ne))
                   visualx(i,j) = origx(i,j) + visualx(i-1,j);
                   pathx(i,j) = 0;
               elseif (n~=min(n,ne))
                   visualx(i,j) = origx(i,j) + visualx(i-1,j+1);
                   pathx(i,j) = 1;
               end
           elseif (j==N)
               n = visualx(i-1,j);
               nw = visualx(i-1,j-1);
               if (n==min(n,nw))
                   visualx(i,j) = origx(i,j) + visualx(i-1,j);
                   pathx(i,j) = 0;
               elseif (n~=min(n,nw))
                   visualx(i,j) = origx(i,j) + visualx(i-1,j-1);
                   pathx(i,j) = -1;
               end
           else
               n = visualx(i-1,j);
               ne = visualx(i-1,j+1);
               nw = visualx(i-1,j-1);
               if (n==min(min(n,ne),nw))
%                    disp('n is smallest');
                   visualx(i,j) = origx(i,j) + visualx(i-1,j);
                   pathx(i,j) = 0;
               elseif (n~=min(min(n,ne),nw) && ne==min(min(n,ne),nw))
%                    disp('ne is smallest');
                   visualx(i,j) = origx(i,j) + visualx(i-1,j-1);
                   pathx(i,j) = 1;
               elseif (n~=min(min(n,ne),nw) && ne~=min(min(n,ne),nw))
%                    disp('nw is smallest');
                   visualx(i,j) = origx(i,j) + visualx(i-1,j+1);
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
