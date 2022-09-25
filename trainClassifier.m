%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @author Joshua Brock
% 
% trainClassifier: This trains an SVM classifier using the appropriate
% training sets, bag of features, and kernel function. This uses
% information from 
% http://cs-courses.mines.edu/csci508/schedule/25/CategoryRecognition.pdf
% for setting up the SVM
%
% Inputs:
%   trainingSets: The filenames for the training set data
%   bag: A matlab bag of features containing the feature centers
%   kernelFn: The kernel function to use in training the SVM
%
% Outputs:
%   tumorClassier: The trained SVM tumor classifier
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tumorClassifier = trainClassifier(trainingSets, bag, kernelFn)
    %% Train the image classier
    opts = templateSVM('BoxConstraint', Inf, 'kernelFunction', kernelFn);
    tumorClassifier = trainImageCategoryClassifier(trainingSets, bag, ...
        'LearnerOptions', opts);
    
    disp("Finished Training Tumor Classifier");
end