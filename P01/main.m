%% Assignment 2: Interpolation
% Helper functions written: 
%   - profile.m
%   - pixelValue.m
%   - inImage.m
%   - bilinear_interpol.m

x1 = 100;
y1 = 100;
x2 = 120;
y2 = 120;

n = 150;

a = imread( 'autumn.tif' );
a = rgb2gray(a);
a = im2double(a);

% Make two profiles
nearest_profile = profile(a, x1, y1, x2, y2, n, 'nearest');
linear_profile = profile(a, x1, y1, x2, y2, n, 'linear');

figure;

subplot(2, 1, 1);
hold on; % overlay on current figure
plot(linear_profile, 'b'); 
plot(nearest_profile, 'r');
title('profiles');
hold off;
subplot(2, 1, 2);
% plot line to show where we did sample the image
hold on;
imshow(a);
line([x1,x2],[y1,y2],'Color','g','LineWidth',2);
hold off;
title('image');

clear;

%% 3.1: Iteration based rotation
% Helper functions written: 
%   - rotateImageSlow.m
%   - newImageDimensions.m

% Example of the slow version of rotateImage
cameraman = imread('cameraman.tif');
cameraman = im2double(cameraman);

rotated_cameraman_linear = rotateImageSlow(cameraman, pi/8, ...
                                           'linear', 'constant', 1);
rotated_cameraman_nearest = rotateImageSlow(cameraman, pi/8, ...
                                            'nearest', 'constant', 1);

figure('name','Question 3.1: Iteration based rotation');
subplot(1, 3, 1);
imshow(cameraman);
title('original');
subplot(1, 3, 2);
imshow(rotated_cameraman_linear);
title('linear');
subplot(1, 3, 3);
imshow(rotated_cameraman_nearest);
title('nearest');

clear;

%% 3.2: Matrix based rotation
% Helper functions written: 
%   - rotateImageFast.m
%   - mat3xy.m

% Example of the fast version of rotateImage (matrix multiplication)
cameraman = imread('cameraman.tif');
cameraman = im2double(cameraman);

rotated_cameraman_linear = rotateImageFast(cameraman, pi/8, 'linear', 'constant', 1);
rotated_cameraman_nearest = rotateImageFast(cameraman, pi/8, 'nearest', 'constant', 1);

rotated_cameraman_linear2 = rotateImageFast(cameraman, pi/8, 'linear', 'constant', 0);
rotated_cameraman_nearest2 = rotateImageFast(cameraman, pi/8, 'nearest', 'constant', 0);


figure('name','Question 3.2: Matrix multiplication based rotation')
subplot(2, 3, 1);
imshow(cameraman);
title('original');
subplot(2, 3, 2);
imshow(rotated_cameraman_linear);
title('linear');
subplot(2, 3, 3);
imshow(rotated_cameraman_nearest);
title('nearest');
subplot(2, 3, 4);
imshow(rotated_cameraman_linear2);
title('linear');
subplot(2, 3, 5);
imshow(rotated_cameraman_nearest2);
title('nearest');

clear;

%% 3.3 Time interpolation methods
% Helper functions written: 
%   NO NEW FUNCTIONS

% compare running times of interpolation methods

cameraman = imread('cameraman.tif');
cameraman = im2double(cameraman);

tic;
rotated_cameraman_linear = rotateImageFast(cameraman, pi/8, 'linear', 'constant', 0);
time_linear = toc;
tic;
rotated_cameraman_nearest = rotateImageFast(cameraman, pi/8, 'nearest', 'constant', 0);
time_nearest = toc;

diff = abs(time_linear - time_nearest);

fprintf('linear: %f, nearest: %f, diff: %f\n', time_linear, time_nearest, diff);

clear;

%% 3.4 Measure efficience through least squares
% Helper functions written: 
%   - mse.m

% quality measure least square methods

cameraman = imread('cameraman.tif');
cameraman = rotateImageFast(im2double(cameraman), pi/6, 'linear', 'constant', 1);
cameraman = rotateImageFast(cameraman, -pi/6, 'linear', 'constant', 0);

