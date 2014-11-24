function rotated_image = rotateImageFast(image, angle, method, border_method, do_resize)
    % Rotates image based on matrix multiplication

    % Initialize matrices and variables
    [image_x, image_y] = size(image);
    if (do_resize)
        rotated_image = newImageDimensions(image_x, image_y, angle);
    else
        rotated_image = image;
    end
    new_image_size = size(rotated_image);
    
    % Calculate centers
    c = [image_x; image_y] / 2;
    new_c = [new_image_size(1); new_image_size(2)] / 2;
    
    % Homogenous coordinates matrix
    T1 = [1, 0, -new_c(1); 0, 1, -new_c(2); 0, 0, 1];
    T2 = [1, 0, c(1); 0, 1, c(2); 0, 0, 1];
    R = [cos(angle), -sin(angle), 0; sin(angle), cos(angle), 0; 0, 0, 1];
    A = T2 * R * T1;
    
    % Get transformated image and corresponding pixel values
    new_coordinates = A * mat3xy(rotated_image);
    new_coordinates = [new_coordinates(1,:); new_coordinates(2,:)];
    new_pixel_values = arrayfun(@(c1, c2) pixelValue(image, c1, c2, method, border_method), new_coordinates(1,:), new_coordinates(2,:));
    rotated_image = reshape(new_pixel_values, new_image_size);
    
end 