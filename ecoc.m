function [accuracy, confMat] = ecoc(input, desired, outputName, trainSize, showPlot)

classOrder = unique(desired');
t = templateSVM('Standardize',1,'KernelFunction','linear'); % Use SVM classifier
CVMdl = fitcecoc(input, desired, 'Holdout', 1 - trainSize, 'Learners',t,'ClassNames',classOrder);
CMdl = CVMdl.Trained{1};           % Extract trained, compact classifier
testInds = test(CVMdl.Partition);  % Extract the test indices
XTest = input(testInds,:);
YTest = desired(testInds,:);
labels = predict(CMdl,XTest);

genErr = sum(labels - YTest ~= 0) / length(YTest);
accuracy = (1-genErr)*100;
confMat = confMatGet(YTest, labels);

% Plot the confusion matrix of classification result.
if showPlot
    figure;
    cmOpt1=confMatPlot('defaultOpt');
    cmOpt1.className=outputName;
    confMatPlot(confMat, cmOpt1); figEnlarge;
end
