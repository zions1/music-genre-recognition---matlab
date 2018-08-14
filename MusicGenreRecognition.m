clear;
addpath('machineLearning')  %Path to external library

format = 'flac';	%Format: 'wav', 'mp3' and 'flac'
%Path to music genres collections
auDir=['C:/Users/Donski/Desktop/thesis cranfield/music-genre-recognision-matlab/genres/genres_', format];
opt=mmDataCollect('defaultOpt');
opt.extName=format;
auSet=mmDataCollect(auDir, opt, 1);

fprintf('Platform: %s\n', computer);
fprintf('MATLAB version: %s\n', version);
fprintf('Script starts at %s\n', char(datetime));
dataSetFileName = ['ds_',format,'.mat'];

if exist(dataSetFileName, 'file')
    fprintf('Loading dataset.mat file\n');
	load(dataSetFileName)
else
	opt=dsCreateFromMm('defaultOpt');
	opt.auFeaFcn=@feaExtract;   %Feature extraction
	opt.auEpdFcn='';            %No-endpoint detection
	ds=dsCreateFromMm(auSet, opt, 1);
	fprintf('Saving dataset.mat file\n');
	save(dataSetFileName, 'ds')
end

input = ds.input';
desired = ds.output';
outputNames= ds.outputName;

trainSize = 0.75; %0.2:0.05:0.90
rng(10) %For reproducibility
%-------------- KNN ------------
fprintf('\nK-Nearest Neighbors algorithm starts');
tic;    % Start timer
[train, test, trainDesired, testDesired] = createTrainAndTestSets(input, desired, trainSize);
[knnAccuracy, confMat] = knn(train, trainDesired, test, testDesired, outputNames, 1);
knnTime = toc;  %Stop timer
%musicGenresBarChart(confMat, outputNames, 'KNN')
fprintf('\nAccuracy: %g; time: %g sec', knnAccuracy, knnTime);
fprintf('\nK-Nearest Neighbors algorithm finished');

rng(10) %For reproducibility
%--------- ECOC - SVM ---------
fprintf('\nError-correcting output coding algorithm starts');
tic;    % Start timer
[ecocAccuracy, confMat] = ecoc(input, desired, outputNames, trainSize, 1);
ecocTime = toc; %Stop timer
fprintf('\nAccuracy: %g time: %g sec', ecocAccuracy, ecocTime);
%musicGenresBarChart(confMat, outputNames, 'ECOC');
fprintf('\nError-correcting output coding algorithm finished');
%-------------------------------

%musicClassifierFigure(mp3EcocAccuracyMat, mp3KnnAccuracyMat, trainSizeMat)
return