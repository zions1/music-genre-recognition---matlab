function [recogRate, computedClass]=perfLoo(DS, classifier, classifierOpt, showPlot)
%perfLoo: Leave-one-out accuracy of given dataset and classifier
%
%	Usage:
%		recogRate=perfLoo(DS, classifier, classifierOpt)
%		recogRate=perfLoo(DS, classifier, classifierOpt, showPlot)
%		[recogRate, computedClass]=perfLoo(...)
%
%	Description:
%		recogRate=perfLoo(DS, classifier, classifierOpt) returns the leave-one-out recognition rate of the given dataset and classifier.
%			recogRate: recognition rate
%			DS: Dataset
%				DS.input: Input data (each column is a feature vector)
%				DS.output: Output class (ranging from 1 to N)
%			classifierOpt: Training parameters for the classifier
%		recogRate=perfLoo(DS, classifier, classifierOpt, 1) also plots the dataset and misclasified instances (if the dimension is 2).
%		[recogRate, computedClass]=perfLoo(...) also returns the computed class of each data instance in DS.
%
%	Example:
%		DS=prData('random2');
%		DS=prData('iris');
%		DS.input=DS.input(3:4, :);	% Use the last 2 dims for plotting
%		showPlot=1;
%		tic
%		[recogRate, computed] = perfLoo(DS, 'knnc', [], showPlot);
%		fprintf('Elapsed time = %g sec\n', toc);
%		fprintf('Recog. rate = %.2f%% for %s dataSet\n', 100*recogRate, DS.dataName);
%
%	See also perfCv4classifier, perfCv.

%	Category: Performance evaluation
%	Roger Jang, 20130513

if nargin<1, selfdemo; return; end
if nargin<2|isempty(classifier), classifier='qc'; end
if nargin<3|isempty(classifierOpt), classifierOpt=feval([classifier, 'Train'], 'defaultOpt'); end
if nargin<4, showPlot=0; end

% Use of groupId for LOO evaluation
if ~isfield(DS, 'groupId')
	groupId=1:size(DS.input,2);
else
	groupId=DS.groupId;
end
uniqueGroup=unique(groupId);

[dim, dataCount]=size(DS.input);
nearestIndex=zeros(1, dataCount);
computedClass=zeros(1, length(DS.output));

if strcmp(classifier, 'knnc')
	[recogRate, computedClass] = knncLoo(DS, classifierOpt);	% Invoke this branch for fast computation
else
	for i=1:length(uniqueGroup)
%		if rem(i, 100)==0, fprintf('%d/%d\n', i, dataCount); end
		tId=find(uniqueGroup(i)==groupId);	% ID of test data entries
		tData=DS;		% Training data
		tData.input(:,tId)=[];
		tData.output(:,tId)=[];
		vData.input=DS.input(:,tId);	% Validation data
		vData.output=DS.output(:,tId);
		classifierPrm=feval([classifier, 'Train'], tData);
		computedClass(tId)=feval([classifier, 'Eval'], vData, classifierPrm);
	end
end

hitIndex = find(DS.output==computedClass);
recogRate = length(hitIndex)/dataCount;

if showPlot
	DS.hitIndex=hitIndex;
	dsScatterPlot(DS);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
