function [ G ] = gauss1( sigma )
    % implementation of the gaussian blur function in 1D
    % the size of the G vector will be 3 times sigma.
    
    % standard size for a gauss
    M = abs(ceil(2.5 * sigma));
    
    % sigma denominator
    sd2 = 2 * sigma^2;
    
    x = linspace(ceil(-M/2), floor(M/2), M);
    G = exp(-x.^2/sd2);

    % because we truncate our gauss we have to divide through the
    % sum of G. On a infinite gauss we would use
    % G ./ (sd2 * pi)
    G = G ./ sum(G(:));
end