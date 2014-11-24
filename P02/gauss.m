function [ G ] = gauss( sigma )
    % implementation of the gaussian blur function
    % the size of the G matrix will be 3 times sigma.
    
    
    % standard size for a gauss
    M = abs(ceil(3 * sigma));
    
    % sigma denominator
    sd2 = 2 * sigma^2;
    
    [x, y] = meshgrid(ceil(-M/2):floor(M/2), ceil(-M/2):floor(M/2));
    G = exp(-x.^2/sd2 - y.^2/sd2);
    % because we truncate our gauss we have to divide through the
    % sum of G. On a infinite gauss we would use
    % G ./ (sd2 * pi)
    G = G ./ sum(G(:));
end