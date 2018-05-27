addpath('C:\Program Files\MATLAB\R2017a\toolbox\utility')
addpath('C:\Program Files\MATLAB\R2017a\toolbox\sap')
addpath('C:\Program Files\MATLAB\R2017a\toolbox\machineLearning')
addpath('C:\Program Files\MATLAB\R2017a\toolbox\machineLearning/externalTool/libsvm-3.21/matlab')	% For using SVM classifier

auDir='C:/Users/Donski/Desktop/thesis/genres/genres_au';
opt=mmDataCollect('defaultOpt');
opt.extName='au';
auSet=mmDataCollect(auDir, opt, 1); 

fprintf('Platform: %s\n', computer);
fprintf('MATLAB version: %s\n', version);
fprintf('Script starts at %s\n', char(datetime));
scriptStartTime=tic;	% Timing for the whole script

if ~exist('ds.mat', 'file')
	myTic=tic;
	opt=dsCreateFromMm('defaultOpt');
	opt.auFeaFcn=@mgcFeaExtract;	% Function for feature extraction
	opt.auEpdFcn='';		% No need to do endpoint detection
	ds=dsCreateFromMm(auSet, opt, 1);
	fprintf('Time for feature extraction over %d files = %g sec\n', length(auSet), toc(myTic));
	fprintf('Saving ds.mat...\n');
	save ds ds
else
	fprintf('Loading ds.mat...\n');
	load au_ds.mat
end

%Test MFCC
auFile=[auDir, '/metal/metal.00002.au'];
figure;
mgcFeaExtract(auFile, [], 1);

return