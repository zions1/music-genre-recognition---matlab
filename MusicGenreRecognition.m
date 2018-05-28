addpath('C:\Program Files\MATLAB\R2017a\toolbox\utility')
addpath('C:\Program Files\MATLAB\R2017a\toolbox\sap')
addpath('C:\Program Files\MATLAB\R2017a\toolbox\machineLearning')
%addpath('C:\Program Files\MATLAB\R2017a\toolbox\machineLearning/externalTool/libsvm-3.21/matlab')	% For using SVM classifier

extension = 'au';
auDir=['C:/Users/Donski/Desktop/thesis/genres/genres_', extension];
opt=mmDataCollect('defaultOpt');
opt.extName=extension;
auSet=mmDataCollect(auDir, opt, 1);

fprintf('Platform: %s\n', computer);
fprintf('MATLAB version: %s\n', version);
fprintf('Script starts at %s\n', char(datetime));
scriptStartTime=tic;	% Timing for the whole script
dataSetFileName = ['ds_',extension,'.mat'];

if ~exist(dataSetFileName, 'file')
	myTic=tic;
	opt=dsCreateFromMm('defaultOpt');
	opt.auFeaFcn=@mgcFeaExtract;	% Function for feature extraction
	opt.auEpdFcn='';		% No need to do endpoint detection
	ds=dsCreateFromMm(auSet, opt, 1);
	fprintf('Time for feature extraction over %d files = %g sec\n', length(auSet), toc(myTic));
	fprintf('Saving ds.mat...\n');
	save(dataSetFileName, ds)
else
	fprintf('Loading ds.mat...\n');
	load(dataSetFileName)
end

input = ds.input';
desired = ds.output';
outputNames= ds.outputName;
trainSize = 0.8;
rng(1)      %For reproducibility

%---------- KNN ---------
fprintf('\nK-Nearest Neighbors algorithm starts at %s\n', char(datetime));
[train, test, trainDesired, testDesired] = createTrainAndTestSets(input, desired, trainSize);
knn(train, trainDesired, test, testDesired, outputNames, 1);
fprintf('K-Nearest Neighbors algorithm finished at %s\n', char(datetime));
%------------------------


%Test MFCC
auFile=[auDir, '/metal/metal.00002.', extension];
%figure;
mgcFeaExtract(auFile, [], 0);

%figure; dsFeaVecPlot(ds); figEnlarge;
return