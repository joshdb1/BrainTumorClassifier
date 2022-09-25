%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @author Joshua Brock
% CS5680 Final Project
%
% main: run all functions to train and test SVM tumor classifier and
% display the results after
%
% Input:
%   kernelFn (optional: default='linear'): Kernel function to use in
%       training the SVM. Available options: 'linear' 'rbf' 'gaussian'
%   bPlot (optional: default=false): Boolean to plot intermediate 
%       processing steps (true) or not (false)
%   numTraining (optional: default=60): The number of training data to use
%       for each class yes and no
%   resizeVal (optional: default=[2000, 2000]): The size to pad each image
%       to for training the SVM. Note: Don't change this unless you have a
%       really good reason to. 2000x2000 is sufficient for all the images
%       in the data set used here.
%
% Outputs:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function main(kernelFn, bPlot, numTraining, resizeVal)

    %% Check for inputs, set defaults if necessary
    if nargin < 4
        resizeVal = [2000, 2000];
    end
    if nargin < 3
        numTraining = 60;
    end
    if nargin < 2
        kernelFn = 'linear';
    end
    if nargin < 1
        bPlot = false;
    end

    tic
    %% get the data information stuct
    dataSet = getDataSetStruct();
    toc

    tic
    %% proprocess and output the data
    preprocImages(dataSet, bPlot, resizeVal);
    toc

    tic
    %% setup the training and test data
    [trainingSets, testSets] = setupTrainTestImages(numTraining);
    toc

    %% Feature Extaction using Matlab's bag of features
    tic
    bag = bagOfFeatures(trainingSets);
    if bPlot
        imds = imageDatastore('tmp', 'IncludeSubfolders', true, ...
            'LabelSource', 'foldernames');
        featureVector = encode(bag, readimage(imds,15));
        
        figure(4);
        bar(featureVector);
        title('Visual word occurances');
        xlabel('Visual word index');
        ylabel('Frequency of occurance');
    end
    toc

    tic
    %% train the image SVM classifier
    tumorClassifier = trainClassifer(trainingSets, bag, kernelFn);
    toc

    %% Evaluate classifier performance
    tic
    disp("Evaluating the classifier on test images");
    [confMat, knownLabelIdx, predLabelIdx, score] = ...
        evaluate(tumorClassifier, testSets, 'Verbose', true);
    toc

    disp("Total prediction accuracy");
    mean(diag(confMat));

end
