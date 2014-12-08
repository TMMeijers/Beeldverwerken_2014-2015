function [ v ] = bilinear_interpol( im, x, y )
% Performs bilinear interpolation

    imsize = size(im);

    % Set bounds
    k0 = floor(x);
    k1 = min(imsize(1), ceil(x));
    
    l0 = floor(y);
    l1 = min(imsize(2), ceil(y));
    
    a = x - k0;
    b = y - l0;
    
    % Formula for bilinear interpolation
    v =     (1 - a) * (1 - b) * im(k0, l0);
    v = v + a * (1 - b)       * im(k1, l0);
    v = v + (1 - a) * b       * im(k0, l1);
    v = v + a * b             * im(k1, l1);
end

