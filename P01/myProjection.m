function projection = myProjection(image, x1, y1, x2, y2, x3, y3, x4, ...
                                   y4, M, N, method)
    % Empty target matrix, original and projection coordinates
    projection = zeros(N, M); 
    XY = [[0, 0]; [N, 0]; [0, M]; [N, M]];
    UV = [[x1,y1];[x2,y2];[x3,y3];[x4,y4]];
    
    % Obtain projection matrix and loop over it
    P = createProjectionMatrix(XY, UV);
    for xIndex = 1:M
        for yIndex = 1:N
            % Vector for coordinates, apply projection
            i = [yIndex, xIndex, 1]';
            v = P * i;
            
            % Obtain real coordinates and store in x and y
            v = v / v(3);
            x = v(2);
            y = v(1);
            
            % Now obtain pixel value
            projection(yIndex , xIndex) = pixelValue(image, x, y, method, 'constant');
        end 
    end
    
end
 

