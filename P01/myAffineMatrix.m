function [ new_img ] = myAffineMatrix( image, x1, y1, x2, y2, x3, y3, M, N, method)
    % Performs affine transformation on image (Matrix multiplication based)

    % Both sets of points in matrices and obtain affine matrix
    A = [0, 0, 1; N, 0, 1; 0, M, 1]';
    B = [x1, y1; x2, y2; x3, y3]';
    X = B / A;
    
    % Transform coords and obtain pixel values
    new_coordinates = X * mat3xy(zeros(N, M));
    new_pixel_values = arrayfun(@(c1, c2) pixelValue(image, c2, c1, method, 'constant'), new_coordinates(1,:), new_coordinates(2,:));
    new_img = reshape(new_pixel_values, N, M);
end

