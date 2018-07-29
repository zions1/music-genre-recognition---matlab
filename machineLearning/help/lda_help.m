%% lda
% Linear discriminant analysis
%% Syntax
% * 		DS2 = lda(DS)
% * 		DS2 = lda(DS, discrimVecNum)
% * 		[DS2, discrimVec, eigValues] = lda(...)
%% Description
%
% <html>
% <p>DS2 = lda(DS, discrimVecNum) returns the results of LDA (linear discriminant analysis) on DS
% 	<ul>
% 	<li>DS: input dataset (Try "DS=prData('iris')" to get an example of DS.)
% 	<li>discrimVecNum: No. of discriminant vectors
% 	<li>DS2: output data set, with new feature vectors
% 	</ul>
% <p>[DS2, discrimVec, eigValues] = lda(DS, discrimVecNum) returns extra info:
% 	<ul>
% 	<li>discrimVec: discriminant vectors identified by LDA
% 	<li>eigValues: eigen values corresponding to the discriminant vectors
% 	</ul>
% </html>
%% References
% # 		[1] J. Duchene and S. Leclercq, "An Optimal Transformation for Discriminant and Principal Component Analysis," IEEE Trans. on Pattern Analysis and Machine Intelligence, Vol. 10, No 6, November 1988
%% Example
%%
% Scatter plots of the LDA projection
dsName='wine';
ds=prData(dsName);
ds.input=inputNormalize(ds.input);	% Input normalization
dsLda=lda(ds);
ds12=dsLda; ds12.input=ds12.input(1:2, :);
subplot(1,2,1); dsScatterPlot(ds12); xlabel('Input 1'); ylabel('Input 2');
title(sprintf('%s dataset projected on the first 2 LDA vectors', dsName));
ds34=dsLda; ds34.input=ds34.input(end-1:end, :);
subplot(1,2,2); dsScatterPlot(ds34); xlabel('Input 3'); ylabel('Input 4');
title(sprintf('%s dataset projected on the last 2 LDA vectors', dsName));
%%
% Leave-one-out accuracy of the projected dataset using KNNC
fprintf('LOO accuracy of KNNC over the original %s dataset = %g%%\n', dsName, 100*perfLoo(ds, 'knnc'));
fprintf('LOO accuracy of KNNC over the %s dataset projected onto the first two LDA vectors = %g%%\n', dsName, 100*perfLoo(ds12, 'knnc'));
fprintf('LOO accuracy of KNNC over the %s dataset projected onto the last two LDA vectors = %g%%\n', dsName, 100*perfLoo(ds34, 'knnc'));
%% See Also
% <ldaPerfViaKnncLoo_help.html ldaPerfViaKnncLoo>.
