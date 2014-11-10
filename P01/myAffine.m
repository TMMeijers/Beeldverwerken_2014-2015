function [ new_img ] = myAffine( image, x1, y1, x2, y2, x3, y3, M, N, method)
    % Performs affine transformation on image (iteration based)
    
    new_img = zeros(N, M);
    % Obtain transformation matrix
    A = [0, 0, 1; N, 0, 1; 0, M, 1]';
    B = [x1, y1; x2, y2; x3, y3]';
    X = B / A;
    
    % Transform coordinate and obtain pixel value
    for xa = 1:M
        for ya = 1:N
            p = X * [ya, xa, 1]';
            y = p(1);
            x = p(2);
            new_img(ya, xa) = pixelValue(image, x, y, method, 'constant');
        end
    end
end

