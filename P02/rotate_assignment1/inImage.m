function [ in ] = inImage( image_size, x, y )
    %% Returns 1 if x and y are within image size
    
    assert(length(image_size) >= 2, 'image_size must be larger than 2');
    
    % necessary.
    x = floor(x);
    y = floor(y);
    
    in = (x >= 1 && y >= 1 && x <= image_size(1) && y <= image_size(2));

end

