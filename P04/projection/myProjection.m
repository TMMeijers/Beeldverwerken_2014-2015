function [new_img] = myProjection(image, Xs, Ys, M, N, method)
% Applies projection (Matrix multiplication)
                     
    % Original points (UV) and target coordinates (projection)
    XY = [[0, 0]; [N, 0]; [0, M]; [N, M]];
    UV = [Xs; Ys]';
    
    % Obtain projection matrix and transform all coordinates
    P = createProjectionMatrix(XY, UV);
    D = mat3xy(zeros(N, M));
    new_coordinates = P * D;
    
    % Divide all x and y values by 3rd vector element to obtain "real"
    % coordinates
    last_row = new_coordinates(3,:);
    new_coordinates(1,:) = new_coordinates(1,:) ./ last_row;
    new_coordinates(2,:) = new_coordinates(2,:) ./ last_row;
    
    % Get pixel values and reshape into original matrix dimensions
    new_pixel_values = arrayfun(@(c1, c2) pixelValue(image, c2, c1, ...
        method, 'constant'), new_coordinates(1,:), new_coordinates(2,:));
    new_img = reshape(new_pixel_values, N, M);
    
end
 

