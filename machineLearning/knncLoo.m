function [recogRate, computed, nearestIndex] = knncLoo(DS, opt, showPlot)
%knncLoo: Leave-one-out recognition rate of KNNC
%
%	Usage:
%		recogRate=knncLoo(DS)
%		recogRate=knncLoo(DS, opt)
%		recogRate=knncLoo(DS, opt, showPlot)
%		[recogRate, computed, nearestIndex]=knncLoo(...)
%
%	Description:
%		recogRate=knncLoo(DS) returns the recognition rate of the KNNC over the dataset DS based on the leave-one-out criterion.
%		recogRate=knncLoo(DS, opt) uses the parameters in opt for the computation. (In fact, only opt.k will be used for this function.)
%		recogRate=knncLoo(DS, opt, showPlot) plots the results if the dimension of the dataset is 2.
%		[recogRate, computed, nearestIndex]=knncLoo(...) also returns the computed class and the nearest index of each data instance.
%		opt=knncLoo('defaultOpt') returns the default options obtain from knncTrain('defaultOpt'). (In fact, only opt.k will be used for this function.)
%
%	Example:
%		DS=prData('iris');
%		DS.input=DS.input(3:4, :);	% Use the last 2 dims for plotting
%		opt=knncLoo('defaultOpt');
%		showPlot=1;
%		tic
%		[recogRate, computed, nearestIndex] = knncLoo(DS, opt, showPlot);
%		fprintf('Elapsed time = %g sec\n', toc);
%		fprintf('Recog. rate = %.2f%% for %s dataSet\n', 100*recogRate, DS.dataName);
%
%	See also knncEval, knncTrain.

%	Category: K-nearest-neighbor classifier
%	Roger Jang, 19970628, 20040928

if nargin<1, selfdemo; return; end
if ischar(DS) && strcmpi(DS, 'defaultOpt')	% Set the default options
	recogRate=knncTrain('defaultOpt');
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

[dim, dataCount]=size(DS.input);
nearestIndex=zeros(1, dataCount);
computed=zeros(size(DS.output));
batchSize=round(dataCount/10);
useMex=1;
if useMex	% Use mex file for fast computation
	for i=1:dataCount
	%	if rem(i, batchSize)==0, fprintf('%d/%d\n', i, dataCount); end
		nnIndex=knnMex(DS.input(:,i), DS.input, 2, opt.k, i);
		computed(i)=mode(DS.output(nnIndex));
	end
else	% Original M-file implementation
	for i=1:dataCount
	%	if rem(i, batchSize)==0, fprintf('%d/%d\n', i, dataCount); end
		looData = DS;
		looData.input(:,i) = [];
		looData.output(:,i) = [];
		looData.k = opt.k;
		TS.input=DS.input(:,i);
		TS.output=DS.output(:,i);
		[computed(i), junk, junk, junk, tmp]=knncEval(TS, looData);
		nearestIndex(i) = tmp(1);
		if nearestIndex(i)>=i,
			nearestIndex(i)=nearestIndex(i)+1;
		end
	end
end
hitIndex=find(DS.output==computed);
recogRate=length(hitIndex)/dataCount;

if showPlot
	DS.hitIndex=hitIndex;
	dsScatterPlot(DS);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
