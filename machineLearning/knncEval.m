function [computedClass, logLike, recogRate, hitIndex, nnIndex] = knncEval(testSet, knncPrm, plotOpt)
% knncEval: K-nearest neighbor classifier (KNNC)
%
%	Usage:
%		[computedClass, overallComputedClass, nnIndex, knncMat]=knncEval(testSet, knncPrm)
%
%	Description:
%		computedClass = knncEval(testSet, knncPrm) returns the results of KNNC, where
%			testSet: the test set
%			knncPrm: parameters for KNNC
%				knncPrm.k: the value of k for k-nearest neighbor classification
%			computedClass: output vector by KNNC
%		[computedClass, logLike, recogRate hitIndex, nnIndex] = knncEval(testSet, knncPrm) returns extra info:
%			testSet: the test set
%			logLike: log likelihood for each of the test set
%			recogRate: recognition rate
%			hitIndex: index of correctly classified test pairs
%			nnIndex: index of knncPrm.input that are closest to testSet.input
%
%	Example:
%		[trainSet, testSet]=prData('iris');
%		trainNum=size(trainSet.input, 2);
%		testNum =size(testSet.input, 2);
%		fprintf('Use of KNNC for Iris data:\n');
%		fprintf('\tSize of train set (odd-indexed data) = %d\n', trainNum);
%		fprintf('\tSize of test set (even-indexed data) = %d\n', testNum);
%		knncTrainPrm.method='none';
%		knncPrm=knncTrain(trainSet, knncTrainPrm);
%		fprintf('\tRecognition rates as K varies:\n');
%		kMax=15;
%		for k=1:kMax
%			knncPrm.k=k;
%			computed=knncEval(testSet, knncPrm);
%			correctCount=sum(testSet.output==computed);
%			recogRate(k)=correctCount/testNum;
%			fprintf('\t%d-NNC ===> RR = 1-%d/%d = %.2f%%.\n', k, testNum-correctCount, testNum, recogRate(k)*100);
%		end
%		plot(1:kMax, recogRate*100, 'b-o'); grid on;
%		title('Recognition rates of Iris data using KNN classifier');
%		xlabel('K'); ylabel('Recognition rates (%)');
%
%	Category: K-nearest-neighbor classifier
%	Roger Jang, 19970331, 20040928, 20110429

if nargin<1, selfdemo; return; end
if nargin<2|isempty(knncPrm), knncPrm.k=1; end
if nargin<3, plotOpt=0; end
[computedClass, logLike, recogRate, hitIndex, nnIndex]=classifierEval('knnc', testSet, knncPrm, plotOpt);

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);