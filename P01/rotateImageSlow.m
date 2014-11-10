function rotated_image = rotateImageSlow(image, angle, method, border_method, do_resize)
    % Rotates image based on iteration

    % Initialize matrices and variables
    [image_x, image_y] = size(image);
    if (do_resize)
        rotated_image = newImageDimensions(image_x, image_y, angle);
    else
        rotated_image = image;
    end
    new_image_size = size(rotated_image);
    R = [cos(-angle), -sin(-angle); sin(-angle), cos(-angle)];
    
    % Calculate centers
    c = [image_x; image_y] / 2;
    new_c = [new_image_size(1); new_image_size(2)] / 2;

    
    % Get pixel values for rotated image
    for x = 1:new_image_size(1)
       for y = 1:new_image_size(2)

           % Translate back to origin, rotate and translate to original center
           p = [x; y] - new_c;
           p = R * p;
           p = p + c;
           
           rotated_image(x, y) = pixelValue(image, p(1), p(2), method, border_method);
           
       end % y loop
    end % x loop
     
end 