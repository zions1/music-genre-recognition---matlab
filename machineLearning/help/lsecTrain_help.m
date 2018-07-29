%% lsecTrain
% Training the LSE (least-square estimate) classifier (LSEC)
%% Syntax
% * 		cPrm=qcTrain(DS)
% * 		cPrm=qcTrain(DS, opt)
% * 		[cPrm, logLike, recogRate, hitIndex]=qcTrain(DS, opt, showPlot)
% * 			DS: data set for training
% * 			opt: parameters for training
% * 			showPlot: 1 for plotting
% * 			cPrm: the parameters for LSEC.
% * 			recogRate: R-square for linear regression
% * 			hitIndex: index of the correctly classified data points
%% Description
%
% <html>
% <p>cPrm=lsecTrain(DS) returns the parameters of the least-square estimate (LSE) classifier based on the given dataset DS.
% <p>cPrm=lsecTrain(DS, opt) uses the train parameters opt for training the LSEC.
% <p>cPrm=lsecTrain(DS, opt, showPlot) plots the decision boundary of the LSEC (if the feature dimensionity is 2).
% <p>[cPrm, logLike, recogRate, hitIndex]=qcTrain(DS, ...) also returns the log likelihood, recognition rate, and the hit indice of data instances in DS.
% </html>
%% Example
%%
%
DS=prData('iris');
DS.input=DS.input(3:4, :);
trainSet.input=DS.input(:, 1:2:end); trainSet.output=DS.output(:, 1:2:end);
 testSet.input=DS.input(:, 2:2:end);  testSet.output=DS.output(:, 2:2:end);
[cPrm, logLike1, R1]=lsecTrain(trainSet);
[computedClass, logLike2, R2]=lsecEval(testSet, cPrm, 1);
fprintf('Inside R-square = %g\n', R1);
fprintf('Outside R-square = %g\n', R2);
%% See Also
% <lsecEval_help.html lsecEval>.
