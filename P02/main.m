% 10452397 Markus Pfundstein
% 10647023 Thomas Meijers

% Implementation of Gaussian derivatives

%% Q2.1: Gauss function

% See gauss.m

% We chose to choose M = N = 3 * sigma
% http://en.wikipedia.org/wiki/Gaussian_blur:
% Because in practice, when computing a discrete approximation of the 
% Gaussian function, pixels at a distance of more than 3? are small 
% enough to be considered effectively zero.

%% Q2.2: Checking sum of gauss

% I would expect it to return 1. Because thats the area of the probability
% density function. Our function does exactly this. 
% Note that "weak" implementations return < 1. But we never had this issue
% because we did it correct the first time 
%See:

% create sigmas from 1 to 10
sigmas = linspace(1, 10, 10);
sums = zeros(10, 1);
% loop over and put into sums
for i=1:length(sigmas)
    sums(i) = sum(sum(gauss(sigmas(i))));
end

% print out sums -> only 1's
sums

clear

%% Q2.3: Plotting gaussian

% plot a gaussian

S = 3;
G = gauss(S);
figure;
mesh(G);

clear

%% Q2.4: Scale units

% The physical units are obviously pixels :-)

%% Q2.5: Timing 2D gaussian blurring

F = imread('autumn.tif');
F = rgb2gray(F);
F = im2double(F);

its = 50;
its2 = 10;

% create sigmas from 1 to 10
sigmas = linspace(1, its, its);
% loop over and put into sums
elapsedTime = zeros(length(sigmas), 1);
for i=1:its
    
    average = 0;
    for j=1:its2
        tic;
        imfilter(F, gauss(sigmas(i)), 'conv', 'replicate'); 
        average = average + toc; 
    end
    elapsedTime(i) = average / its2;
end

figure;
plot((1:its), elapsedTime);
title('time plot');
ylabel('time');
xlabel('sigma');

clear;

%% Q2.6: Complexity of 2D gaussian blur

% The computational complexity in terms of scale is exponential so 
% O(sigma^2) for 2D
% The overall complexity is O(M * N * sigma^2), where M by N is the image
% size and sigma the scale for 2D.

%% Q2.7: Single blur vs consecutive blur (2D Gaussian)

F = imread( 'autumn.tif' );
% F = rgb2gray(F);
F = im2double(F);

% Single gaussian blur and consecutive gaussian with same scale.
figure;
sigma = 3;
% G1 * G2 * F
gauss1 = conv2(gauss(sigma), gauss(sigma));
subplot(1,3,1);
img1 = imfilter(F, gauss1, 'conv', 'replicate');
imshow(img1);
% G12 * F
gauss2 = gauss(sqrt(sigma^2 + sigma^2));
subplot(1,3,2);
img2 = imfilter(F, gauss2, 'conv', 'replicate');
imshow(img2);
% Difference between images (none)
subplot(1, 3,3);
imshow(img2 - img1);

clear

%% Q2.8: 1D Gaussian

% implement gauss1 
% see gauss1.m

sum(gauss1(90))

% returns 1 as expected

clear

%% Q2.9: Timing consecutive Gaussian Blurring and complexity

% time and plot how gauss1 will perform in terms of complexity with respect
% to the scale. We can cleary see when evaluating the results that the
% complexity now is O(sigma). 

F = imread( 'autumn.tif' );
F = rgb2gray(F);
F = im2double(F);

its = 50;
its2 = 10;

