function membership = dsFuzzify(ds, opt, showPlot)
%dsFuzzy: Initialize fuzzy membership grades from a crisp dataset.
%
%	Usage:
%		membership = dsFuzzify(ds)
%		membership = dsFuzzify(ds, opt)
%		membership = dsFuzzify(ds, opt, showPlot)
%
%	Description:
%		membership = dsFuzzy(ds, opt) returns the membership grades from a crisp dataset
%			ds: dataset with crisp class information
%			opt: options
%				opt.k: no. of nearest neighbors for estimating membership grades (default to 3)
%				opt.leadingTerm: Leading term of the formula to compute membership grades (default to 0.51)
%			membership: membership grades of each sample point
%
%	Example:
%		ds=prData('3classes');
%		opt=dsFuzzify('defaultOpt');
%		membership=dsFuzzify(ds, opt, 1);
%
%	Reference:
%		J. M. Keller, M. R. Gray, and J. A. Givens, Jr., "A Fuzzy K-Nearest Neighbor Algorithm", IEEE Transactions on Systems, Man, and Cybernetics, Vol. 15, No. 4, pp. 580-585.
%
%	See also FKNN.

%	Category: Fuzzy KNN
%	Roger Jang, 19990805, 20160724

if nargin<1, selfdemo; return; end
if ischar(ds) && strcmpi(ds, 'defaultOpt')	% Set the default options
	membership.k=3;
	membership.leadingTerm=0.51;
	return
end
if nargin<2||isempty(opt), opt=feval(mfilename, 'defaultOpt'); end
if nargin<3, showPlot=0; end

k=opt.k;
[feaDim, dataCount]=size(ds.input);
classCount=max(ds.output);
distMat=distPairwise(ds.input);
distMat(1:(dataCount+1):dataCount^2)=inf;		% Set diagonal elements to inf

% knnmat(i,j) = class of i-th nearest point of j-th input vector
% (The size of knnmat is k times dataCount.)
[junk, index]=sort(distMat);
knnmat=reshape(ds.output(index(1:k,:)), k, dataCount);

% Compute the membership grades for each sample point
membership=zeros(classCount, dataCount);
for j=1:dataCount
	desiredClass = ds.output(j);
	for i=1:classCount
		n=length(find(knnmat(:,j)==i));
		if i==desiredClass,
			membership(i,j) = n/k*(1-opt.leadingTerm)+opt.leadingTerm;	% n/k*0.49+0.51
		else
			membership(i,j) = n/k*(1-opt.leadingTerm);			% n/k*0.49
		end
	end
end

if showPlot
	if feaDim==2
		dsScatterPlot(ds);
		index = find(sum(membership.^0.5, 1)~=1); 
		line(ds.input(1,index), ds.input(2,index), 'linestyle', 'none', 'marker', 'o', 'color', 'k');
		title('Circled data points have fuzzy membership grades.');
	end
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);