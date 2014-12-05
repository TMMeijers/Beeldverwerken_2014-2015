function [h] = hough (img, Thresh, nrho, ntheta, sigma)
% HOUGH
%
% Function takes a grey scale image , constructs an edge map by applying
% the Canny detector , and then constructs a Hough transform for finding
% lines in the image.
%
% @ARGUMENTS :
% @im - The grey scale image to be transformed
% @Thresh - A 2 -vector giving the upper and lower
% hysteresis threshold values for edge ()
% @nrho - Number of quantised levels of rho to use
% @ntheta - Number of quantised levels of theta to use
%
% @RETURNS: h - The Hough transform

    edge_map = canny(img, sigma, Thresh);
    [rows, cols] = size(edge_map);

    rhomax = sqrt(rows ^2 + cols ^2); % The maximum possible value of rho.
    drho = 2* rhomax / (nrho -1); % The increment in rho between successive
    % entries in the accumulator matrix
    % Remember we go between +- rhomax
    
    h = zeros(nrho, ntheta);
    dtheta = pi / ntheta; % The increment in theta between entries .
    thetas = [0: dtheta: (pi - dtheta)]; % Array of theta values across the
    % accumulator matrix
    
    % for each x and y of nonzero edge values :
    [y, x] = find(edge_map > 0);
    for i = 1:length(x)
        for j = 1:length(thetas)
            % Evaluate rho (see formula (1) in assignment)
            rho = x(i) * sin(thetas(j)) - y(i) * cos(thetas(j));

            % Convert a value of rho or theta
            % to its appropriate index in the array:
            rhoindex = round(rho / drho + nrho / 2);
            thetaindex = round(thetas(j) / dtheta + 1);
            h(rhoindex, thetaindex) = ...
                h(rhoindex, thetaindex) + 10;
        end % for theta
    end % for coord
end % End main function (hough)