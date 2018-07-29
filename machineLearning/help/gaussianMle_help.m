%% gaussianMle
% MLE (maximum likelihood estimator) for Gaussian PDF
%% Syntax
% * 		gPrm = mleGaussian(data)
% * 		gPrm = gaussianMle(data, type)
% * 		gPrm = gaussianMle(data, type, showPlot)
%% Description
%
% <html>
% <p>gPrm = gaussianMle(data, type) returns the optimum parameters for Gaussian PDF via MLE
% 	<ul>
% 	<li>data: data matrix where each column corresponds to a vector of observation
% 	<li>type: type of covariance matrix
% 		<ul>
% 		<li>'full' for full covariance matrix
% 		<li>'diagonal' for diagonal covariance matrix
% 		<li>'single' for a covariance matrix of a constant times an identity matrix
% 		</ul>
% 	<li>gPrm: Parameters for Gaussian PDF
% 		<ul>
% 		<li>gPrm.mu: MLE of the mean
% 		<li>gPrm.sigma: MLE of the covariance matrix
% 		</ul>
% 	</ul>
% </html>
%% Example
%%
% 1D example
dataNum=1000;
x = randn(dataNum, 1);
showPlot=1;
gPrm=gaussianMle(x, [], showPlot);
%%
% 2D example
ds=dcData(7);
figure; gPrm=gaussianMle(ds.input, 'full', showPlot);
figure; gPrm=gaussianMle(ds.input, 'diagonal', showPlot);
figure; gPrm=gaussianMle(ds.input, 'single', showPlot);
