%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @author Joshua Brock
% 
% setupTrainTestImages: set up the training and test data and return the
% training and test set filenames
%
% Inputs:
%   numTraining: The number of training images to use
%
% Outputs:
%   trainingSets: array of structs containing filename and class info for
%       the training data
%   testSets: array of structs containing filename and class info for the
%       testing data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [trainingSets, testSets] = setupTrainTestImages(numTraining)
    % classes (yes for yes there is a brain tumor, no for no)
    classNames = {'yes', 'no'};
    numClasses = length(classNames);

    %% read in the file names
    % this only reads in the file names and not the data. We'll read the 
    % data later
    imgSets = [];
    for i = 1:numClasses
        imgSets = [imgSets, imageSet(fullfile('tmp', classNames{i}))];
    end

    %% make the image numbers even so we don't bias the SVM
    minSetCt = min([imgSets.Count]);
    imgSets = partition(imgSets, minSetCt, 'randomize');

    %% Separate the image sets into training and test data. Randomize to 
    % avoid biasing the SVM
    [trainingSets, testSets] = partition(imgSets, numTraining, 'randomize');
    
    disp("Finished setting up training and test data");
end