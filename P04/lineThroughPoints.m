function [line] = lineThroughPoints(points)
% returns :
% l - homogeneous representation of the least -square -fit

    % Calculate centroid, obtain distances
    c = mean(points);
    crep = repmat(c, size(points, 1), 1);
    p = points - crep;
    % Make covariance matrix, obtain eigenvalues and vector
    [v, d] = eig(p' * p);
    [~, col] = find(d == max(max(d)));
    u = v(:,col);
    % Get second point to convert to homogenous coordinates
    c2 = c + u';
    line = cross([c 1], [c2 1]);
    line = line ./ sqrt(line(1)^2 + line(2)^2);
end

