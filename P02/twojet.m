function [ jet2 ] = twojet( img, sigma, stepsize, method )
    % calculates the 2 jet of an image
%     
%     F = img;
%     if (method == 'standard')
%         Fx = imfilter(F, [1/2 0 -1/2], 'conv', 'replicate');
%         Fy = imfilter(F, [1/2 0 -1/2]', 'conv', 'replicate');
%         Fxx = imfilter(F, [0.2500 0 -0.5000 0 0.2500], 'conv', 'replicate');
%         Fyy = imfilter(F, [0.2500 0 -0.5000 0 0.2500]', 'conv', 'replicate');
%         Fxy = imfilter(Fx, [1 0 1;0 0 0; 1 0 1], 'conv', 'replicate');
%     elseif (method == 'gaussian')
%         % gd2 is way better than gd
%         Fx = gD(F, sigma, 1, 0);
%         Fy = gD(F, sigma, 0, 1);
%         Fxx = gD(F, sigma, 2, 0);
%         Fyy = gD(F, sigma, 0, 2);
%         Fxy = gD(F, sigma, 2, 2);
%     else
%         assert(1 == 0, 'method must be gaussian or standard');
%     end
%     
%     img_size = size(img);
%     a = [floor(img_size(1)/2) floor(img_size(2)/2)]';
%     for i=ceil(-img_size(1)/2)+1:floor(img_size(1)/2)
%         for j=ceil(-img_size(2)/2)+1:floor(img_size(2)/2)
%             x = [i j]';
% 
%             gradient = [Fx(a(1), a(2)) Fy(a(1), a(2))]';
% 
%             H = [Fxx(a(1), a(2)) Fxy(a(1), a(2)); Fxy(a(1), a(2)) Fyy(a(1), a(2))];
% 
%             
%             jet2(a(1)+i,a(2)+j) = F(a(1), a(2)) + x' * gradient + 1/2 * x' * H * x;
%         end
%     end
% 
%     if (mod(stepsize, 2) ~= 0)
%         stepsize = stepsize + 1;
%     end
%     
%     jet2 = zeros(img_size);
%     for i=1:stepsize:img_size(1)
%         for j=1:stepsize:img_size(2)
%             for k=-stepsize/2:stepsize/2-1
%                 for l=-stepsize/2:stepsize/2-1
%                     x = [k l]';
%                     a = [i+ceil(stepsize/2) ceil(j+stepsize/2)]';
%                     
%                     % do tayler
%                     gradient = [Fx(a(1), a(2)) Fy(a(1), a(2))]';
%                     H = [Fxx(a(1), a(2)) Fxy(a(1), a(2)); Fxy(a(1), a(2)) Fyy(a(1), a(2))];
%                     jet2(a(1)+x(1),a(2)+x(2)) = F(a(1), a(2)) + x' * gradient + 1/2 * x' * H * x;
%                 end
%             end
%         end
%     end
end

