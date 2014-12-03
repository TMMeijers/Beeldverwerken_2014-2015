function [Fw] = canny(F, sigma, Threshold)
    % Canny Edge Detector
    
    % Get gradient gauge and angles
    Fx = gD(F, sigma, 1, 0);
    Fy = gD(F, sigma, 0, 1);
    Fw = sqrt(Fx.^2 + Fy.^2);
    
    % Get edge direction
    Fw_theta = atand(Fy ./ Fx);
    Fw_theta((Fw_theta >= -90 & Fw_theta <= -67.5) | ...
             (Fw_theta >= 67.5 & Fw_theta <= 90)) = 90;
    Fw_theta(Fw_theta > -67.5 & Fw_theta <= -22.5) = 45;
    Fw_theta(Fw_theta > -22.5 & Fw_theta < 22.5) = 0;
    Fw_theta(Fw_theta >= 22.5 & Fw_theta < 67.5) = -45;
    
    % Apply non-maximum surpression in Fv direction
    for u = 1:size(Fw, 1)
        for v = 1:size(Fw, 2)
            if Fw_theta(u, v) == 90 && checkVert(Fw, u, v)
                Fw(u, v) = 0;
            elseif Fw_theta(u, v) == 45 && checkDiagUR(Fw, u, v)
                Fw(u, v) = 0;
            elseif Fw_theta(u, v) == 0 && checkHor(Fw, u, v)
                Fw(u, v) = 0;
            elseif Fw_theta(u, v) == -45 && checkDiagDR(Fw, u, v)
                Fw(u, v) = 0;
            end
        end
    end
    
    % Hysteresis thresholding
    Fw(Fw > Threshold(1)) = 0; % Upper hysteresis threshold
    Fw(Fw < Threshold(2)) = 0; % Lower hysteresis threshold

end

function [no_edge] = checkVert(Fw, u, v)
% Check if edge is maximum in specific direction

    if u == 1
        no_edge = (Fw(u, v) ~= max(Fw(u, v), Fw(u + 1, v)));
    elseif u == size(Fw, 1)
        no_edge = (Fw(u, v) ~= max(Fw(u, v), Fw(u - 1, v)));
    else
        no_edge = (Fw(u, v) ~= max(Fw(u, v), max(Fw(u + 1, v), Fw(u - 1, v))));
    end
end

function [no_edge] = checkDiagUR(Fw, u, v)
% Check if edge is maximum in specific direction

    if (u == 1 && v == 1) || (u == size(Fw, 1) && v == size(Fw, 2))
        no_edge = 0;
    elseif u == 1 || v == size(Fw, 2)
        no_edge = (Fw(u, v) ~= max(Fw(u, v), Fw(u + 1, v - 1)));
    elseif u == size(Fw, 1) || v == 1
        no_edge = (Fw(u, v) ~= max(Fw(u, v), Fw(u - 1, v + 1)));
    else
        no_edge = (Fw(u, v) ~= max(Fw(u, v), max(Fw(u - 1, v + 1), Fw(u + 1, v - 1))));
    end
end

function [no_edge] = checkHor(Fw, u, v)
% Check if edge is maximum in specific direction

    if v == 1
        no_edge = (Fw(u, v) ~= max(Fw(u, v), Fw(u, v + 1)));
    elseif v == size(Fw, 2)
        no_edge = (Fw(u, v) ~= max(Fw(u, v), Fw(u, v - 1)));
    else
        no_edge = (Fw(u, v) ~= max(Fw(u, v), max(Fw(u, v + 1), Fw(u, v - 1))));
    end
end

function [no_edge] = checkDiagDR(Fw, u, v)
% Check if edge is maximum in specific direction

    if (u == 1 && v == size(Fw, 2)) || (u == size(Fw, 1) && v == 1)
        no_edge = 0;
    elseif u == 1 || v == 1
        no_edge = (Fw(u, v) ~= max(Fw(u, v), Fw(u + 1, v + 1)));
    elseif u == size(Fw, 1) || v == size(Fw, 2)
        no_edge = (Fw(u, v) ~= max(Fw(u, v), Fw(u - 1, v - 1)));
    else
        no_edge = (Fw(u, v) ~= max(Fw(u, v), max(Fw(u - 1, v - 1), Fw(u + 1, v + 1))));
    end
end