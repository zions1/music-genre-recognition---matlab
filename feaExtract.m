function [fea, mfcc]=feaExtract(au, opt, showPlot)

if nargin<3, showPlot=0; end

if ischar(au)
    au=customAudioRead(au); 
end

%---------MFCC----------
mfccOpt=mfccOptSet(au.fs);
mfccOpt.frameSize=1024;
mfccOpt.overlap=512;
mfccOpt.useDelta=2;
mfcc=wave2mfcc(au.signal, au.fs, mfccOpt);

%--------Feature extraction--------
fea(:,1)=mean(mfcc, 2);     % Mean
fea(:,2)=var(mfcc, 1, 2);	% Standard deviation
fea(:,3)=min(mfcc, [], 2);	% Min
fea(:,4)=max(mfcc, [], 2);	% Max
fea=fea(:);

% Plot the feature extraction result
if showPlot
	time=(1:length(au.signal))/au.fs;
	subplot(211); plot(time, au.signal); xlabel('Time (sec)'); title('Audio signals');
	subplot(212); plot(fea); xlabel('Feature index'); title('File-based features');
end
