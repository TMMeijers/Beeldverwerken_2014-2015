function [ E, G, D ] = pca( X, k )
% PCA is an implementation of the principal components algorithm. It uses
% the eigenspace of a dataset (images) to create a matrix consisting of the
% most important eigenimages describing features of the dataset.
%
% @INPUT ARGUMENTS:
% - X = a M by N matrix with M data samples with N features
% - k = the number of principal components wanted in E and G
%
% @RETURNS:
% - E = a k by N matrix consisiting of k eigenimages
% - G = a M by k matrix consisting of the weights of each eigenimage per
%       data sample
% - D = for the purpose of some questions in the assignment the diagonal
%       matrix is returned as well.

    % Get data mean and normalize
    X_mean = mean(X);
    X_norm = bsxfun(@minus, X, X_mean);

    % Calculate and normalize the covariance matrix
    C = X * X';
    C = C / size(C, 1) - 1;
    % Obtain weights for eigenimages and diagonal matrix
    [G, D] = eigs(C, k);
    % Obtain the eigenimages by projecting G on the data
    E = G' * X_norm;
    
end

