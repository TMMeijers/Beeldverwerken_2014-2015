%% BEELDVERWERKEN - LAB EXERCISE 4: Decting lines by Hough Transform

% COLLABORATORS:
% A.P. van Ree (10547320)
% T.M. Meijers (10647023)
% DATE:
% 15-12-2014

%% Section 2: Principal Component Analysis

% Load and read data
load('omni.mat');
train_data = images(1, 1:300);
test_data = images(1, 301:550);

% Get problem dimensions and initialize data structures
img_size = size(train_data{1, 1}.img);
d_length = prod(img_size);
data_examples = length(train_data);
X = zeros(data_examples, d_length);
coords = zeros(data_examples, size(images{1, 1}.position, 2));

% Get image data from cells into matrices
for i = 1:data_examples
    cell = train_data{1, i};
    d = reshape(cell.img, 1, d_length);
    coords(i,:) = cell.position;
    X(i,:) = d;
end % end for i = training example

% number of eigenimages and weights wanted
k = 50;

% Q2.1: Implement PCA
tic;
[E, G, D] = pca(X, k);
time_pca = toc; % Time for Q2.4

% % Q2.2: Plot the 9 most important vectors
% figure('name','Question 2.2: Plot the 9 first PCA vectors');
% for i = 1:9
%     subplot(3, 3, i);
%     imshow(reshape(E(i,:), img_size), []);
% end % end for i = pca vector
%     
% % Q2.3: Plot eigenvalues of PCA components
% % REMARK: For the first 50 make sure k = 50
% figure('name','Question 2.3a: Plot the eigenvalues');
% plot(1:k, sum(D), '-bo', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', ...
%     'r', 'MarkerSize', 5);
% % Answer: When k = 100 and we zoom in on the graph, there are significant 
% % decreases around k = 1, k = 5, k = 10, k = 30 and k = 50. It would be 
% % logical to choose one of these k's, depending on the problem and accuracy 
% % wanted. We will stick with 50.

% % Now couple the coordinates, test if G(i) approximates images(i)
% figure;
% subplot(1, 2, 1);
% imshow(images{1, 201}.img);
% subplot(1, 2, 2);
% imshow(reshape(G(201,:) * E, img_size), []);
% % Apparently it does

% Now take a random image and find the next best match (so not itsself)
index = randi([1 data_examples], 1, 1);
test_G = G(index,:);
% Calculate euclidean distance
distance = sqrt(sum(bsxfun(@minus, G, test_G).^2, 2));
% Sort and find best match (dist = 0, image = original) and next best
[~, index] = sort(distance);
figure('name','Question 2.3b: Find next best match');
subplot(1, 2, 1);
imshow(images{1, index(1)}.img);
title('Original Image');
subplot(1, 2, 2);
imshow(images{1, index(2)}.img);
title('Closest Image');

% Q2.4: Timing PCA versus naive image comparison
tic;
for i = 1:data_examples
    img = X(i,:);
    
end % end for i = data example
time_naive = toc;

