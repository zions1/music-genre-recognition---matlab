function [DS2, discrimVec, eigValues] = lda(DS, discrimVecNum)
%lda: Linear discriminant analysis
%
%	Usage:
%		DS2 = lda(DS)
%		DS2 = lda(DS, discrimVecNum)
%		[DS2, discrimVec, eigValues] = lda(...)
%
%	Description:
%		DS2 = lda(DS, discrimVecNum) returns the results of LDA (linear discriminant analysis) on DS
%			DS: input dataset (Try "DS=prData('iris')" to get an example of DS.)
%			discrimVecNum: No. of discriminant vectors
%			DS2: output data set, with new feature vectors
%		[DS2, discrimVec, eigValues] = lda(DS, discrimVecNum) returns extra info:
%			discrimVec: discriminant vectors identified by LDA
%			eigValues: eigen values corresponding to the discriminant vectors
%
%	Example:
%		% === Scatter plots of the LDA projection
%		dsName='wine';
%		ds=prData(dsName);
%		ds.input=inputNormalize(ds.input);	% Input normalization
%		dsLda=lda(ds);
%		ds12=dsLda; ds12.input=ds12.input(1:2, :);
%		subplot(1,2,1); dsScatterPlot(ds12); xlabel('Input 1'); ylabel('Input 2');
%		title(sprintf('%s dataset projected on the first 2 LDA vectors', dsName)); 
%		ds34=dsLda; ds34.input=ds34.input(end-1:end, :);
%		subplot(1,2,2); dsScatterPlot(ds34); xlabel('Input 3'); ylabel('Input 4');
%		title(sprintf('%s dataset projected on the last 2 LDA vectors', dsName));
%		% === Leave-one-out accuracy of the projected dataset using KNNC
%		fprintf('LOO accuracy of KNNC over the original %s dataset = %g%%\n', dsName, 100*perfLoo(ds, 'knnc'));
%		fprintf('LOO accuracy of KNNC over the %s dataset projected onto the first two LDA vectors = %g%%\n', dsName, 100*perfLoo(ds12, 'knnc'));
%		fprintf('LOO accuracy of KNNC over the %s dataset projected onto the last two LDA vectors = %g%%\n', dsName, 100*perfLoo(ds34, 'knnc'));
%
%	Reference:
%		[1] J. Duchene and S. Leclercq, "An Optimal Transformation for Discriminant and Principal Component Analysis," IEEE Trans. on Pattern Analysis and Machine Intelligence, Vol. 10, No 6, November 1988
%
%	See also ldaPerfViaKnncLoo.

%	Category: Data dimension reduction
%	Roger Jang, 19990829, 20030607, 20100212, 20160724

if nargin<1, selfdemo; return; end
if ~isstruct(DS)
	fprintf('Please try "DS=prData(''iris'')" to get an example of DS.\n');
	error('The input DS should be a structure variable!');
end
if nargin<2, discrimVecNum=size(DS.input,1); end

% ====== Initialization
A = DS.input;
[m, n]=size(DS.input);	% m: dimensions, n: no. of data points
mu = mean(A, 2);
if size(DS.output, 1)==1	% Crisp output
	classLabel = DS.output;
	[diffClassLabel, classSize] = elementCount(classLabel);
	classNum = length(diffClassLabel);

	% ====== Compute B and W
	% ====== B: between-class scatter matrix
	% ====== W:  within-class scatter matrix
	% M = \sum_k m_k*mu_k*mu_k^T
	M = zeros(m, m);
	for i = 1:classNum,
		index = find(classLabel==diffClassLabel(i));
		classMean = mean(A(:, index), 2);
		M = M + length(index)*classMean*classMean';
	end
	W = A*A'-M;
	B = M-n*mu*mu';
else				% Fuzzy output
	% Put fuzzy lda code here
	U = DS.output;		% This is an mxn membership grades
	count = sum(U, 2);	% Cardinality of each class
	% Each row of MU is the mean of a class
	MU = U*A'./(count*ones(1, m));
	MMM = MU'*diag(count)*MU;
	W = A*A'-MMM;
	B = MMM-n*mu*mu';
end
[discrimVec, eigValues]=ldaOnWAndB(W, B, discrimVecNum);
DS2=DS;
DS2.input=discrimVec'*A; 

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
