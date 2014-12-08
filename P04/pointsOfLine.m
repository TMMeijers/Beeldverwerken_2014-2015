function [points] = pointsOfLine(pts, line, epsilon)
% points - an array containing all points
% line - the homogeneous representation of the line
% epsilon - the maximum distance
% returns :
% pts - an array of all points within epsilon of the line

    % Make points homogenous
    pts = [pts ones(size(pts, 1), 1)];
    
    % Find distance by dot product
    distance = line * pts';
    % Now get all the points that lie within epsilon
    inliers = find(abs(distance) < epsilon);
    points = pts(inliers,:);
    points(:,3) = [];

end

