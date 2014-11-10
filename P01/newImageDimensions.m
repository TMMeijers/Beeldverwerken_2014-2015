function [ rotated_image ] = newImageDimensions( image_x, image_y, angle)
    % Calculates new image size

    R = [cos(-angle), -sin(-angle); sin(-angle), cos(-angle)];
    
    % Find new image size
    corner_dl = [0; 0];
    corner_ul = round(R * [0; image_y]);
    corner_ur = round(R * [image_x; image_y]);
    corner_dr = round(R * [image_x; 0]);
    % Get max x and y
    x_max = max(abs(corner_dl(1) - corner_ur(1)), abs(corner_ul(1) - corner_dr(1)));
    y_max = max(abs(corner_dl(2) - corner_ur(2)), abs(corner_ul(2) - corner_dr(2)));
    % Initalize new image and it's size / center
    rotated_image = zeros(x_max, y_max);

end

