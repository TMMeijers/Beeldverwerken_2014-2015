function [ new_img ]  = canny(img, sigma)

    % derivatives
    Fx = gD(img, sigma, 1, 0);
    Fy = gD(img, sigma, 0, 1);

    % new w vector for rotation independent gradient
    Fw = sqrt(Fx.^2 + Fy.^2);
    
    % copy of Fw
    new_img = Fw;
    img_size = size(new_img);
    % loop through image, because of borders we begin at 2 and stop at
    % width/height - 1
    for u = 2:img_size(1) - 1
        for v = 2:img_size(2) - 1
       
            % non-maximum surpression. here we check if the
            % signs of the gradient to the left/right, before and up are
            % the same. if not then we set the pixel value to 0.
                % vertical, diagonal, diagonal2, horizontal
            if (sign(Fw(u - 1, v    )) ~= sign(Fw(u + 1, v    )) || ...
                sign(Fw(u - 1, v - 1)) ~= sign(Fw(u + 1, v + 1)) || ...
                sign(Fw(u - 1, v + 1)) ~= sign(Fw(u + 1, v - 1)) || ...
                sign(Fw(u,     v - 1)) ~= sign(Fw(u,     v + 1)))
                % set to zero if no maximum
                new_img(u, v) = 0;
                
            end
        end
    end
    
    % Hysteresis thresholding
    new_img(new_img < 0.08) = 0;
end


% function [Fw] = canny(F, sigma)
%     % Canny Edge Detector
%     
%     % Get gradient gauge and angles
%     Fx = gD(F, sigma, 1, 0);
%     Fy = gD(F, sigma, 0, 1);
%     Fw = sqrt(Fx.^2 + Fy.^2);
%     
%     % Get edge direction
%     Fw_theta = atand(Fy ./ Fx);
%     Fw_theta((Fw_theta >= -90 & Fw_theta <= -67.5) | ...
%              (Fw_theta >= 67.5 & Fw_theta <= 90)) = 90;
%     Fw_theta(Fw_theta > -67.5 & Fw_theta <= -22.5) = 45;
%     Fw_theta(Fw_theta > -22.5 & Fw_theta < 22.5) = 0;
%     Fw_theta(Fw_theta >= 22.5 & Fw_theta < 67.5) = -45;
%     
%     % Apply non-maximum surpression in Fv direction
%     for u = 1:size(Fw, 1)
%         for v = 1:size(Fw, 2)
%             if Fw_theta(u, v) == 90 && checkVert(Fw, u, v)
%                 Fw(u, v) = 0;
%             elseif Fw_theta(u, v) == 45 && checkDiagUR(Fw, u, v)
%                 Fw(u, v) = 0;
%             elseif Fw_theta(u, v) == 0 && checkHor(Fw, u, v)
%                 Fw(u, v) = 0;
%             elseif Fw_theta(u, v) == -45 && checkDiagDR(Fw, u, v)
%                 Fw(u, v) = 0;
%             end
%         end
%     end
%     
%     % Hysteresis thresholding
%     Fw(Fw < 0.08) = 0;
% 
% end
% 
% function [no_edge] = checkVert(Fw, u, v)
% % Check if edge is maximum in specific direction
% 
%     if u == 1
%         no_edge = (Fw(u, v) ~= max(Fw(u, v), Fw(u + 1, v)));
%     elseif u == size(Fw, 1)
%         no_edge = (Fw(u, v) ~= max(Fw(u, v), Fw(u - 1, v)));
%     else
%         no_edge = (Fw(u, v) ~= max(Fw(u, v), max(Fw(u + 1, v), Fw(u - 1, v))));
%     end
% end
% 
% function [no_edge] = checkDiagUR(Fw, u, v)
% % Check if edge is maximum in specific direction
% 
%     if (u == 1 && v == 1) || (u == size(Fw, 1) && v == size(Fw, 2))
%         no_edge = 0;
%     elseif u == 1 || v == size(Fw, 2)
%         no_edge = (Fw(u, v) ~= max(Fw(u, v), Fw(u + 1, v - 1)));
%     elseif u == size(Fw, 1) || v == 1
%         no_edge = (Fw(u, v) ~= max(Fw(u, v), Fw(u - 1, v + 1)));
%     else
%         no_edge = (Fw(u, v) ~= max(Fw(u, v), max(Fw(u - 1, v + 1), Fw(u + 1, v - 1))));
%     end
% end
% 
% function [no_edge] = checkHor(Fw, u, v)
% % Check if edge is maximum in specific direction
% 
%     if v == 1
%         no_edge = (Fw(u, v) ~= max(Fw(u, v), Fw(u, v + 1)));
%     elseif v == size(Fw, 2)
%         no_edge = (Fw(u, v) ~= max(Fw(u, v), Fw(u, v - 1)));
%     else
%         no_edge = (Fw(u, v) ~= max(Fw(u, v), max(Fw(u, v + 1), Fw(u, v - 1))));
%     end
% end
% 
% function [no_edge] = checkDiagDR(Fw, u, v)
% % Check if edge is maximum in specific direction
% 
%     if (u == 1 && v == size(Fw, 2)) || (u == size(Fw, 1) && v == 1)
%         no_edge = 0;
%     elseif u == 1 || v == 1
%         no_edge = (Fw(u, v) ~= max(Fw(u, v), Fw(u + 1, v + 1)));
%     elseif u == size(Fw, 1) || v == size(Fw, 2)
%         no_edge = (Fw(u, v) ~= max(Fw(u, v), Fw(u - 1, v - 1)));
%     else
%         no_edge = (Fw(u, v) ~= max(Fw(u, v), max(Fw(u - 1, v - 1), Fw(u + 1, v + 1))));
%     end
% end