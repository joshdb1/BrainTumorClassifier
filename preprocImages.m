%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @author Joshua Brock
% 
% preprocImages: preprocess the images and saves them to temp directory
%
% Inputs:
%   dataSet: The data to preprocess
%   bPlot: Plot intermediate steps? (true/false)
%   resizeVal: The size to pad each image to
% 
% Outputs:
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function preprocImages(dataSet, bPlot, resizeVal)
    % these are just used for filenames in temp directory   
    idxYes = 0;
    idxNo = 0;
    
    %% loop through each data
    for file = dataSet
        %% read the file
        filename = string(file.filename);
        img = imread(filename);
        
        % convert to grayscale between 0 and 1
        img = im2gray(img);
        img = rescale(img);

        %% Enhance the image
        % this is a change here because the paper enhancement method is
        % only good for image sets that are not all enhanced
        imgEnhance = imadjust(img);%enhance(img);

        if bPlot
            figure(1)
            % original image
            subplot(2,2,1);
            imagesc(img);
            title("Original Image");
            subplot(2,2,2);
            histogram(img(:));
            title("Original Histogram");
            
            % enhanced image
            subplot(2,2,3);
            imagesc(imgEnhance);
            title("Enhanced Image");
            subplot(2,2,4);
            histogram(imgEnhance(:));
            title("Enhanced Histogram");
            colormap gray
            print -dpng imgEnhance.png    
            
            
        end

        %% perform skull stripping
        imgSkullStrip = skullStrip(imgEnhance);

        if bPlot
            figure(2)
            imagesc(imgSkullStrip);
            title("Skull Stripping Step");
            colormap gray
            print -dpng imgSkullStrip.png
        end

        %% perform k-means clustering to get segmentation
        imgSeg = segmentation(imgSkullStrip);

        if bPlot
            figure(3)
            imagesc(imgSeg);
            title(sprintf("Image Segmentation Step\n"...
                + "(3 segments - 1 for background, 2 for brain"));
            colormap jet
            print -dpng imgSeg.png
        end

        %% Save the preprocessed images in tmp directory
        padSz = resizeVal - size(imgSeg);
        imgResize = padarray(imgSeg, padSz);%, 'post');

        if file.label == 0
            idxNo = idxNo + 1;
            imwrite(imgResize, sprintf('tmp/no/tmp%d.jpg',idxNo));
        else
            idxYes = idxYes + 1;
            imwrite(imgResize, sprintf('tmp/yes/tmp%d.jpg',idxYes));
        end
    end

    %% Done with preprocessing
    disp("Finished Preprocessing on Training Data");
end