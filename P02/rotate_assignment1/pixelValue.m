function [ color ] = pixelValue( image, x, y, method, border_method )
    % pixel value at real coordinates
    
    [image_x, image_y] = size(image);
    
    % Set x y values according to border_method
    switch(border_method)
        case 'constant'
            % Black border, x, y stay the same
            
        case 'nearest'
            % Repeat nearest pixel
            if (x > image_x)
                x = image_x;
            elseif (x < 1)
                x = 1;
            end
            if (y > image_y)
                y = image_y;
            elseif (y < 1)
                y = 1;
            end
            
        case 'periodic'
            % Repeat whole image
            x = mod(x, image_x);
            y = mod(y, image_y);
            % Fix due to minimum being 1
            if (x == 0)
                x = image_x;
            end
            if (y == 0)
                y = image_y;
            end
            
    end % end switch border_method   
 
    if inImage(size(image),x,y)
        % do the interpolation
        switch(method) 
            case 'nearest'
                % Do nearest neighbour interpolation.
                color = image(floor(x), floor(y));
                return; 
            case 'linear'
                color = bilinear_interpol(image, x, y);
        end % end switch method
    else
        color = 0;
    end
end

 