% double rotate two times the camera man

rotated_linear_1 = rotateImageFast(cameraman, pi/6, 'linear', 'constant', 0);
rotated_linear_2 = rotateImageFast(rotated_linear_1, -pi/6, 'linear', 'constant', 0);

rotated_nearest_1 = rotateImageFast(cameraman, pi/6, 'nearest', 'constant', 0);
rotated_nearest_2 = rotateImageFast(rotated_nearest_1, -pi/6, 'nearest', 'constant', 0);

error_linear = mse(rotated_linear_2, cameraman);
error_nearest = mse(rotated_nearest_2, cameraman);
error_diff = abs(error_linear - error_nearest);

fprintf('error linear: %f, error nearest: %f, diff: %f\n', error_linear, error_nearest, error_diff);

figure('name','Question 3.4: Distance Measure')
subplot(1, 3, 1);
imshow(cameraman);
title('original');
subplot(1, 3, 2);
imshow(rotated_linear_2);
title('linear');
subplot(1, 3, 3);
imshow(rotated_nearest_2);
title('nearest');

clear;

%% 3.5 Solve the border problem in various ways
% NOTE: This question was asked at the end of chapter 2 but should be
% implemented here.
% Helper functions written: 
%   NO NEW FUNCTIONS

autumn = imread('autumn.tif');
autumn = rgb2gray(autumn);
autumn = im2double(autumn);

rotated_constant = rotateImageFast(autumn, pi/4, 'linear', 'constant', 1);
rotated_nearest = rotateImageFast(autumn, pi/4, 'linear', 'nearest', 1);
rotated_periodic = rotateImageFast(autumn, pi/4, 'linear', 'periodic', 1);

figure('name','Question 3.5: Different border methods')
subplot(1, 3, 1);
imshow(rotated_constant);
title('Constant border');
subplot(1, 3, 2);
imshow(rotated_nearest);
title('Nearest pixel border');
subplot(1, 3, 3);
imshow(rotated_periodic);
title('Periodic image border');

clear;


%% Assignment 4: Affine Transformations
% Helper functions written: 
%   - myAffine.m
%   - myAffineMatrix.m

% Load image and size
cameraman = imread('cameraman.tif');
cameraman = im2double(cameraman);
cs = size(cameraman);

% Pick points to be transformed
v1 = [cs(1)/2-10, 10];
v2 = [cs(1)/2-120, 100];
v3 = [cs(1)/2-20, 180];
v4 = v1 + (v3 - v2);

% Target image size
width = 100;
height = 100;

% Transform images
xx1 = v1(1);
yy1 = v1(2);
xx2 = v2(1);
yy2 = v2(2);
xx3 = v4(1);
yy3 = v4(2);
transformed_image = myAffine(cameraman, xx1, yy1, xx2, yy2, xx3, yy3, width, height, 'linear'); 
transformed_image2 = myAffineMatrix(cameraman, xx1, yy1, xx2, yy2, xx3, yy3, width, height, 'linear');

% Plot transformed and original image
figure('name','Q4: Affine transformation'); 
subplot(1, 3, 1);
imshow(transformed_image);
title('Transformed image (Iteration based)');
subplot(1, 3, 2);
imshow(transformed_image2);
title('Transformed image (Matrix based)');
subplot(1, 3, 3);
imshow(cameraman);
plotParallelogram(xx1, yy1, xx2, yy2, v3(1), v3(2));
title('Original image');

clear;

%% Assignment 5: Reprojecting Images
% Helper functions written: 
%   - myProjection.m
%   - myProjectionMatrix.m

% Please select in this order

%
%   (1)-----------(3)
%   |             |
%   |             |
%   |             |
%   |             |
%   (2)-----------(4)

% Show image to let user select 4 points
figure('name','Select coordinates');
img = imread('flyers.png');
img = im2double(rgb2gray(img));
imshow(img);
points = ginput(4);

