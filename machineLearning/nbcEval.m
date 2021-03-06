function [computedClass, logLike, recogRate, hitIndex]=nbcEval(DS, cPrm, showPlot)
% nbcEval: Evaluation for the NBC (naive bayes classifier)
%
%	Usage:
%		[computedClass, logLike, recogRate, hitIndex]=nbcEval(DS, cPrm, showPlot)
%		If DS does not have "output" field, then this command won't return "recogRate" and "hitIndex".
%
%	Description:
%		[computedClass, logLike, recogRate, hitIndex]=nbcEval(DS, cPrm, showPlot) returns the evaluation results of NBC
%
%	Example:
%		DS=prData('iris');
%		DS.input=DS.input(3:4, :);
%		trainSet.input=DS.input(:, 1:2:end); trainSet.output=DS.output(:, 1:2:end);
%		 testSet.input=DS.input(:, 2:2:end);  testSet.output=DS.output(:, 2:2:end);
%		[cPrm, logLike1, recogRate1]=nbcTrain(trainSet);
%		[computedClass, logLike2, recogRate2, hitIndex]=nbcEval(testSet, cPrm, 1);
%		fprintf('Inside recog rate = %g%%\n', recogRate1*100);
%		fprintf('Outside recog rate = %g%%\n', recogRate2*100);
%
%	See also nbcTrain, nbcPlot.

%	Category: Naive Bayes classifier
%	Roger Jang, 20110428

classifier='nbc';
if nargin<1, selfdemo; return; end
if nargin<2, cPrm=[]; end
if nargin<3, showPlot=0; end
[computedClass, logLike, recogRate, hitIndex]=classifierEval(classifier, DS, cPrm, showPlot);

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
