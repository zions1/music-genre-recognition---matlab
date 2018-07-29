ds=prData('abalone');
[dim, dataCount]=size(ds.input);
distMat=distPairwise(ds.output);
meanDist=mean(distMat(:));
stdDist=sqrt(var(distMat(:)));
tau=median(distMat(:));

B=zeros(dim);
W=zeros(dim);
for i=1:dataCount
	for j=1:dataCount
		if distMat(i,j)<=tau
			W=W+ds.input(:,i)*ds.input(:,j)';
		else
			B=B+ds.input(:,i)*ds.input(:,j)';
		end
	end
end

W=(W+W')/2;
B=(B+B')/2;

[discrimVec, eigValues] = ldaOnWAndB(W, B, dim);