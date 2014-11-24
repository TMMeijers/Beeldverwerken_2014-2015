function [ out ] = mat3xy( A )
    % generates a reshaped 3 x 'xy' matrix for all 
    % pixel coordinates of A

    A_size = size(A);
  
    % Make vectors
    space_x = linspace(1, A_size(1), A_size(1));
    space_y = linspace(1, A_size(2), A_size(2));
    space_z =  ones([1, A_size(1) * A_size(2)]);
    
    % Cartesian product
    sets = { space_x, space_y };
    [x, y] = ndgrid(sets{:});
    out = [x(:), y(:)]';
    % Add 3rd dimension (ones)
    out = [out; space_z];
    
end

