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

Thresh = [inf(), 0.2];
nrho = 200;
ntheta = 200;
sigma = 0.7;

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

imgOrg = imread('shapes.png');
img = im2double(imgOrg);
img = rgb2gray(img);
% Remove two false lines at the sides
img = img(2:end,2:end);

Thresh = [inf(), 0.1];
thresh = 50;
nrho = 500;
ntheta = 500;
sigma = 0.7;

[edge_map, h] = hough(img, Thresh, nrho, ntheta, sigma);
lines = houghLines(img, h, thresh);

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

%% Section 5: Optimal Line Estimation

imgOrg = imread('shapes.png');
img = im2double(imgOrg);
img = rgb2gray(img);
% Remove two false lines at the sides
img = img(2:end,2:end);

Thresh = [inf(), 0.1];
thresh = 50;
nrho = 512;
ntheta = 512;
sigma = 0.7;
epsilon = 5;

[edge_map, h] = hough(img, Thresh, nrho, ntheta, sigma);
lines = houghLines(img, h, thresh);
[x, y] = find(edge_map ~= 0);

% Find good estimation of lines
for i = 1:size(lines, 1)
    points = pointsOfLine([x y], lines(i,:), epsilon);
end


% % Plot lines
% figure('name','Section 3: Plotting hough lines');
% imshow(imgOrg);
% hold on
% for i = 1:size(lines, 1)
%     % Convert each homogenous line to two points
%     line = lines(i,:);
%     x1 = 0;
%     y1 = (-line(1) * x1 - line(3)) / line(2);
%     x2 = size(img, 2);
%     y2 = (-line(1) * x2 - line(3)) / line(2);
%     plot([x1 x2], [y1 y2], 'Color', 'r');
% end
% hold off
