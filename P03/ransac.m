function [best_fit] = ransac(img1, img2, n, err, iterations, threshold)
% implementation of the RANSAC algorithm. This function uses matches
% between keypoints to find a model that fits these point correspondences
% the best.
%
% @PARAM img1, img2: Images used for keypoint matching.
% @PARAM n: n is the number of random points used to establish the initial
% model every iteration.
% @PARAM err: This is the error margin. Points within this margin relative
% to the model are considered inliers.
% @PARAM iteration: Number of iterations we have to find the best fit.
% @PARAM threshold: The number of inliers (relative to matching keypoints)
% we need to try and improve the best fit.
%
% @RETURNS best_fit: A projection matrix which fits the matching keypoints
% the best.

    % Get keypoints and matches uses VLFeat library
    [F1, D1] = vl_sift(img1);
    [F2, D2] = vl_sift(img2);
    matches = vl_ubcmatch(D1, D2);
    
    % Get coordinates of matching keypoints, throw away other data.
    m1 = matches(1,:);
    m1coords = F1(:,m1);
    m1coords = m1coords(1:2,:);
    m2 = matches(2,:);
    m2coords = F2(:,m2);
    m2coords = m2coords(1:2,:);

    % Set threshold of inliers needed for optimizing fit.
    inlier_threshold = ceil(size(matches, 2) * threshold);
    % We have no best fit yet, so error is infinite
    best_error = inf();
    
    % Iterate @iterions many times to find best fit.
    for i = 1:iterations
        % Generate random indices to get n random point correspondences
        rand_samples = randi(size(matches, 2), 1, n);
        m1 = m1coords(:,rand_samples)';
        m2 = m2coords(:,rand_samples)';
        
        % Get a fit (projection matrix)
        fit = projectionMatrix(m1, m2);
        % Transform points from img1 and get real coordinates
        p2 = fit * [m1coords; ones(1, size(m1coords, 2))];
        for j = 1:length(p2)
            p2(:,j) = p2(:,j) ./ p2(3,j);
        end % end for normalize loop
        p2 = p2(1:2,:);
        
        % Calculate euclidean distance as measurement of error
        distances = sqrt(sum((m2coords - p2).^2));
        % Get indices of inlier, which are within the error margin
        inlier_indices = find(distances < err);
        nr_inliers = length(inlier_indices);
        
        % If nr of inliers is equal or above to threshold optimize the fit
        if nr_inliers >= inlier_threshold
            % Make a new model (proj matrix) with all inliers
            m1 = m1coords(:,inlier_indices);
            m2 = m2coords(:,inlier_indices);
            fit = projectionMatrix(m1', m2');
            
            % Project again and normalize
            p2 = fit * [m1; ones(1, size(m1, 2))];
            for j = 1:length(p2)
                p2(:,j) = p2(:,j) ./ p2(3,j);
            end
            p2 = p2(1:2,:);
            
            % Calculate total error (euclidean distance)
            new_error = sum(sqrt(sum((m2 - p2).^2)));
            % If our total error is lower than previous best we have a
            % better fit.
            if new_error < best_error;
                best_error = new_error;
                best_fit = fit;
            end % end if error lower
        end % end if enough inliers
    end % end for main loop
end % end main function