% create sigmas from 1 to 10
sigmas = linspace(1, its, its);
% loop over and put into sums
elapsedTime = zeros(length(sigmas), 1);
for i=1:its
    
    average = 0;
    for j=1:its2
        tic;
        r = imfilter(F, gauss1(sigmas(i)), 'conv', 'replicate'); 
        imfilter(r, gauss1(sigmas(i))', 'conv', 'replicate');
        average = average + toc; 
    end
    elapsedTime(i) = average / its2;
end

figure;
plot((1:its), elapsedTime);
title('time plot');
ylabel('time');
xlabel('sigma');

clear;

%% Q2.10: First and Second order derivatives of an image

F = imread('cameraman.tif');
F = im2double(F);
sigma = 2;

% plot all the derivates nicely
figure;
subplot(3,3,1);
imshow(F);
title('f');
subplot(3,3,2);
imshow(gD(F, sigma, 1, 0),[]);
title('f_{x}');
subplot(3,3,4);
imshow(gD(F, sigma, 0, 1),[]);
title('f_{y}');
subplot(3,3,3);
imshow(gD(F, sigma, 2, 0),[]);
title('f_{xx}');
subplot(3,3,7);
imshow(gD(F, sigma, 0, 2),[]);
title('f_{yy}');
subplot(3,3,5);
imshow(gD(F,sigma, 1, 1),[]);
title('f_{xy}');
subplot(3,3,6);
imshow(gD(F, sigma, 2, 1),[]);
title('f_{xxy}');
subplot(3,3,8);
imshow(gD(F,sigma, 1, 2),[]);
title('f_{yyx}');
subplot(3,3,9);
imshow(gD(F, sigma, 2, 2),[]);
title('f_{xxyy}');

clear

%% Q2.10

% % two jet 
F = imread('cameraman.tif');
F = im2double(F);

sigma = 3;
figure;
subplot(1, 2, 1);
imshow(F);
title('original');

% thats the 2jet
subplot(1, 2, 2);
imshow(twojet(F, sigma), []);
title('2-jet');

clear

%% Q3.0: Show image (1)
% Test code

% CODE BELOW FROM ASSIGNMENT
x = -100:100;
y = -100:100;
[X, Y] = meshgrid (x, y);
A = 1; B = 2; V = 6* pi /201; W = 4* pi /201;
F = A * sin(V*X) + B * cos(W*Y);
figure;
imshow (F, [], 'xData', x, 'yData', y);
% CODE ABOVE FROM ASSIGNMENT

clear

%% Q3.1: First and second order derivatives of (1)

% See latex for the derivatives.

%% Q3.2: X and Y derivative

% CODE BELOW FROM ASSIGNMENT
x = -100:100;
y = -100:100;
[X, Y] = meshgrid (x, y);
A = 1; B = 2; V = 6* pi /201; W = 4* pi /201;
% CODE ABOVE FROM ASSIGNMENT

% Calculate x and y derivative of the image
Fx = A * cos(V * X);
Fy = -W * B * sin(W * Y);

% Show both
figure;
subplot(1, 2, 1);
imshow(Fx, [], 'xData', x, 'yData', y);
subplot(1, 2, 2);
imshow(Fy, [], 'xData', x, 'yData', y);

clear

%% Q3.3: Plotting gradient vectors

% CODE BELOW FROM ASSIGNMENT
x = -100:100;
y = -100:100;
[X, Y] = meshgrid (x, y);
A = 1; B = 2; V = 6* pi /201; W = 4* pi /201;
F = A * sin(V*X) + B * cos(W*Y);

xx = -100:10:100;
yy = -100:10:100;
[XX , YY] = meshgrid (xx , yy );
% CODE ABOVE FROM ASSIGNMENT

% Get gradients by using derivative from 3.1
Fx = V * A * cos(V * XX);
Fy = -W * B * sin(W * YY);

% Plot vectors on image
figure;
imshow (F, [], 'xData', x, 'yData', y);
hold on;
quiver (xx , yy , Fx , Fy , 'r');
hold off ;

clear

%% Q3.4: Gradient vectors using own code

% CODE BELOW FROM ASSIGNMENT
x = -100:100;
y = -100:100;
[X, Y] = meshgrid (x, y);
A = 1; B = 2; V = 6* pi /201; W = 4* pi /201;
F = A * sin(V*X) + B * cos(W*Y);

xx = -100:10:100;
yy = -100:10:100;
% CODE ABOVE FROM ASSIGNMENT

% Get gradient vectors and sample
Fx = gD(F, 1, 1, 0);
Fy = gD(F, 1, 0, 1);
Fx1 = Fx(xx + 101, yy + 101);
Fy1 = Fy(xx + 101, yy + 101);

% Plot vectors on image
figure;
imshow (F, [], 'xData', x, 'yData', y);
hold on;
quiver (xx , yy , Fx1 , Fy1 , 'r');
hold off ;

clear

%% Q3.5: Gradient vectors on rotated image

% CODE BELOW FROM ASSIGNMENT
x = -100:100;
y = -100:100;
[X, Y] = meshgrid (x, y);
A = 1; B = 2; V = 6* pi /201; W = 4* pi /201;
F = A * sin(V*X) + B * cos(W*Y);

xx = -100:10:100;
yy = -100:10:100;
% CODE ABOVE FROM ASSIGNMENT

% Rotate
F = rotateImageFast(F, 1/18 * pi, 'linear', 'constant', 0);


% Get gradient vectors and sample
Fx = gD(F, 1, 1, 0);
Fy = gD(F, 1, 0, 1);
Fx = Fx(xx + 101, yy + 101);
Fy = Fy(xx + 101, yy + 101);

% Filter out large gradients from the border
Fx(Fx > 0.2 | Fx < -0.2) = 0;
Fy(Fy > 0.2 | Fy < -0.2) = 0;

% Plot vectors on image
figure;
subplot(1, 2, 1);
title('Rotated image with gradient vectors');
imshow (F, [], 'xData', x, 'yData', y);
hold on;
quiver (xx, yy, Fx, Fy, 'r');
hold off;

% CODE BELOW FROM Q3.4 FOR PLOTTING
x = -100:100;
y = -100:100;
[X, Y] = meshgrid (x, y);
A = 1; B = 2; V = 6* pi /201; W = 4* pi /201;
F = A * sin(V*X) + B * cos(W*Y);

xx = -100:10:100;
yy = -100:10:100;
[XX , YY] = meshgrid (xx , yy);

% Get gradient vectors and sample
Fx = gD(F, 1, 1, 0);
Fy = gD(F, 1, 0, 1);
Fx1 = Fx(xx + 101, yy + 101);
Fy1 = Fy(xx + 101, yy + 101);

% Plot vectors on image
subplot(1, 2, 2);
title('Original image with gradient vectors');
imshow (F, [], 'xData', x, 'yData', y);
hold on;
quiver (xx , yy , Fx1 , Fy1 , 'r');
hold off ;
% CODE ABOVE FROM Q3.4 FOR PLOTTING

clear

%% Q3.6: Deriving Fw and Fww

% See PDF

%% Q3.7: Canny Edge Detector

% See canny.m

%% Q3.8: Testing Canny on Cameraman

% Load images and get the inverted canny edge images
% Don't change sigma (1.5)! Hysteresis is done based on this scale
Fautumn = imread('autumn.tif');
Fautumn = rgb2gray(Fautumn);
Fautumn = im2double(Fautumn);
Fautumn = imcomplement(canny(Fautumn, 1.5));

Fcameraman = imread('cameraman.tif');
Fcameraman = im2double(Fcameraman);
Fcameraman = imcomplement(canny(Fcameraman, 1.5));

% Show results
figure('name','Canny Edge detection applied to cameraman and autumn');
subplot(1, 2, 1);
imshow(Fcameraman, []);
title('Cameraman.tif');
subplot(1, 2, 2);
imshow(Fautumn, []);
title('Autumn.tif');

clear

%% Q3.9: Corner detection

F = imread('checkerboard.png');
F = im2double(F);


figure('Name','Q3.9: Corner detection');
subplot(1, 2, 1);
imshow(F);
title('Original');
% Don't change sigma (1) as hysteresis thresholding is based on this scale
F = imcomplement(cornerDetect(F, 1));
subplot(1, 2, 2);
imshow(F, []);
title('Corner');

clear