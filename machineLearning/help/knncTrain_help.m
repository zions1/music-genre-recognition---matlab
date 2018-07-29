%% knncTrain
% Training of KNNC (K-nearest neighbor classifier)
%% Syntax
% * 		knncPrm=knncTrain(DS)
% * 		knncPrm=knncTrain(DS, knncTrainPrm)
%% Description
%
% <html>
% <p>knncPrm = knncTrain(DS, knncTrainPrm, plotOpt) returns the parameters of KNNC after training, where
% 	<ul>
% 	<li>DS: the training set
% 	<li>knncTrainPrm: parameters for training, including
% 		<ul>
% 		<li>knncTrainPrm.method: 'none', 'kMeans', or 'kMeans&lvq'
% 		<li>knncTrainPrm.centerNum4eachClass: no. of prototypes for each class
% 		</ul>
% 	<li>knncPrm: parameters for KNNC, including the following necessary fields:
% 		<ul>
% 		<li>knncPrm.method: method for training
% 			<ul>
% 			<li>'none': none
% 			<li>'kMeans': k-means clustering for training
% 			</ul>
% 		<li>knncPrm.k: the value of k in KNNR
% 		<li>knncPrm.class: class parameters
% 			<ul>
% 			<li>knncPrm.class(i).data: prototypes (centers) for class i
% 			</ul>
% 		</ul>
% 	</ul>
% </html>
%% Example
%%
%
knncTrainOpt=knncTrain('defaultOpt');
knncTrainOpt.method='kMeans';
knncTrainOpt.centerNum4eachClass=4;
[trainSet, testSet]=prData('3classes');
[knncPrm, logLike, recogRate]=knncTrain(trainSet, knncTrainOpt, 1);
fprintf('Inside recog. rate=%.2f%%\n', recogRate*100);
cClass=knncEval(testSet, knncPrm);
hitIndex=find(cClass==testSet.output);
recogRate=length(hitIndex)/length(cClass);
fprintf('Outside recog. rate=%.2f%%\n', recogRate*100);
testSet.hitIndex=hitIndex;
figure; knncPlot(testSet, knncPrm, 'decBoundary');
