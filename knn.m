function knn(input, desired, outputName, showPlot)

Mdl = fitcknn(input,desired,'NumNeighbors',10,'Standardize',1);

[label,score,cost] = predict(Mdl,input);
error = abs(loss(Mdl, input, desired));
fprintf('Accurancy = %g%% for testing data set.\n', (1-error)*100)

if showPlot
    figure;
    confMat1 = confMatGet(desired, label');
    cmOpt1=confMatPlot('defaultOpt');
    cmOpt1.className=outputName;
    confMatPlot(confMat1, cmOpt1); figEnlarge;
end
