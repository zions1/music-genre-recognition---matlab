function [accuracy, confMat] = knn(train, trainDesired, test, testDesired, outputName, showPlot)

Mdl = fitcknn(train,trainDesired,'NumNeighbors',3,'Standardize',1);

[label,~,~] = predict(Mdl,test);
error = sum(label - testDesired ~= 0) / length(testDesired);
accuracy = (1-error)*100;
confMat = confMatGet(testDesired, label');

% Plot the confusion matrix of classification result.
if showPlot
    
    %confMat = confMatGet(desired, computed);
    opt=confMatPlot('defaultOpt');
    opt.className=outputName;
    opt.mode='both';
    figure; confMatPlot(confMat, opt);
    
%     figure;    
%     cmOpt1=confMatPlot('defaultOpt');
%     cmOpt1.className=outputName;
%     confMatPlot(confMat, cmOpt1); figEnlarge;
end
