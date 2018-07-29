function [discrimVec, eigValues] = ldaOnWAndB(W, B, discrimVecNum)
% ldaOnWAndB Find the best discriminant vectors based on W & B
% LDA based on W and B. Each column of discrimVec is a gengenvector.
%	Note that the no. of columns of discrimVec may be samller than discrimVecNum if some of the eigenvalues are complex (It happens, why???)

% Here we asssume W and B are symmetric.
% However, in practice, they are not perfectly symmetric due truncation or round-off errors
% As a result, it is a good idea to make them perfectly symmetric, as follows.
W=(W+W')/2; B=(B+B')/2;

if det(W)==0, error('W is singular. One possible reason: a feature has the same value across all training data.'); end
m=size(W,1);
invW = inv(W);
M = invW*B;
D = [];
for i = 1:discrimVecNum
	[eigVec, eigVal] = eig(M);
	[eigValues(i), index] = max(abs(diag(eigVal)));
	if ~isreal(eigVec(:, index))	% Why this happens??? Is it due to the fact that W & B are not perfectly symmetric? We have tried to make them perfectly symmetric but sometimes it still happens.
		warning(sprintf('Some of the eigenvectors are not real in %s when dim=%d!', mfilename, i));
		break;
	end
	D = [D, eigVec(:, index)];		% Each col of D is a eigenvector
	M = (eye(m)-invW*D*inv(D'*invW*D)*D')*invW*B;
end
discrimVec = D;