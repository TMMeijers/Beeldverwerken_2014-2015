function demo_mosaic_npoints(nrPoints)
% script to demonstrate image mosaic
% by handpicking 4 matching points
% in the order topleft - topright - bottomright - bottomleft

    f1 = imread('nachtwacht1.jpg');
    f2 = imread('nachtwacht2.jpg');

    % Pick number of points
    [xy, xaya] = pickmatchingpoints(f1, f2, nrPoints, 1);
    xy = xy'
    xaya = xaya'
    
    % START OWN CODE
    % Obtain projection matrix (code from assignment 1) and transpose.
    P = projectionMatrix(xy, xaya)';
    % Divide through P(3, 3) to obtain real coordinates (homogenous) so we
    % can use it for maketform:
    T = maketform('projective', P/P(3,3));
    % END OWN CODE
    
    [x, y] = tformfwd(T,[1 size(f1,2)], [1 size(f1,1)]);

    xdata = [min(1,x(1)) max(size(f2,2),x(2))];
    ydata = [min(1,y(1)) max(size(f2,1),y(2))];
    f12 = imtransform(f1,T,'Xdata',xdata,'YData',ydata);
    f22 = imtransform(f2, maketform('affine', [1 0 0; 0 1 0; 0 0 1]), 'Xdata',xdata,'YData',ydata);
    subplot(1,1,1);
    imshow(max(f12,f22));
    
end