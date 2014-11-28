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

clear

%% Section 2: Projectivity

% Run the premade demo
demo_mosaic;

clear
%% 2.1: Projectivity Matrix

% Run demo with points specified (argument)
demo_mosaic_npoints(10);

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
m1coords = m1coords([1:2],:);
m2 = matches(2,:);
m2coords = F2(:,m2);
m2coords = m2coords([1:2],:);

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

% Get coordinates
m1 = matches(1,:);
m1coords = F1(:,m1);
m1coords = m1coords([1:2],:);
m2 = matches(2,:);
m2coords = F2(:,m2);
m2coords = m2coords([1:2],:);

% Get 4 points and make projection matrix
pcoords1 = m1coords(:,[2:5])'; % 2 to 5 are correct matches
pcoords2 = m2coords(:,[2:5])';
P = projectionMatrix(pcoords1, pcoords2);

% Transform to real coordinates and drop 3rd dimension (1's)
m2coords = P * [m1coords; ones(1, length(m1coords))];
for i = 1:length(m2coords)
    m2coords(:,i) = m2coords(:,i) ./ m2coords(3,i);
end
m2coords = m2coords([1:2],:);

% Plot images and matching points
figure('name','Visualizing own matches');
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