% testing testing

function seamCarveSimple( )

global visual path

% Prompt user for image
im= input('Enter file name for your image: ','s');
x = imread(im);
% Display height and width for user to see
[H W k] = size(x);
xcopy = double(x); % in case you want to mask your image
str1 = ['Height: ', num2str(H)]; str2 = ['Width: ', num2str(W)];
disp(str1); disp(str2);

% Option for masking an image
carveOut = input('Do you want to cut out an object with a mask? (No - 0; Yes - 1): ','s');
carveOut = str2double(carveOut);
if (carveOut==1)
    maskIm = input('Enter file name of your mask: ','s');
    mask = imread(maskIm);
    mask = double(mask);
    imwrite(mask,'mask1.png','png');
    [c1 c2] = findW(mask(:,:,1));
    newW = W - (c2-c1+1);
    newH = input('New height: ','s');
    
    [mrow mcol] = size(mask(:,:,1));
    for i=1:mrow
        for j=1:mcol
            for l=1:k
                if mask(i,j,l)<255
                    mask(i,j,l) = -10000;
                else
                    mask(i,j,l) = 100;
                end
            end
        end
    end
    mask = double(mask);
    imwrite(mask,'mask2.png','png');

    for i=1:k
        xcopy(:,:,i) = xcopy(:,:,i).*mask(:,:,i);
    end
    imwrite(xcopy,'mask3.png','png');
    
    % Determining how much to carve/add
    rowToSeam = H - str2double(newH);
    colToSeam = W - newW;
elseif (carveOut==0)
    % Prompt user to input new width and height
    newH= input('New height: ','s');
    newW= input('New width: ','s');

    % Determining how much to carve/add
    rowToSeam = H - str2double(newH);
    colToSeam = W - str2double(newW);
end

% First deal with columns
seamx = double(xcopy);
seamx = double(seamx);  
columnsPrev = colToSeam;
columnsLeft = abs(colToSeam);

count = 0;  % 0 indicates carving columns
            % 1 indicates carving rows

% Display true size of image
cNum = input('Add/cut columns manually? (No - 0; Yes - 1): ','s');
carveNum = str2double(cNum);

% How many columns to add/carve
addCols=0;
if (columnsPrev>0)        % cut columns
    addCols = 1;
elseif (columnsPrev<0)    % add columns
    addCols = 0;
end

while (columnsLeft>0 && count < 2)
    [H W k] = size(seamx);
    gradient_x = zeros(H,W);

    % If there is a user input
    if (carveNum==0)
        gradient_x = laplacezero(seamx(:,:,1));
        imwrite(uint8(gradient_x),'seam_grad.png','png');
    elseif (carveNum==1)
        while (carveNum==1)       
            image(x); axis image
            gradient_x = laplacezero(seamx(:,:,1));
            imwrite(uint8(gradient_x),'seam_grad.png','png');
            % Use ginput to select locations to carve p = x,y
            p = ginput(1);
            xcoord = min(max(floor(p(1)),1),255);
            ycoord = min(max(floor(p(2)),1),255);
            gradient_x(ycoord, xcoord) = log(0);
            cNum = input('Add/cut columns/rows manually? (No - 0; Yes - 1): ','s');
            carveNum = str2double(cNum);
        end
    end

    [path visual] = getPathsMasks(seamx(:,:,1), gradient_x);
    
    % Find the minimum-valued pixel of the last row
    [Hnew Wnew knew] = size(seamx);
    lastRow = Hnew;
    minCol = 1;
    minVal = Inf;
    for i=1:Wnew
        if (visual(Hnew,i) < minVal)
            minCol = i;
            minVal = visual(Hnew,i);
        end
    end

    % Marking and adding/cutting the seam
    [seamM seamN seamK] = size(seamx);
    outx = zeros(seamM, seamN, seamK);
    origx = seamx;
    if addCols==0
        seam_x = zeros(seamM, seamN+1, seamK);
        for i=1:k
            seamx(lastRow,minCol,i) = Inf;
            outx(:,:,i) = markPath(lastRow, minCol, path, seamx(:,:,i));
            seam_x(:,:,i) = addPath(origx(:,:,i), outx(:,:,i));
            W = W + 1;
        end
    elseif addCols==1
        seam_x = zeros(seamM, seamN-1, seamK);
        for i=1:k
            seamx(lastRow,minCol,i) = Inf;
            outx(:,:,i) = markPath(lastRow, minCol, path, seamx(:,:,i));
            seam_x(:,:,i) = cutPath(outx(:,:,i));
            W = W - 1;
        end
    end
    
    columnsLeft = columnsLeft-1;
    seamx = seam_x;
    path = [];
    visual = [];
    gradient_x = [];
    
    % If we are done cutting out the columns and want to cut out rows
%     if (columnsLeft == 0 && count == 0 && carveNum == 1)
%         columnsLeft = 1;
    if (columnsLeft == 0 && count == 0 && carveNum == 0)
        % Rotating the image 90 degrees so the rows become columns
        oldseam_x = seam_x;
        [oldM oldN oldK] = size(seam_x);
        newseam_x = zeros(oldN, oldM, oldK);
        for i=1:k
            newseam_x(:,:,i) = oldseam_x(:,:,i)';
        end
        seam_x = newseam_x;
        seam_x = double(seam_x);
        seamx = seam_x;
        
        cNum = input('Add/Cut rows manually? (No - 0; Yes - 1): ','s');
        carveNum = str2double(cNum);

        % Next deal with the rows
        addCols=0;
        columnsPrev = rowToSeam;
        rowsLeft = abs(rowToSeam);
        if (columnsPrev>0)        % cut columns of rotated image
            addCols = 1;
            % maybe change back
            columnsLeft = rowsLeft;
        elseif (columnsPrev<0)    % add columns of rotated image
            addCols = 0;
            columnsLeft = rowsLeft;
        end
        seamxC = seamx;
        count = 1;
    % If we are done cutting out the rows as well
    elseif (columnsLeft == 0 && count == 1)
        count = 2;      % change the count so this while loop breaks
    end
end


%% Rotating the image back
oldseam_x = seam_x;
[oldM oldN oldK] = size(seam_x);
newseam_x = zeros(oldN, oldM, oldK);
for i=1:k
    newseam_x(:,:,i) = oldseam_x(:,:,i)';
end
seam_x = newseam_x;
if (carveOut==1)
    seam_x = double(seam_x);
    for i=1:oldN
        for j=1:oldM
            for l=1:oldK
                seam_x(i,j,l) = seam_x(i,j,l)/100;
            end
        end
    end
end

%% Finished Carving!
imwrite(uint8(seam_x), 'seam_image.png', 'png');
