function ds=dsCreateFromMm(mmSet, opt, showPlot)
% dsCreateFromMm: Create DS from multimedia dataset
%
%	Usage:
%		ds=dsCreateFromMm(mmSet, opt);
%
%	Example:
%		% === Create mmSet
%		mmDir=[mltRoot, '/dataSet/att_faces(partial)'];
%		opt=mmSetCollect('defaultOpt');
%		opt.extName='pgm';
%		mmSet=mmSetCollect(mmDir, opt);
%		% === Invoke dsCreateFromMm
%		opt2=dsCreateFromMm('defaultOpt');
%		ds=dsCreateFromMm(mmSet, opt2);

%	Category: Multimedia data processing
%	Roger Jang, 20141204

if nargin<1, selfdemo; return; end
if ischar(mmSet) && strcmpi(mmSet, 'defaultOpt')
	% === Set the default options for images
	ds.imReadFcn=@imread;
	ds.imFeaFcn=@imFeaLgbp;		% Feature function
	ds.imFeaOpt=feval(ds.imFeaFcn, 'defaultOpt');	% Feature options
	% === Set the default options for audios
	ds.auReadFcn=@myAudioRead;
	ds.auFeaFcn=@auFeaMfcc;
	ds.auFeaOpt=feval(ds.auFeaFcn, 'defaultOpt');	% Feature options
	ds.auEpdFcn=@endPointDetect;
	ds.auEpdOpt=feval(ds.auEpdFcn, 'defaultOpt');
	ds.auEpdSelectionMethod='begin2end';		% 'begin2end' (from beginning segment to the ending segment) or 'maxDuration' (to select the segment with the maximum duration)
	ds.auShowEpdPlot=1;
	% === Common options
	ds.cumVarTh=90;		% Threshold of cumulative variance percentage in PCA
	ds.displayCount=10;
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

mmNum=length(mmSet);
% Extract features
fprintf('Extracting features from each multimedia object...\n');
[parentDir, mainName, extName]=fileparts(mmSet(1).path);

displayInterval=floor(mmNum/opt.displayCount);
switch(lower(extName))
	case {'.jpg', '.png', '.pgm', '.bmp'}
		for i=1:mmNum
			myTic=tic;
			if mod(i, displayInterval)==0, fprintf('%d/%d: file=%s, ', i, mmNum, mmSet(i).path); end
			mm=feval(opt.imReadFcn, mmSet(i).path);
			mmSet(i).fea=feval(opt.imFeaFcn, mm, opt.imFeaOpt);
			[dim, frameNum]=size(mmSet(i).fea);
			if mod(i, displayInterval)==0, fprintf('time=%g sec\n', toc(myTic)); end
		end
		ds.output=[mmSet.classId];
	case {'.wav', '.mp3', '.au', '.m4a', '.flac', '.ogg'}
		for i=1:mmNum
			myTic=tic;
			if mod(i, floor(mmNum/opt.displayCount))==0, fprintf('%d/%d: file=%s, ', i, mmNum, mmSet(i).path); end
			mm=feval(opt.auReadFcn, mmSet(i).path);
			mm.signal=mean(mm.signal, 2);		% Stereo to mono
			if isfield(opt, 'auEpdFcn') & ~isempty(opt.auEpdFcn)	% Perform endpoint detection if necessary
				if opt.auShowEpdPlot, figure; end
				[epInSample, junk, segment]=feval(opt.auEpdFcn, mm, opt.auEpdOpt, opt.auShowEpdPlot);
			%	fprintf('Press any key to continue...'); pause; fprintf('\n');
				switch(opt.auEpdSelectionMethod)
					case 'begin2end'
						mm.signal=mm.signal(epInSample(1):epInSample(2));
					case 'maxDuration'
						[maxDuration, maxIndex]=max([segment.duration]);
						mm.signal=mm.signal(segment(maxIndex).beginSample:segment(maxIndex).endSample);
					otherwise
						error(sprintf('Unknown epdSelectionMethod: %s', opt.epdSelectionMethod));
				end
			end
			mmSet(i).fea=feval(opt.auFeaFcn, mm, opt.auFeaOpt);
			[dim, frameNum]=size(mmSet(i).fea);
			mmSet(i).classIdVec=mmSet(i).classId*ones(1, frameNum);
			mmSet(i).fileId=i*ones(1, frameNum);		% File ID, for aggregate prediction
			if isfield(mmSet, 'person')
				mmSet(i).personIdVec=mmSet(i).personId*ones(1, frameNum);		% File ID, for aggregate prediction
			end
			if mod(i, displayInterval)==0, fprintf('time=%g sec\n', toc(myTic)); end
		end
		ds.output=[mmSet.classIdVec];
		ds.fileId=[mmSet.fileId];
		ds.fileClassId=[mmSet.classId];
		if isfield(mmSet, 'person')
			ds.personId=[mmSet.personIdVec];
			ds.person=unique({mmSet.person});
		end
	otherwise
		error(sprintf('Unknown extName: %s', extName));
end

% Common part
ds.input=[mmSet.fea];
%ds.inputName=feval(opt.imFeaFcn, 'inputName');
ds.outputName=unique({mmSet.class});
ds.file={mmSet.path};


% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
