%% BEELDVERWERKEN - LAB EXERCISE 4: Decting lines by Hough Transform

% COLLABORATORS:
% A.P. van Ree (10547320)
% T.M. Meijers (10647023)
% DATE:
% 8-12-2014

%% Section 2: Finding Lines using the Hough Transform

imgOrg = imread('shapes.png');
img = im2double(imgOrg);
img = rgb2gray(img);

Thresh = [inf(), 0.08];
nrho = 500;
ntheta = 500;
sigma = 0.7;

% test = canny(img, sigma, Thresh);
% imshow(test);

h = hough(img, Thresh, nrho, ntheta, sigma);
imshow(h);