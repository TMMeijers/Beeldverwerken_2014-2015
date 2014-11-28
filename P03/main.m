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

demo_mosaic_npoints(10);

clear;

%% Section 3: SIFT

img1 = imread('nachtwacht1.jpg');
img1 = rgb2gray(img1);
img1 = im2single(img1);
img2 = imread('nachtwacht2.jpg');
img2 = rgb2gray(img2);
img2 = im2single(img2);

data = vl_shift(img1);
data2 = vl_shift(img2);

features = vl_ubcmatch(data, data2);