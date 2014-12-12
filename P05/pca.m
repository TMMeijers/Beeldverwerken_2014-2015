function [ E, G, D ] = pca( X, k )
%PCA Summary of this function goes here
%   Detailed explanation goes here
    
    % Get data mean and normalize
    X_mean = mean(X);
    X_norm = bsxfun(@minus, X, X_mean);

    % Get k most important eigenvectors
    [G, D] = eigs(X * X', k);
    % Obtain the most significant pixel weights
    E = G' * X_norm;
%     sum(sum(G == E * X_norm))
    
end

