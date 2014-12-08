%% BEELDVERWERKEN - LAB EXERCISE 4: Decting lines by Hough Transform

% COLLABORATORS:
% A.P. van Ree (10547320)
% T.M. Meijers (10647023)
% DATE:
% 8-12-2014

%% Section 2: Finding Lines using the Hough Transform

imgOrg1 = imread('shapes.png');
img1 = im2double(imgOrg1);
img1 = rgb2gray(img1);
% Remove two false lines at the sides
img1 = img1(2:end,2:end);

Thresh = [0.1, 0.9];
nrho = 200;
ntheta = 200;
sigma = 2;

% IMAGE ONE:
[edge_map, h] = hough(img1, Thresh, nrho, ntheta, sigma);
figure('name','Section 2: Finding lines using Hough transform');
subplot(2, 4, 1); 
imshow(edge_map);
subplot(2, 4, 2);
imshow(h, []);

% IMAGE TWO:
imgOrg1 = imread('billboard.png');
img1 = im2double(imgOrg1);
img1 = rgb2gray(img1);

[edge_map, h] = hough(img1, Thresh, nrho, ntheta, sigma);
subplot(2, 4, 3); 
imshow(edge_map);
subplot(2, 4, 4);
imshow(h, []);

% IMAGE THREE:
imgOrg1 = imread('box.png');
img1 = im2double(imgOrg1);
img1 = rgb2gray(img1);

[edge_map, h] = hough(img1, Thresh, nrho, ntheta, sigma);
subplot(2, 4, 5); 
imshow(edge_map);
subplot(2, 4, 6);
imshow(h, []);

% IMAGE FOUR:
imgOrg1 = imread('szeliski.png');
img1 = im2double(imgOrg1);
img1 = rgb2gray(img1);

[edge_map, h] = hough(img1, Thresh, nrho, ntheta, sigma);
subplot(2, 4, 7); 
imshow(edge_map);
subplot(2, 4, 8);
imshow(h, []);

clear;

%% Section 3: Finding the Lines as Local Maxima

% Read and convert image
imgOrg = imread('shapes.png');
img = im2double(imgOrg);
img = rgb2gray(img);
% Remove two false lines at the sides
img = img(2:end,2:end);
imgOrg = imgOrg(2:end,2:end,:);

% Set parameters
Thresh = [0.1, 0.9];
thresh = 50;
nrho = 500;
ntheta = 500;
sigma = 0.7;

% Obtain hough transform
[~, h] = hough(img, Thresh, nrho, ntheta, sigma);
% Obtain estimated lines
lines = houghLines(img, h, thresh, 1);

% Plot lines
figure('name','Section 3: Plotting hough lines');
imshow(imgOrg);
hold on
for i = 1:size(lines, 1)
    % Convert each homogenous line to two points
    line = lines(i,:);
    x1 = 0;
    y1 = (-line(1) * x1 - line(3)) / line(2);
    x2 = size(img, 2);
    y2 = (-line(1) * x2 - line(3)) / line(2);
    plot([x1 x2], [y1 y2], 'Color', 'r');
end
hold off

clear;

%% Section 5: Optimal Line Estimation

% Read and convert image
imgOrg = imread('shapes.png');
img = im2double(imgOrg);
img = rgb2gray(img);
% Remove two false lines at the sides
img = img(2:end,2:end);
imgOrg = imgOrg(2:end,2:end,:);

% Set parameters
Thresh = [0.1, 0.9];
thresh = 50;
nrho = 512;
ntheta = 512;
sigma = 0.7;
epsilon = 5;

% Get hough and canny
[edge_map, h] = hough(img, Thresh, nrho, ntheta, sigma);
% Obtain estimated lines
lines = houghLines(img, h, thresh, 1);
% Get coordinates from canny edge map
[y, x] = find(edge_map > 0);

% Find good estimation of lines
for i = 1:size(lines, 1)
    points = pointsOfLine([x y], lines(i,:), epsilon);
    lines(i,:) = lineThroughPoints(points);
end

% Plot lines
figure('name','Section 5: Optimal Line Estimation');
imshow(imgOrg);
hold on
for i = 1:size(lines, 1)
    % Convert each homogenous line to two points
    line = lines(i,:);
    x1 = 0;
    y1 = (-line(1) * x1 - line(3)) / line(2);
    x2 = size(img, 2);
    y2 = (-line(1) * x2 - line(3)) / line(2);
    plot([x1 x2], [y1 y2], 'Color', 'r');
end
hold off

clear;

%% Section 6: Using the Lines
% Two methods to get intersections

% Read and convert image
imgOrg = imread('shapes.png');
img = im2double(imgOrg);
img = rgb2gray(img);
% Remove two false lines at the sides
img = img(2:end,2:end);
imgOrg = imgOrg(2:end,2:end,:);

% Set parameters
Thresh = [0.1, 0.9];
thresh = 50;
nrho = 512;
ntheta = 512;
sigma = 0.7;
epsilon = 5;

% Get hough and canny
[edge_map, h] = hough(img, Thresh, nrho, ntheta, sigma);
% Obtain estimated lines
lines = houghLines(img, h, thresh, 1);
% Get coordinates from canny edge map
[y, x] = find(edge_map > 0);

% Find good estimation of lines
for i = 1:size(lines, 1)
    points = pointsOfLine([x y], lines(i,:), epsilon);
    lines(i,:) = lineThroughPoints(points);
end

% Now get intersections through one way (first question section 6) by
% taking the cross product
l = 0;
for i = 1:size(lines, 1) - 1
    for j = i+1:size(lines, 1)
        l = l + 1;
        p = cross(lines(i,:), lines(j,:));
        intersections(l,:) = p ./ p(3);
    end
