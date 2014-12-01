%% BEELDVERWERKEN - LAB EXERCISE 3: MOSAICING BY SIFT

% COLLABORATORS:
% A.P. van Ree (10547320)
% T.M. Meijers (10647023)
% DATE:
% 1-12-2014

% SIFT EXPLAINED: http://www.aishack.in/tutorials/sift-scale-invariant-feature-transform-introduction/

%% Section 1: Introduction

% Check if vl_feat library installed correctly
vl_version verbose

clear;

%% Section 2: Projectivity

% Run the premade demo
demo_mosaic;

clear;

%% 2.1: Projectivity Matrix

% Run demo with points specified (argument)
demo_mosaic_npoints(6);

clear;

%% Section 3: Using vl_ubcmatch 
% "Use vl_feat to find matches for the Nachtwacht images. Visualize the
% matches."


% Load image
nachtwacht1 = imread('nachtwacht1.jpg');
img1 = rgb2gray(nachtwacht1);
img1 = im2single(img1);
nachtwacht2 = imread('nachtwacht2.jpg');
img2 = rgb2gray(nachtwacht2);
img2 = im2single(img2);

% Get descriptors and features, find matches
[F1, D1] = vl_sift(img1);
[F2, D2] = vl_sift(img2);
matches = vl_ubcmatch(D1, D2);

% Get coordinates
m1 = matches(1,:);
m1coords = F1(:,m1);
m1coords = m1coords(1:2,:);
m2 = matches(2,:);
m2coords = F2(:,m2);
m2coords = m2coords(1:2,:);

% Plot images and matching points
figure('name','Visualizing matches');
subplot(1, 2, 1);
imshow(nachtwacht1);
for i = 1:length(m1coords)
    text(m1coords(1, i), m1coords(2,i), sprintf('%02d',i), 'Color', 'red');
end
title('Nachtwacht1.jpg');

subplot(1, 2, 2);
imshow(nachtwacht2);
for i = 1:length(m2coords)
    text(m2coords(1, i), m2coords(2,i), sprintf('%02d',i), 'Color', 'red');
end
title('Nachtwacht2.jpg');

clear;

%% Section 3: Projection matrix to predict matches

% Load image
nachtwacht1 = imread('nachtwacht1.jpg');
img1 = rgb2gray(nachtwacht1);
img1 = im2single(img1);
nachtwacht2 = imread('nachtwacht2.jpg');
img2 = rgb2gray(nachtwacht2);
img2 = im2single(img2);

% Get descriptors and features, find matches
[F1, D1] = vl_sift(img1);
[F2, D2] = vl_sift(img2);
matches = vl_ubcmatch(D1, D2);

%%%%% PROJECTION WITH CORRECT MATCHDES %%%%%
% Get coordinates
m1 = matches(1,:);
m1coords = F1(:,m1);
m1coords = m1coords(1:2,:);
m2 = matches(2,:);
m2coords = F2(:,m2);
m2coords = m2coords(1:2,:);

% Get 4 points and make projection matrix
pcoords1 = m1coords(:,2:5)'; % 2 to 5 are correct matches
pcoords2 = m2coords(:,2:5)';
P = projectionMatrix(pcoords1, pcoords2);

% Transform to real coordinates and drop 3rd dimension (1's)
m2coords = P * [m1coords; ones(1, length(m1coords))];
for i = 1:length(m2coords)
    m2coords(:,i) = m2coords(:,i) ./ m2coords(3,i);
end
m2coords = m2coords(1:2,:);

% Plot images and matching points
figure('name','Visualizing own matches');
subplot(2, 2, 1);
imshow(nachtwacht1);
for i = 1:length(m1coords)
    text(m1coords(1, i), m1coords(2,i), sprintf('%02d',i), 'Color', 'red');
end
title('1. Correct matches projection');

subplot(2, 2, 2);
imshow(nachtwacht2);
for i = 1:length(m2coords)
    text(m2coords(1, i), m2coords(2,i), sprintf('%02d',i), 'Color', 'red');
end
title('2. Correct matches projection');

%%%%% PROJECTION WITH WRONG MATCHDES %%%%%
% Get coordinates
m1 = matches(1,:);
m1coords = F1(:,m1);
m1coords = m1coords(1:2,:);
m2 = matches(2,:);
m2coords = F2(:,m2);
m2coords = m2coords(1:2,:);

% Get 4 points and make projection matrix
pcoords1 = m1coords(:,[1 12 18 25])'; % 2 to 5 are correct matches
pcoords2 = m2coords(:,[1 12 18 25])';
P = projectionMatrix(pcoords1, pcoords2);

% Transform to real coordinates and drop 3rd dimension (1's)
m2coords = P * [m1coords; ones(1, length(m1coords))];
for i = 1:length(m2coords)
    m2coords(:,i) = m2coords(:,i) ./ m2coords(3,i);
end
m2coords = m2coords([1:2],:);

% Plot images and matching points
subplot(2, 2, 3);
imshow(nachtwacht1);
for i = 1:length(m1coords)
    text(m1coords(1, i), m1coords(2,i), sprintf('%02d',i), 'Color', 'red');
end
title('1. False matches projection');

subplot(2, 2, 4);
imshow(nachtwacht2);
for i = 1:length(m2coords)
    text(m2coords(1, i), m2coords(2,i), sprintf('%02d',i), 'Color', 'red');
end
title('2. False matches projection');

% Clarification: Ofcourse, when one uses four correct matches the correct
% matches are projected well. Incorrect matches are even projected of the
% image. 
% When one uses the wrong points, these get projected "correctly" but all 
% the other points are projected incorrectly, grouped together because of
% the wrong projection matrix.

clear;

%% Section 4: RANSAC

nachtwacht1 = imread('nachtwacht1.jpg');
img1 = rgb2gray(nachtwacht1);
img1 = im2single(img1);
nachtwacht2 = imread('nachtwacht2.jpg');
img2 = rgb2gray(nachtwacht2);
img2 = im2single(img2);

% Variables for RANSAC:
n = 4; % 4 points needed for model
err = 1; % error for inliers (euclidean pixel distance)
iter = 100; % number of iterations to find best model
margin = 0.5; % percentage of points which should be inliers to check model

% Obtain best fit (and transpose for T form)
best_fit = ransac(img1, img2, n, err, iter, margin)';

T = maketform('projective', best_fit/best_fit(3,3));

% CODE FROM MOSAIC DEMO
[x, y] = tformfwd(T,[1 size(nachtwacht1,2)], [1 size(nachtwacht1,1)]);

xdata = [min(1,x(1)) max(size(nachtwacht2,2),x(2))];
ydata = [min(1,y(1)) max(size(nachtwacht2,1),y(2))];
f12 = imtransform(nachtwacht1,T,'Xdata',xdata,'YData',ydata);
f22 = imtransform(nachtwacht2, maketform('affine', ...
    [1 0 0; 0 1 0; 0 0 1]), 'Xdata',xdata,'YData',ydata);
subplot(1,1,1);
imshow(max(f12,f22));