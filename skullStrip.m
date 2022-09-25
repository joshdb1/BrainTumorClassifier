%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @author Joshua Brock
% 
% skullStrip: remove the skull from the input MRI image. Note that all of
% this is my changed skull strip method because I do both open-close and
% close-open with variable size structuring elements
%
% Inputs:
%   img: the image to skull strip
%
% Outputs:
%   imgOut: the skull-stripped output image
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function imgOut = skullStrip(img)
    imgSzOrig = size(img);
    %% Double Threshold
    pad = uint32(1 * size(img));
    img = padarray(img, double(pad));
    tmp = (img >= 0.1) & (img <= 0.88);
    
    %% size the structuring element based on the input image size. This will
    % help with not over or under eroding.
    seSz = double(uint32(max(3, max(imgSzOrig) / 30)));
    
    %% Perform open-close operation to get rid of skull
    % Do an erosion operations 
    se1 = strel('disk',seSz);
    tmp = imerode(tmp, se1);

    % Dilate
    % reverse the erosions with dilations. This should get rid of
    % the skull
    tmp = imdilate(tmp, se1);
    
    %% size the new structuring element based on the padded size. This will
    % help fill any unwanted wholes in the image as a result of the
    % previous open-close operation
    se2 = strel('disk', double(uint32(min(pad) / 5)));
    
    %% perform close-open operation with se2
    tmp = imdilate(tmp, se2);
    tmp = imerode(tmp, se2);
    
    %% Mask
    imgOut = (double(tmp) .* double(img));
    imgOut = imgOut(pad(1)+1:end-pad(1), pad(2)+1:end-pad(2));   
end