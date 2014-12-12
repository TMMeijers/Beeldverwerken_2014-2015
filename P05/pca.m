function [ E, G, D ] = pca( X, k )
%PCA Summary of this function goes here
%   Detailed explanation goes here
    
    % Get data mean and normalize
    X_mean = mean(X);
    X_norm = bsxfun(@minus, X, X_mean);

    % Get k most important eigenvectors
    C = X * X';
    C = C / size(C, 1) - 1;
    [G, D] = eigs(C, k);
    % Obtain the most significant pixel weights
    E = G' * X_norm;
    
end

