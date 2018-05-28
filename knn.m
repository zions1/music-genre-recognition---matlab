function knn(train, trainDesired, test, testDesired, outputName, showPlot)

Mdl = fitcknn(train,trainDesired,'NumNeighbors',10,'Standardize',1);

[label,score,cost] = predict(Mdl,test);
error = abs(loss(Mdl, test, testDesired));
fprintf('Accurancy = %g%% for testing data set.\n', (1-error)*100)

if showPlot
    figure;
    confMat1 = confMatGet(testDesired, label');
    cmOpt1=confMatPlot('defaultOpt');
    cmOpt1.className=outputName;
    confMatPlot(confMat1, cmOpt1); figEnlarge;
end
