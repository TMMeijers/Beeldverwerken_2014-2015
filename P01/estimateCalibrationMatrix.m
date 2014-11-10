function [ P ] = estimateCalibrationMatrix( XYZ, ij )
% Calculates matrix to transform world to camera coordinates

    % Get seperate coordinate vectors
    X = XYZ(:, 1);
    Y = XYZ(:, 2);
    Z = XYZ(:, 3);
    % we cannot use x? and y? in Matlab because ? means transposed u = uv(:, 1);
    i = ij(:, 1);
    j = ij(:, 2);
    Ones = ones(size(X));
    Zeros = zeros(size(X));
    % Build matrix A
    Aoddrows = [X, Y, Z, Ones, Zeros, Zeros, Zeros, Zeros, -X.*i, -Y.*i, -Z.*i, -i];
    Aevenrows = [Zeros, Zeros, Zeros, Zeros, X, Y, Z, Ones, -X.*j, -Y.*j, -Z.*j, -j];
    A = [Aoddrows; Aevenrows];

    % SVD and obtain approximation to matrix M by taking last row of V
    [U,S,V] = svd(A);
    P = V(:,end);
    % Reshape into matrix with correct dimensions
    P = reshape(P, 4, 3);
    P = P';
end

