function [ error ] = mse(duplication, original)
    % calculates mean squared error

    % Check if size consistent
    size_dup = size(duplication);
    size_orig = size(original);
    assert(size_dup(1) == size_orig(1), 'original and duplication must be of same size');
    assert(size_dup(2) == size_orig(2), 'original and duplication must be of same size');
    
    % calculate error
    error = 1/(size_dup(1) * size_dup(2)) * sum((original(:) - duplication(:)).^2);
end

