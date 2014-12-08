function [lines] = houghLines(img, h, thresh)
    % HOUGHLINES
    %
    % Function takes an image and its Hough transform , finds the
    % significant lines and draws them over the image
    %
    % Usage : houghlines (im , h, thresh )
    %
    % arguments :
    % im - The original image
    % h - Its Hough Transform
    % thresh - The threshold level to use in the Hough Transform
    % to decide whether an edge is significant
    [rows, cols] = size(img);
    rhomax = sqrt(rows^2 + cols^2); % The maximum possible value of rho.
    
    [nrho, ntheta] = size(h);
    drho = 2 * rhomax / (nrho - 1); % The increment in rho between successive    
    dtheta = pi / ntheta; % The increment in theta between entries
    % Threshold
    h(h < thresh) = 0;
    
    % Dilate the img (with circle based on size of h)
    stampsize = round(size(h, 1) / 25);
    [xx, yy] = meshgrid(1:stampsize);
    stamp = sqrt((xx - stampsize / 2).^2 + (yy - stampsize / 2).^2) <= 20;
    h = imdilate(h, stamp);
    
    [bwl, nregions] = bwlabel(h);
    lines = zeros(nregions, 3);
    
    for n = 1:nregions
        mask = bwl == n; % Form a mask for each region .
        region = mask .* h; % Point-wise multiply mask by Hough Transform
        % to obtain an image with just one region of the Hough Transform
        [rhoindex, thetaindex] = find(region == max(max(region)));
        rhoindex = round(mean(rhoindex));
        thetaindex = round(mean(thetaindex));
        
        % Obtain rho and theta
        rho = drho * (rhoindex - nrho / 2);
        theta = (thetaindex - 1) * dtheta;
        
        [x1, y1, x2, y2] = thetarho2endpoints(theta, rho, rows, cols);
        
        line_hom = cross([x1; y1; 1], [x2; y2; 1]);
        line_hom = line_hom ./ sqrt(line_hom(1)^2 + line_hom(2)^2);
        lines(n,:) = line_hom;
    end
end