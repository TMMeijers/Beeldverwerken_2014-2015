function [pts] = pointsOfLine(points, line, epsilon)
% points - an array containing all points
% line - the homogeneous representation of the line
% epsilon - the maximum distance
% returns :
% pts - an array of all points within epsilon of the line

    % Make points homogenous
    points = [points ones(size(points, 1), 1)];
    
    % Normalize line
    line = line / line(3);
    
    % Find distance by dot product
    distance = line * points';
    
    % Now get all the points that lie within epsilon
    pts = points(abs(distance) < epsilon,:);
    pts(:,3) = [];

end

