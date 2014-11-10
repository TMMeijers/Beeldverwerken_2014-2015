function [ nc ] = transformCube( M, q )
% Transforms cube with projection matrix

    % Loop through all coordinates
    for f=1:6
        for p=1:5
           % Make vector
           v(1) = q(f, p, 1); 
           v(2) = q(f, p, 2);
           v(3) = q(f, p, 3);
           v(4) = 1;
           % Transform and put in new cube array
           nv = M * v';
           nv = 1/nv(3) * nv;
           nc(f, p, 1) = nv(1);
           nc(f, p, 2) = nv(2);
        end
    end

end


