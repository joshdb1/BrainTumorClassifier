%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @author Joshua Brock
% 
% enhance: enhances the input image using the method from the paper
%
% Inputs:
%   imgIn: the input image to enhance
%
% Outputs:
%   imgOut: the enhanced output image
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [imgOut] = enhance(imgIn)
    % whatever is less than 0.1
    tmp = double(imgIn < 0.1) .* double(0.5 * imgIn);
    
    % whatever is between 0.1 and 0.88
    tmp = tmp + double(0.1 <= imgIn & imgIn <= 0.88) .* ...
        double(0.1 + 1.5 * (imgIn - 0.1));
    
    % whatever is over 0.88
    imgOut = tmp + double(imgIn > 0.88) .* double(1 + 0.5 * (imgIn - 1));
end