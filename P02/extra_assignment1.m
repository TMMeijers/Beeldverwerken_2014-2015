a = imread( 'autumn.tif' );
%a = rgb2gray(a);
a = im2double(a);

% motion blur 5 pixels to the right
g1 = 1/6 * [1 1 1 1 1 1 0 0 0 0 0];

% nice gaussian with sigma 5
g2 = gauss(8);

% unsharper
sigma = 11;
gaus = gauss(sigma);
identity = padarray(2, [(3*sigma-1)/2 (3*sigma-1)/2]);
g3 = (identity - gaus);
figure;

subplot(2, 2, 1);
imshow(imfilter(a, g1, 'conv', 'replicate'));
title('motion blur, 5 pixels right');
subplot(2, 2, 2);
imshow(imfilter(a, g2, 'conv', 'replicate'));
title('gaussian, sigma 8');
subplot(2, 2, 3);
imshow(imfilter(a, g3, 'conv', 'replicate'));
title('unsharp masking, sigma 3');
