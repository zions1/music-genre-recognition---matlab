function [ds2, fileRr, frameRr]=perfLoo4audio(ds, opt, showPlot)
%strCentroid: Leave-one-file-out CV (for audio)
%
%	Usage:
%		ds2=perfLoo4audio(ds, opt, showPlot)
%
%	Description:
%		perfLoo4audio(ds, opt, showPlot) performs leave-one-file-out or leave-one-person-out cross validation for audio files. For usage example, please refer to "http://mirlab.org/jang/books/audioSignalProcessing/appNote/coinType/html/goTutorial.html?title=21-4%20Coin%20Type%20Recognition".
%
%	See also perfCv, perfCv4classifier, perfLoo.

%	Category: Performance evaluation
%	Roger Jang, 20150120

if nargin<1, selfdemo; return; end
if ischar(ds) && strcmpi(ds, 'defaultOpt')	% Set the default options
	ds2.classifier='gmmc';
	ds2.classifierOpt=classifierTrain(ds2.classifier, 'defaultOpt');
	ds2.fileRrMethod='logLike';	% 'logLike' or 'vote'
	ds2.mode='LOFO';	% LOFO: leave-one-file-out, LOPO: leave-one-person-out
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

ds2=ds;
switch(lower(opt.mode))
	case 'lofo'		% Evaluation based on leave-one-file-out (LOFO)
		looUnit=ds.file;
		looId=ds.fileId;
	case 'lopo'		% Evaluation based on leave-one-person-out (LOPO)
		looUnit=ds.person;
		looId=ds.personId;
end	
for i=1:length(looUnit)
	fprintf('%d/%d: %s for "%s", time=', i, length(looUnit), opt.mode, looUnit{i});
	theTic=tic;
	% === Create dataset for training and test
	tFrameIndex=find(looId==i);		% Indices for frames to be tested
	trainDs=ds;
	trainDs.input(:, tFrameIndex)=[];
	trainDs.output(:, tFrameIndex)=[];
	testDs=ds;
	testDs.input=testDs.input(:, tFrameIndex);
	testDs.output=testDs.output(:, tFrameIndex);
	% === Train the given classifier
	cPrm=classifierTrain(opt.classifier, trainDs, opt.classifierOpt);
	[pClass, logLike]=classifierEval(opt.classifier, testDs, cPrm);
	ds2.frameClassIdPredicted(tFrameIndex)=pClass;	% Predicted class for each frame
	ds2.logLike(:, tFrameIndex)=logLike;
	fprintf('%g sec\n', toc(theTic));
end
%%
% The frame-based accuracy for LOFOCV can be computed next:
frameRr=sum(ds2.frameClassIdPredicted==ds.output)/length(ds.output);

% The file-based accuracy for LOFOCV can be computed as follows:
switch(opt.fileRrMethod)
	case 'vote'
		for i=1:length(ds.file)
			index=find(ds.fileId==i);
			ds2.fileClassIdPredicted(i)=mode(ds2.frameClassIdPredicted(index));
		end
		fileRr=sum(ds2.fileClassIdPredicted==ds2.fileClassId)/length(ds2.fileClassId);
	%	fprintf('File-based LOFOCV (based on frame classification) = %g%%\n', accuracy*100);
	case 'logLike'
		for i=1:length(ds.file)
			index=find(ds.fileId==i);
			logLike=sum(ds2.logLike(:, index), 2);
			[maxValue, ds2.fileClassIdPredicted(i)]=max(logLike);
		end
		fileRr=sum(ds2.fileClassIdPredicted==ds2.fileClassId)/length(ds2.fileClassId);
	%	fprintf('File-based LOFOCV (based on frame likelihood) = %g%%\n', accuracy*100);
	otherwise
		error(sprintf('Unknown opt.fileRrMethod=%s\n', opt.fileRrMethod));
end

if showPlot
	confMat=confMatGet(ds.fileClassId, ds.fileClassIdPredicted);
%	confMat=confMatGet(ds.output, ds.frameClassIdPredicted);
	confOpt=confMatPlot('defaultOpt');
	confOpt.className=ds.outputName;
	confMatPlot(confMat, confOpt);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);