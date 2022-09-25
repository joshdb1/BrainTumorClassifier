%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% @author Joshua Brock
% 
% getDataSetStruct: populates the data set struct with filenames of data to
% use for training and testing
%
% Inputs:
%
% Outputs:
%   dataSet: The struct array containing the information of filenames and
%       classifications for training and testing the SVM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dataSet = getDataSetStruct()
    %% Get the filenames and labels
    listingYes = dir('brain_tumor_dataset/yes/');
    listingNo = dir('brain_tumor_dataset/no/');

    % add to yes filenames
    j = 0;
    for i = 1 : numel(listingYes)
        % for every yes filename (except . and ..) add it to yes names
        if strcmp(string(listingYes(i).name), '.') || strcmp(string(listingYes(i).name), '..')
            continue;
        end
        tmp = string(listingYes(i).folder) + "/" + string(listingYes(i).name);
        j = j + 1;
        yesNames{j} = tmp;
    end
    
    % add to no filenames
    j = 0;
    for i = 1 : numel(listingNo)
        % for every no filename (except . and ..) add to no names
        if strcmp(string(listingYes(i).name), '.') || strcmp(string(listingYes(i).name), '..')
            continue;
        end

        tmp = string(listingNo(i).folder) + "/" + string(listingNo(i).name);
        j = j + 1;
        noNames{j} = tmp;
    end
    clear tmp;

    %% populate dataSet
    % preallocate for speed
    dataSet(1:numel(yesNames)+numel(noNames)) = ...
        struct('filename', 'tmp', 'label', 0);

    i = 0;
    % yes
    for filename = yesNames
        i = i + 1;
        tmp.filename = filename;
        tmp.label = 1;  % yes
        dataSet(i) = tmp;
    end
    % no
    for filename = noNames
        i = i + 1;
        tmp.filename = filename;
        tmp.label = 0;  % no
        dataSet(i) = tmp;
    end

    %% randomize the order (make sure training is unbiased)
    dataSetNew(1:numel(yesNames)+numel(noNames)) = ...
        struct('filename', 'tmp', 'label', 0);
    idxs = randperm(numel(dataSet));
    for i = 1 : numel(dataSet)
        dataSetNew(i) = dataSet(idxs(i));
    end
    dataSet = dataSetNew;
end