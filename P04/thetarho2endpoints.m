function [x1, y1, x2, y2] = thetarho2endpoints(theta, rho, rows, cols)
%THETARHO2ENDPOINTS Summary of this function goes here
%   Detailed explanation goes here
    theta
    rho
    x1 = 1;
    y1 = (x1 * sin(theta) - rho) / cos(theta);
    x2 = cols;
    y2 = (x2 * sin(theta) - rho) / cos(theta);
    
%     if abs(y2 - y1) > cols
%         y1 = 0
%         x1 = (rho + y1 * cos(theta)) / sin(theta);
%         y2 = rows;
%         x2 = (rho + y2 * cos(theta)) / sin(theta);
%     end
    
end

