%% BEELDVERWERKEN - LAB EXERCISE 4: Decting lines by Hough Transform

% COLLABORATORS:
% A.P. van Ree (10547320)
% T.M. Meijers (10647023)
% DATE:
% 15-12-2014

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                Section 2: Principal Component Analysis                %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Subsection 2.1: Implementing the PCA algorithm
% REMARK: ALWAYS RUN THIS SECTION BEFORE OTHER SUBSECTIONS OF 2

% Close and clear all previous images and variables
close all;
clear all;

% Load and read data
load('omni.mat');
[img_size, train_exmpls, ~, X_trn, ~, ~, ~] = parse_data(images);

% number of eigenimages and weights wanted
k = 50;

% Run the PCA algorithm
[E, G, D] = pca(X_trn, k);

% Clear all except needed variables for subsections of 2
clearvars -except images E G D k img_size train_exmpls X_trn

%% Subsection 2.2: Plot the 9 most important vectors

% Show the 9 most significant eigenimages in E (already sorted)
figure('name','Question 2.2: Plot the 9 first PCA vectors');
for i = 1:9
    subplot(3, 3, i);
    % Reshape to original img dimensions
    imshow(reshape(E(i,:), img_size), []);
end % end for i = pca vector
    
clearvars -except images E G D k img_size train_exmpls X_trn

%% Subsection 2.3: Plot eigenvalues of PCA components
% REMARK: For plotting the first 50 eigenvalues make sure k = 50

figure('name','Question 2.3a: Plot the eigenvalues');
plot(1:k, sum(D), '-bo', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', ...
    'r', 'MarkerSize', 5);
% Answer: When k = 100 and we zoom in on the graph, there are significant 
% decreases around k = 1, k = 5, k = 10, k = 30 and k = 50. It would be 
% logical to choose one of these k's, depending on the problem and accuracy 
% wanted. We will stick with 50.

% Generate random index
random_ind = randi([1 train_exmpls], 1, 1);
% The G we want to find a close match for
orig_G = G(random_ind,:);
% Calculate euclidean distance
distance = sqrt(sum(bsxfun(@minus, G, orig_G).^2, 2));
% Sort and get indices of distances
[~, index] = sort(distance);
% Now plot original image and next best match
figure('name','Question 2.3b1: Find next best match (PCA)');
subplot(1, 2, 1);
imshow(images{1, index(1)}.img);
title('Original Image');
subplot(1, 2, 2);
imshow(images{1, index(2)}.img);
title('Closest Image');

clearvars -except images E G D k img_size train_exmpls X_trn

%% Subsection 2.4: Timing PCA versus naive image comparison

% Run comparison on all examples with the PCA algorithm
tic;
for i = 1:train_exmpls
    orig_G = G(i,:);
    % Euclidean distance
    distance = sqrt(sum(bsxfun(@minus, G, orig_G).^2, 2));
    % Get indices for matched images
    [~, index] = sort(distance);
end % end for i = data example
time_pca = toc;

% Run comparison on all examples with naive image comparison
tic;
for i = 1:train_exmpls
    orig_img = X_trn(i,:);
    % Euclidean distance
    distance = sqrt(sum(bsxfun(@minus, X_trn, orig_img).^2, 2));
    % Get indices for matched images
    [~, index] = sort(distance);
end % end for i = data example
time_naive = toc;

% Get relative effectiveness
ratio = time_naive / time_pca;

% Print answer
fprintf('\nQuestion 2.4: time naive = %.4f\t\ttime pca = %.4f\n', ...
        time_naive, time_pca);
fprintf('The PCA algorithm is %.2f times as fast as the naive method.\n', ratio);

clearvars -except images E G D k img_size train_exmpls X_trn

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%             Section 3: Positioning with Nearest Neighbour             %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Subsection 3.1: Projecting onto the PCA components
% REMARK: ALWAYS RUN THIS SECTION BEFORE OTHER SUBSECTIONS OF 3

% Close and clear all previous images and variables
close all;
clear all;

% Load and read data
load('omni.mat');
[img_size, train_exmpls, test_exmpls, X_trn, coords_trn, ...
    X_tst, coords_tst] = parse_data(images);

% number of eigenimages and weights wanted
k = 100;
error_margin = 150; % Distance units for correct match (from assignment)

% Run the PCA algorithm
[E, G_trn, ~] = pca(X_trn, k);
% G of trianing set already obtained in the pca functions

