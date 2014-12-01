function [best_fit] = ransac(img1, img2, n, err, iterations, threshold)
%RANSAC 

    % Get keypoints and matches
    [F1, D1] = vl_sift(img1);
    [F2, D2] = vl_sift(img2);
    matches = vl_ubcmatch(D1, D2);
    
    % Get coordinates of matching keypoints
    m1 = matches(1,:);
    m1coords = F1(:,m1);
    m1coords = m1coords(1:2,:);
    m2 = matches(2,:);
    m2coords = F2(:,m2);
    m2coords = m2coords(1:2,:);

    inlier_margin = ceil(size(matches, 2) * threshold); % percentage inliers
    best_error = inf();
    
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
        
        % Calculate euclidean distance and inliers
        distances = sqrt(sum((m2coords - p2).^2));
        inlier_indices = find(distances < err);
        nr_inliers = length(inlier_indices);
        
        if nr_inliers >= inlier_margin % If more than 50% of matches is inlier
            % Make model out of all inliers
            m1 = m1coords(:,inlier_indices);
            m2 = m2coords(:,inlier_indices);
            fit = projectionMatrix(m1', m2');
            
            % Project again
            p2 = fit * [m1; ones(1, size(m1, 2))];
            for j = 1:length(p2)
                p2(:,j) = p2(:,j) ./ p2(3,j);
            end
            p2 = p2(1:2,:);
            
            % Calculate total error and check if model is better
            new_error = sum(sqrt(sum((m2 - p2).^2)));
            if new_error < best_error;
                best_error = new_error;
                best_fit = fit;
            end % end if error lower
        end % end if enough inliers
    end % end for main loop
end % end main function

