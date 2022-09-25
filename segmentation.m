%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @author: Joshua Brock
% 
% segmentation: Uses fuzzy c-means to segment the image and outputs the
% segmented image.
%
% Inputs:
%   img: the input image to segment
%
% Outputs:
%   segImg: the segmented image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [segImg] = segmentation(img)
    sz = size(img);
    data = img(:);
    
    %% Use Matlab's fcm function to find the fuzzy c-means
    % find 3 segments (1 for background, 2 for brain tissue)
    [center, U, objFn] = fcm(data, 3, [2,100,1e-5,0]); % suppress disp
    maxU = max(U);
    
    %% Sort the centers to make all images consistent.
    [center,cIdx] = sort(center);
    
    %% Find the appropriate indices for image reformation
    U = U(cIdx(end:-1:1),:);
    idx1 = find(U(1,:) == maxU);
    idx2 = find(U(2,:) == maxU);
    idx3 = find(U(3,:) == maxU);
    
    %% Reform the segmented image. 
    % 0.0 represents background, 0.5 and 1.0 represent brain tissue
    segImg(1:length(data))=0;
    segImg(idx1) = 1.0;
    segImg(idx2) = 0.5;
    segImg(idx3) = 0.0;
    
    % reshape the vectored image to a matrix
    segImg = reshape(segImg, sz);
end