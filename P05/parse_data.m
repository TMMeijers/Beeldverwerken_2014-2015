function [ img_size, train_exmpls, test_exmpls, ...
    X_trn, coords_trn, X_tst, coords_tst ] = parse_data( images )
% PARSE_DATA is a helper function that reads the data needed for PCA and
% returns it in certain data structures.
%
% @INPUT ARGUMENTS:
% - images = a cell array with in each cell an image and a position
%
% @RETURNS:
% - img_size, train_exmpls, test_exmpls = Are all integers specifying
%       the dimensions of certain data structures
% - X_trn, coords_trn = The training data split up in data examples and
%       coupled coordinates
% - X_tst, coords_tst = The testing data split up in data examples and
%       coupled coordinates

    % Load and read data
    train_data = images(1, 1:300);
    test_data = images(1, 301:550);

    % Get dimensions
    img_size = size(train_data{1, 1}.img);
    d_length = prod(img_size);
    
    % Count and initialize data structure for training examples
    train_exmpls = length(train_data);
    X_trn = zeros(train_exmpls, d_length);
    coords_trn = zeros(train_exmpls, size(images{1, 1}.position, 2));
    
    % Count and initialize data structure for test examples
    test_exmpls = length(test_data);
    X_tst = zeros(test_exmpls, d_length);
    coords_tst = zeros(test_exmpls, size(images{1, 1}.position, 2));

    % Get image train data from cells into matrices
    for i = 1:train_exmpls
        cell = train_data{1, i};
        d = reshape(cell.img, 1, d_length);
        coords_trn(i,:) = cell.position;
        X_trn(i,:) = d;
    end % end for i = training example
    
    % Get image test data from cells into matrices
    for i = 1:test_exmpls
        cell = test_data{1, i};
        d = reshape(cell.img, 1, d_length);
        coords_tst(i,:) = cell.position;
        X_tst(i,:) = d;
    end % end for i = training example

end

