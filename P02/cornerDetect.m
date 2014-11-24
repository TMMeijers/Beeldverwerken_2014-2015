function [Fw] = cornerDetect(F, sigma)
    % corner detector
    
    % Get derivatives
    Fx = gD(F, sigma, 1, 0);
    Fxx = gD(F, sigma, 2, 0);
    Fy = gD(F, sigma, 0, 1);
    Fyy = gD(F, sigma, 0, 2);
    Fxy = gD(F, sigma, 1, 1);
    
    % Compute Fw^3Fvv
    Fw3 = sqrt(Fx.^2 + Fy.^2).^3;
    Fvv = (Fx.^2 .* Fyy - 2 .* Fx .* Fy .* Fxy + Fy.^2 .* Fxx) ...
          ./ sqrt(Fx.^2 + Fy.^2);
    Fw = Fw3 .* Fvv;
    
    % Hysteresis thresholding
    Fw(Fw < 0.000001) = 1;   
end