function [recogRate, bestFeaNum, computedClass]=ldaPerfViaKnncLoo(DS, opt, plotOpt)
% ldaPerfViaKnncLoo: LDA recognition rate via KNNC and LOO performance index
%
%	Usage:
%		recogRate=ldaPerfViaKnncLoo(DS)
%		recogRate=ldaPerfViaKnncLoo(DS, opt)
%		recogRate=ldaPerfViaKnncLoo(DS, opt, plotOpt)
%		[recogRate, bestFeaNum, computedClass]=ldaPerfViaKnncLoo(...);
%
%	Description:
%		recogRate=ldaPerfViaKnncLoo(DS) return the leave-one-out recognition rate of KNNC on the dataset DS after dimension reduction using LDA (linear discriminant analysis)
%			DS: the dataset
%		recogRate=ldaPerfViaKnncLoo(DS, opt) uses LDA with the option opt:
%			opt.maxDim: Use this value as the max. dimensions after LDA projection
%			opt.mode:
%				'approximate' (default) for approximate evaluation which uses all dataset for LDA project
%				'exact' for true leave-one-out test, which takes longer
%		The default value of option can be obtained by ldaPerfViaKnncLoo('defaultOpt').
%		recogRate=ldaPerfViaKnncLoo(DS, opt, 1) plots the recognition rates w.r.t. dimensions after LDA transformation.
%
%	Example:
%		% === Using LDA over WINE dataset
%		opt=ldaPerfViaKnncLoo('defaultOpt');
%		opt.mode='approximate';
%		DS=prData('wine');
%		recogRate1=ldaPerfViaKnncLoo(DS, opt, 1);
%		% === Compare two mode of LDA performance evaluation via KNNC-LOO
%		opt=ldaPerfViaKnncLoo('defaultOpt');
%		opt.mode='approximate';
%		DS=prData('wine');
%		tic; recogRate1=ldaPerfViaKnncLoo(DS, opt); time1=toc;
%		opt.mode='exact';
%		tic; recogRate2=ldaPerfViaKnncLoo(DS, opt); time2=toc;
%		figure;
%		plot(1:length(recogRate1), 100*recogRate1, '.-', 1:length(recogRate2), 100*recogRate2, '.-'); grid on
%		xlabel('No. of projected features based on LDA');
%		ylabel('LOO recognition rates using KNNC (%)');
%		title('Without input normalization');
%		legend('mode=''approximate''', 'mode=''exact''', 'location', 'southwest');
%		fprintf('time for approximate mode=%g sec, time for exact mode=%g sec\n', time1, time2);
%		% === Effect of input normalization of LDA over WINE dataset (with both modes) 
%		opt=ldaPerfViaKnncLoo('defaultOpt');
%		DS=prData('wine');
%		DS2=DS; DS2.input=inputNormalize(DS2.input);
%		opt.mode='approximate';
%		rr11=ldaPerfViaKnncLoo(DS, opt);
%		rr12=ldaPerfViaKnncLoo(DS2, opt);
%		opt.mode='exact';
%		rr21=ldaPerfViaKnncLoo(DS, opt);
%		rr22=ldaPerfViaKnncLoo(DS2, opt);
%		figure;
%		xVec=1:length(recogRate1);
%		plot(xVec, 100*rr11, '.-b', xVec, 100*rr12, '.-m'); grid on
%		hold on; plot(xVec, 100*rr21, '^-b', xVec, 100*rr22, '^-m'); hold off
%		xlabel('No. of projected features based on LDA');
%		ylabel('LOO recognition rates using KNNC (%)');
%		title('With both modes');
%		legend('approximate mode, w/o input normalization', 'approximate mode, w/ input normalization', 'exact mode, w/o input normalization', 'exact mode, w/ input normalization', 'location', 'southwest');
%
%	See also lda.

%	Category: Data dimension reduction
%	Roger Jang, 20060507, 20111021

if nargin<1, selfdemo; return; end
% ====== Set the default options
if ischar(DS) && strcmpi(DS, 'defaultOpt')
	recogRate.maxDim=inf;
	recogRate.mode='approximate';
	return
end
[featureNum, dataNum]=size(DS.input);
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, plotOpt=0; end

if isinf(opt.maxDim)||isempty(opt.maxDim)||isnan(opt.maxDim), opt.maxDim=featureNum; end
maxDim=min(opt.maxDim, featureNum);

% Use of groupId for LOO evaluation
if ~isfield(DS, 'groupId')
	groupId=1:size(DS.input,2);
else
	groupId=DS.groupId;
end
uniqueGroup=unique(groupId);

switch(lower(opt.mode))
	case 'approximate'		% This part needs modification to take consideration of groupId
		DS2 = lda(DS, maxDim);
		maxDim=size(DS2.input, 1);	% Dimension may reduce due to possible complex eigenvectors in LDA
		computedClass=zeros(dataNum, maxDim);	% Computed class
		recogRate=zeros(1, maxDim);
		for i=1:maxDim
			DS3=DS2; DS3.input=DS2.input(1:i, :);
			[recogRate(i), computed] = knncLoo(DS3);
			hitCount=sum(DS.output==computed);
			computedClass(:,i)=computed(:);
			if plotOpt
				fprintf('\t\tLOO recog. rate of KNNC using %d dim = %d/%d = %g%%\n', i, hitCount, dataNum, 100*recogRate(i));
			end
		end
	case 'exact'
		computedClass=zeros(dataNum, maxDim);	% Computed class
		hitMat=zeros(dataNum, maxDim);		% 1 indicates a hit
		for i=1:length(uniqueGroup)
			tId=find(uniqueGroup(i)==groupId);	% ID of test data entries
			testDS.input=DS.input(:, tId);
			testDS.output=DS.output(:, tId);
			DS2=DS;
			DS2.input(:, tId)=[];
			DS2.output(:, tId)=[];
			[DS3, ldaVec]=lda(DS2);
			for j=1:maxDim
				DS4=DS3; DS4.input=DS4.input(1:j,:);	% Take the first j inputs
				testDS2=testDS;
				testDS2.input=ldaVec(:,1:j)'*testDS2.input;
				computedClass(tId, j)=knncEval(testDS2, DS4);
			%	hitMat(i,j)=computedClass(i,j)==testDS2.output;
			end
			hitMat(tId,:)=computedClass(tId,:)==testDS2.output(:);
		end
		recogRate=mean(hitMat);
	otherwise
		error('Unknown mode!');
end
[maxRR, bestFeaNum]=max(recogRate);

if plotOpt
	plot(1:maxDim, 100*recogRate, '.-'); grid on
	line(bestFeaNum, 100*maxRR, 'color', 'r', 'marker', 'o');
	titleStr=sprintf('Max RR = %f%% when dim = %d', maxRR*100, bestFeaNum);
	title(titleStr);
	xlabel('No. of projected features based on LDA');
	ylabel('LOO recognition rates using KNNC (%)');
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
