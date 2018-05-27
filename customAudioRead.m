function au=customAudioRead(audioFile)

[au.signal, au.fs]=audioread(audioFile);
info=audioinfo(audioFile);
if isfield(info, 'BitsPerSample')
	au.nbits=info.BitsPerSample;
else
	au.nbits=16;        %default 16 bits per sample
end

au.amplitudeNormalized=1;		% The amplitude is normalized to [-1, 1] already
au.file=audioFile;