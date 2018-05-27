function [train, test1, trainDesired, testDesired] = createTrainAndTestSets(input, desired, trainSize)
% Create Data Matrix
% Create Ideal Output Matrix
% row_idx = randperm(length(input), trainSize)';    % Vector Or Random Rows — Use The ‘row_idx’ I Created For Your Larger Matrix In Your Code
% train_Idx = false(size(input,1),1);                 % Logical Vector
% train_Idx(row_idx) = true;                              % Training Rows
% test_Idx = ~train_Idx;                                  % Testing Rows

CVP = cvpartition(desired, 'Holdout', 1- trainSize);  % Cross-validation data partition
isIdx = training(CVP);  % Training sample indices
oosIdx = test(CVP);

train = input(isIdx,:);                         % Train Data
test1 = input(oosIdx,:);                           % Test Data
trainDesired = desired(isIdx,:);                % Train Desired Data
testDesired = desired(oosIdx,:);                  % Test Desired Data