end

% Second method by using the lines to estimate the projection directly

% Plot lines
figure('name','Section 6: Using the lines');
imshow(imgOrg);
hold on
for i = 1:size(lines, 1)
    % Convert each homogenous line to two points
    line = lines(i,:);
    x1 = 0;
    y1 = (-line(1) * x1 - line(3)) / line(2);
    x2 = size(img, 2);
    y2 = (-line(1) * x2 - line(3)) / line(2);
    plot([x1 x2], [y1 y2], 'Color', 'r');
end
for i = 1:size(intersections, 1)
    plot(intersections(i, 1), intersections(i, 2), 'b+');
end
hold off

clear;

%% Experiment 1: Szeliski

% Read and convert image
imgOrg = imread('szeliski.png');
img = im2double(imgOrg);
img = rgb2gray(img);

% Set parameters
Thresh = [0.2, 0.98];
thresh = 100;
nrho = 200;
ntheta = 200;
sigma = 2;
epsilon = 5;

% Get hough and canny
[edge_map, h] = hough(img, Thresh, nrho, ntheta, sigma);
% Obtain estimated lines
lines = houghLines(img, h, thresh, 0);
% Get coordinates from canny edge map
[y, x] = find(edge_map > 0);

% Find good estimation of lines
for i = 1:size(lines, 1)
    points = pointsOfLine([x y], lines(i,:), epsilon);
    lines(i,:) = lineThroughPoints(points);
end

% Now get intersections through one way (first question section 6)
l = 0;
for i = 1:size(lines, 1) - 1
    for j = i+1:size(lines, 1)
        l = l + 1;
        p = cross(lines(i,:), lines(j,:));
        intersections(l,:) = p ./ p(3);
    end
end

% Remove extra points
intersections([1 6],:) = [];
% Remove 3rd coord, split into X's and Y's
Xs = intersections(:,1)';
Ys = intersections(:,2)';

% Now project based on these points!
figure('name','Experiment 1: Projecting Szeliski');
imshow(myProjection(imgOrg, Xs, Ys, 200, 300, 'linear'));

clear;

%% Experiment 2: Box

% Read and convert image
imgOrg = imread('box.png');
img = im2double(imgOrg);
img = rgb2gray(img);

% Set parameters
Thresh = [0.2, 0.98];
thresh = 146;
nrho = 500;
ntheta = 500;
sigma = 2;
epsilon = 2;

% Get hough and canny
[edge_map, h] = hough(img, Thresh, nrho, ntheta, sigma);
% Obtain estimated lines
lines = houghLines(img, h, thresh, 0);
% Get coordinates from canny edge map
[y, x] = find(edge_map > 0);

% Find good estimation of lines
for i = 1:size(lines, 1)
    points = pointsOfLine([x y], lines(i,:), epsilon);
    lines(i,:) = lineThroughPoints(points);
end

% Now get intersections through one way (first question section 6)
l = 0;
for i = 1:size(lines, 1) - 1
    for j = i+1:size(lines, 1)
        l = l + 1;
        p = cross(lines(i,:), lines(j,:));
        intersections(l,:) = p ./ p(3);
    end
end

% Remove extra points
intersections = intersections([7 16 5 14],:);
% Remove 3rd coord, split into X's and Y's
Xs = intersections(:,1)';
Ys = intersections(:,2)';

% Now project based on these points!
figure('name','Experiment 2: Projecting box');
imshow(myProjection(imgOrg, Xs, Ys, 200, 200, 'linear'));

% This image clearly doesnt lend itself for this automatic detection since
% it generates 36 intersections. I have tried to manually (through
% debugging) select 4 correct points, but unfortunately this gives us a
% crappy projection. The reason for this is that bwlabel in houghlines
% gives us 7 regions, even with a very large dilation.

clear;

%% Experiment 3: Billboard

% Read and convert image
imgOrg = imread('billboard.png');
img = im2double(imgOrg);
img = rgb2gray(img);

% Set parameters
Thresh = [0, 0.94];
thresh = 125;
nrho = 500;
ntheta = 500;
sigma = 5;
epsilon = 2;

% Get hough and canny
[edge_map, h] = hough(img, Thresh, nrho, ntheta, sigma);
% Obtain estimated lines
lines = houghLines(img, h, thresh, 0);
% Get coordinates from canny edge map
[y, x] = find(edge_map > 0);

% Find good estimation of lines
for i = 1:size(lines, 1)
    points = pointsOfLine([x y], lines(i,:), epsilon);
    lines(i,:) = lineThroughPoints(points);
end

% Now get intersections through one way (first question section 6)
l = 0;
for i = 1:size(lines, 1) - 1
    for j = i+1:size(lines, 1)
        l = l + 1;
        p = cross(lines(i,:), lines(j,:));
        intersections(l,:) = p ./ p(3);
    end
end

% Now get intersections through one way (first question section 6)
l = 0;
for i = 1:size(lines, 1) - 1
    for j = i+1:size(lines, 1)
        l = l + 1;
        p = cross(lines(i,:), lines(j,:));
        intersections(l,:) = p ./ p(3);
    end
end

% Remove extra points
intersections([1 6],:) = [];
% Remove 3rd coord, split into X's and Y's
Xs = intersections(:,1)';
Ys = intersections(:,2)';

% Now project based on these points!
figure('name','Experiment 2: Projecting billboard');
imshow(myProjection(imgOrg, Xs, Ys, 200, 300, 'linear'));

clear;