x1 = points(1, 1);
y1 = points(1, 2);
x2 = points(2, 1);
y2 = points(2, 2);
x3 = points(3, 1);
y3 = points(3, 2);
x4 = points(4, 1);
y4 = points(4, 2);

% Target size of projection
width = 200;
height = 400;

% Slow version (Iteration based)
projected = myProjection(img, x1, y1, x2, y2, x3, y3, x4, y4, width, height, 'linear');
% Fast version (Matrix multiplication based)
projected2 = myProjectionMatrix(img, x1, y1, x2, y2, x3, y3, x4, y4, width, height, 'linear');

figure('name','Q5: Reprojecting Images');
subplot(1, 2, 1);
imshow(projected);
title('Reprojected (Iteration based)');
subplot(1, 2, 2);
imshow(projected2);
title('Reprojected (Matrix based)');

clear

%% Assignment 7.1 & 7.2: Camera projection
% Helper functions written: 
%   - estimateCalibrationMatrix.m

% Load coordinates and calculate projection matrix
load('calibrationpoints.mat');
estimated_matrix = estimateCalibrationMatrix(XYZ, xy);

% Test outcome, see terminal
v = [XYZ(end,:), 1];
projected = estimated_matrix * v';
projected = 1/projected(3) * projected;
real = xy(end,:)';

real
projected

clear

%% Assignment 8.1
% Helper functions written: 
%   - tranformCube.m

% Get image and load coordinates
img = imread('calibrationpoints.jpg');
load('calibrationpoints.mat');

% Calculate transformation matrix
estimated_matrix = estimateCalibrationMatrix(XYZ, xy);

% Create, transform and plot cubes on image
figure;
imshow(img);
hold on;

cubes = [[0,0,0];[5.5,0,3];[0, 7, 6]]';
for i = 1:3
    cube = createCube(1, cubes(:,i)');
    cube = transformCube(estimated_matrix, cube);
    subPlotFaces(cube);
end

clear

%% Assignment 8.2: Plotting cubes on different views
% Helper functions written: 
%   NO NEW FUNCTIONS

% Load images
img1 = imread('view1.jpg');
img2 = imread('view2.jpg');
img3 = imread('view3.jpg');
img4 = imread('view4.jpg');

% Cubes real world coordinates
cubes = [[0,0,0.5];[5,0,3.5];[0, 7, 6.5]]';

% Now load all 4 coordinate matrices and plot transformed cubes
figure('name','Plotting cubes for different views');
subplot(2, 2, 1);
imshow(img1);
title('view1.jpg'); 
hold on;
load('view1.mat');
estimated_matrix = estimateCalibrationMatrix(XYZ_view, xy_view1);
for i = 1:3 % number of points
    cube = createCube(1, cubes(:,i)');
    cube = transformCube(estimated_matrix, cube);
    subPlotFaces(cube);
end
hold off;

subplot(2, 2, 2);
imshow(img2);
title('view2.jpg'); 
hold on;
load('view2.mat');
estimated_matrix = estimateCalibrationMatrix(XYZ_view, xy_view2);
for i = 1:3 % number of points
    cube = createCube(1, cubes(:,i)');
    cube = transformCube(estimated_matrix, cube);
    subPlotFaces(cube);
end
hold off;

subplot(2, 2, 3);
imshow(img3);
title('view3.jpg'); 
hold on;
load('view3.mat');
estimated_matrix = estimateCalibrationMatrix(XYZ_view, xy_view3);
for i = 1:3 % number of points
    cube = createCube(1, cubes(:,i)');
    cube = transformCube(estimated_matrix, cube);
    subPlotFaces(cube);
end
hold off;

subplot(2, 2, 4);
imshow(img4);
title('view4.jpg'); 
hold on;
load('view4.mat');
estimated_matrix = estimateCalibrationMatrix(XYZ_view, xy_view4);
for i = 1:3 % number of points
    cube = createCube(1, cubes(:,i)');
    cube = transformCube(estimated_matrix, cube);
    subPlotFaces(cube);
end
hold off;

clear

