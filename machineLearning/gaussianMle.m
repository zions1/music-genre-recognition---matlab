function gPrm = gaussianMle(data, type, showPlot)
% mleGaussian: MLE (maximum likelihood estimator) for Gaussian PDF
%
%	Usage:
%		gPrm = mleGaussian(data)
%		gPrm = gaussianMle(data, type)
%		gPrm = gaussianMle(data, type, showPlot)
%
%	Description:
%		gPrm = gaussianMle(data, type) returns the optimum parameters for Gaussian PDF via MLE
%			data: data matrix where each column corresponds to a vector of observation
%			type: type of covariance matrix
%				'full' for full covariance matrix
%				'diagonal' for diagonal covariance matrix
%				'single' for a covariance matrix of a constant times an identity matrix
%			gPrm: Parameters for Gaussian PDF
%				gPrm.mu: MLE of the mean
%				gPrm.sigma: MLE of the covariance matrix
%
%	Example:
%		% === 1D example
%		dataNum=1000;
%		x = randn(dataNum, 1);
%		showPlot=1;
%		gPrm=gaussianMle(x, [], showPlot);
%		% === 2D example
%		ds=dcData(7);
%		figure; gPrm=gaussianMle(ds.input, 'full', showPlot);
%		figure; gPrm=gaussianMle(ds.input, 'diagonal', showPlot);
%		figure; gPrm=gaussianMle(ds.input, 'single', showPlot);

%	Category: Gaussian PDF
%	Roger Jang, 20000428, 20080726, 20161107

if nargin<1, selfdemo; return; end
if nargin<2, type='full'; end
if nargin<3, showPlot=0; end

if isempty(type), type='full'; end
if size(data, 2)==1, data=data'; end
[dim, n] = size(data);
if n<=dim
	warning('Warning in %s: n (%d) <= dim (%d), the resulting parameters are not trustworthy!\n', mfilename, n, dim);
end

gPrm.mu = mean(data, 2);
switch(lower(type))
	case 'full'		% full covariance matrix
		%gPrm.sigma = (data*data'-n*gPrm.mu*gPrm.mu')/(n-1);
		gPrm.sigma = data*data'/n-gPrm.mu*gPrm.mu';
	case 'diagonal'		% diagonal covariance matrix
		alpha=zeros(dim,1);
		for i=1:dim
			alpha(i)=sum((data(i,:)-gPrm.mu(i)).^2)/n;
		end
	%	gPrm.sigma=diag(alpha);
		gPrm.sigma=alpha;
	case 'single'		% covariance matrix = a constant times an identity matrix
		total=0;
		for i=1:n
			total=total+data(:,i)'*data(:,i);
		end
		alpha=(total/n-gPrm.mu'*gPrm.mu)/dim;
	%	gPrm.sigma=diag(repmat(alpha, 1, dim));
		gPrm.sigma=alpha;
end

if showPlot
	switch dim
		case 1
			binNum = 20;
			[N, X] = hist(data, binNum);
			maxX=max(data);
			minX=min(data);
			rangeX=maxX-minX;
			k = n*rangeX/binNum;
			bar(X, N/k, 1);
			xi = linspace(minX-rangeX/2, maxX+rangeX/2);
			yi = gaussian(xi, gPrm);
			line('xdata', xi, 'ydata', yi, 'linewidth', 2, 'color', 'r');
			title('1D Gaussian PDF identified by MLE');
		case 2
			xMin=min(data(1,:));
			xMax=max(data(1,:));
			yMin=min(data(2,:));
			yMax=max(data(2,:));
			pointNum = 101;
			x = linspace(xMin, xMax, pointNum);
			y = linspace(yMin, yMax, pointNum);
			[xx, yy] = meshgrid(x, y);
			gridData = [xx(:), yy(:)]';
			out = gaussian(gridData, gPrm);
			zz = reshape(out, pointNum, pointNum);
			subplot(1,2,1);
			contour(xx, yy, zz, 15);
			line('xdata', data(1,:), 'ydata', data(2,:), 'linestyle', 'none', 'color', 'k', 'marker', '.');
			axis image; title('Scattered data and PDF contours');
			ax=subplot(1,2,2);
			mesh(xx, yy, zz);
			axis([-inf inf -inf inf -inf inf]);
			daspect(ax, [1, 1, max(zz(:))]);
			set(gca, 'box', 'on');
			title('2D Gaussian PDF identified by MLE');
	end	
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