% Project data of test set on trianed eigenimages
X_tst_mean = mean(X_tst);
X_tst_norm = bsxfun(@minus, X_tst, X_tst_mean);
G_tst = (E * X_tst_norm')';

correct = 0;
% First calculate accuracy on naive image comparison
for i = 1:test_exmpls
    img = X_tst(i,:);
    % Euclidean distance
    distance = sqrt(sum(bsxfun(@minus, X_trn, img).^2, 2));
    % Get indices for matched images
    [d, index] = sort(distance);
    dist = sqrt(sum((coords_tst(i,:) - coords_trn(index(1),:)).^2));
    if dist < error_margin;
        correct = correct + 1;
    end % end if position is correct
end % end for i = data example
naive_acc = correct * 100 / test_exmpls;

% Now find matches and keep track of correct matches
correct = 0;
for i = 1:test_exmpls
    img = G_tst(i,:);
    % Euclidean distance
    distance = sqrt(sum(bsxfun(@minus, G_trn, img).^2, 2));
    % Get indices for matched images
    [~, index] = sort(distance);
    dist = sqrt(sum((coords_tst(i,:) - coords_trn(index(1),:)).^2));
    if dist < error_margin;
        correct = correct + 1;
    end % end if position is correct
end % for i = test example
% Calculate accuracy to PCA and compare to naive accuracy
pca_acc = correct * 100 / test_exmpls;
rel_acc = pca_acc * 100 / naive_acc;

% Print answer
fprintf('\nQuestion 3.1:\nNaive acc. =\t%.2f%%\nPCA acc. =\t\t%.2f%%\nRelative acc. =\t%.2f%%\n', ...
        naive_acc, pca_acc, rel_acc);


% Clear all except needed variables for subsections of 3
clearvars -except images E G_tst G_trn k img_size train_exmpls test_exmpls ...
    X_trn coords_trn X_tst coords_tst

%% Subsection 3.2: Black Borders

% Removing the black borders around the images would improve the results,
% because these are seen as features of certain images but are not
% relavant. For example, the borders could mean that the images have the
% same angle of rotation but are actually very different images. Still,
% they would get some amount of correlation.

%% Subsection 3.3: Number of PCA Components

% number of eigenimages and weights wanted
k = [1 10:10:290 299];
error_margin = 150; % Distance units for correct match (from assignment)
pca_acc = zeros(1, length(k));

% Project data of test set on trianed eigenimages
X_tst_mean = mean(X_tst);
X_tst_norm = bsxfun(@minus, X_tst, X_tst_mean);

for j = 1:length(k)
    [E, G_trn, ~] = pca(X_trn, k(j));
    G_tst = (E * X_tst_norm')';
    % Now find matches and keep track of correct matches
    correct = 0;
    for i = 1:test_exmpls
        img = G_tst(i,:);
        % Euclidean distance
        distance = sqrt(sum(bsxfun(@minus, G_trn, img).^2, 2));
        % Get indices for matched images
        [~, index] = sort(distance);
        dist = sqrt(sum((coords_tst(i,:) - coords_trn(index(1),:)).^2));
        if dist < error_margin;
            correct = correct + 1;
        end % end if position is correct
    end % for i = test example
    % Calculate accuracy to PCA and compare to naive accuracy
    pca_acc(j) = correct * 100 / test_exmpls;
end % end for j = vary k

% Print accurcies vs pca features
% fprintf('\nQuestion 3.3:\n');
% for i = 1:length(k)
%     fprintf('PCA Features = %i\t\tPCA acc. = %.2f%%\n', k(i), pca_acc(i));
% end % end for i = print

% Plot the obtained accuracies and values for k
figure('name','Question 3.3: PCA Features vs. Accuracy');
plot(k, pca_acc, '-bo', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r', ...
    'MarkerSize', 5);
ylabel('% PCA Accuracy');
xlabel('# PCA Features');
set(gca,'YLim',[0 100]);
set(gca,'XLim',[0 300]);

clearvars -except images E G_tst G_trn k img_size train_exmpls test_exmpls ...
    X_trn coords_trn X_tst coords_tst

%% Subsection 3.4: Nearest Neighbour

% Skipping the PCA and using only nearest neighbour works, but takes a very
% long time. It is in fact more accurate than PCA, but about 230 times as
% slow. This is all displayed in the exercises before this one. For
% checking the time please refer to subsection 2.4. For the difference in
% accuracy refer to subsection 3.1.