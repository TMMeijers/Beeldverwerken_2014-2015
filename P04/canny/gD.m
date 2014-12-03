function [F] = gD(F, sigma, x_order, y_order)
    % calculates gaussian derivive

    G_x = gauss1(sigma);
    
    % standard size for a gauss
    M = abs(ceil(2.5 * sigma));
    
    x = linspace(ceil(-M/2), floor(M/2), M);

    dx = -(x./sigma^2) .* G_x;
    if (x_order == 1 && y_order == 0)
        % derivative to x
        F = imfilter(F, dx, 'conv', 'replicate');
    elseif (y_order == 1 && x_order == 0)
        % derivative to y
        F = imfilter(F, dx', 'conv', 'replicate');
    elseif (x_order == 2 && y_order == 0)
        % 2 times to x
        F = imfilter(F, dx, 'conv', 'replicate');
        F = imfilter(F, dx, 'conv', 'replicate');
    elseif (y_order == 2 && x_order == 0)
        % 2 times to y
        F = imfilter(F, dx', 'conv', 'replicate');
        F = imfilter(F, dx', 'conv', 'replicate');
    elseif (y_order == 1 && x_order == 1)
        % derivate to x
        F = imfilter(F, dx, 'conv', 'replicate');
        % derivative to y
        F = imfilter(F, dx', 'conv', 'replicate');
    elseif (x_order == 2 && y_order == 1)
        % 2 times to x
        F = imfilter(F, dx, 'conv', 'replicate');
        F = imfilter(F, dx, 'conv', 'replicate');
        % 1 time to y
        F = imfilter(F, dx', 'conv', 'replicate');
    elseif (y_order == 2 && x_order == 1)
        % 2 times to y
        F = imfilter(F, dx', 'conv', 'replicate');
        F = imfilter(F, dx', 'conv', 'replicate');
        % 1 time to x
        F = imfilter(F, dx, 'conv', 'replicate');
    elseif (y_order == 2 && x_order == 2)
        % 2 times to x
        F = imfilter(F, dx, 'conv', 'replicate');
        F = imfilter(F, dx, 'conv', 'replicate');
        % 2 times to y
        F = imfilter(F, dx', 'conv', 'replicate');
        F = imfilter(F, dx', 'conv', 'replicate');
    else
        assert(0 == 1, 'unsupported');
    end
end

