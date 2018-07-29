function [train, test1, trainDesired, testDesired] = createTrainAndTestSets(input, desired, trainSize)

CVP = cvpartition(desired, 'Holdout', 1 - trainSize);  % Cross-validation data partition
isIdx = training(CVP);  % Training sample indices
oosIdx = test(CVP);

train = input(isIdx,:);             % Train Data
test1 = input(oosIdx,:);            % Test Data
trainDesired = desired(isIdx,:);    % Train Desired Data
testDesired = desired(oosIdx,:);    % Test Desired Data



