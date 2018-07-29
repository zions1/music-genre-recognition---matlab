function [optimValue, dpPath, dpTable, time]=dpOverMapM(P, alpha, showPlot)
% dpOverMapM	: An m-file implementation of DP over matrix of state probability.
%
%	Usage:
%		optimValue=dpOverMapM(P, transProbMat)
%		optimValue=dpOverMapM(P, transProbMat, showPlot)
%		[optimValue, dpPath, dpTable, time]=dpOverMapM(...)
%
%	Description:
%		[optimValue, dpPath]=dpOverMap(P, transProbMat) returns the optimum value and the corresponding DP (dynamic programming) for HMM evaluation.
%			P: matrix of log state probabilities
%			transProbMat: matrix of log transition probabilities
%
%	Example:
%		m=320;
%		n=120;
%		P=rand(m, n);
%		[stateNum, frameNum]=size(P);
%		alpha=0;
%		showPlot=1;
%		[optimValue, dpPath, dpTable, time]=myPlateauPass(P, alpha, showPlot);
%		fprintf('Time=%.2f sec\n', time);
%
%	See also dpOverMap.

%	Category: HMM
%	Roger Jang, 20101028

if nargin<1, selfdemo; return; end
[frameNum, stateNum]=size(P);
if nargin<3, showPlot=0; end

dpTable=zeros(frameNum, stateNum);
prevPos=zeros(frameNum, stateNum);
dpPath=zeros(frameNum, 2);

tic
% ====== Fill dpTable
dpTable(1,:)=P(1,:);
for i=2:frameNum
	for j=1:stateNum
		prob=dpTable(i-1,:)+alpha*abs(j-[1:stateNum]);
		[maxProb, index]=max(prob);
		prevPos(i,j)=index;
		dpTable(i,j)=P(i,j)+maxProb;
	end
end

% ===== Backtrack to find the optimal path
dpPath(:,1)=1:frameNum;
[optimValue, index]=max(dpTable(end, :));	% Backtrack from the allowable final states
dpPath(end, 2)=index;		% This is the right state index
for j=frameNum-1:-1:1
	dpPath(j,2)=prevPos(j+1, dpPath(j+1,2));
end

time=toc;
dpPath=dpPath';

if showPlot
	subplot(2,2,1);
	frameTime=1:frameNum;
	imagesc(frameTime, 1:stateNum, P'); shading flat; axis xy; axis image; colorbar
	title('Map');
	for i=1:frameNum
		line(dpPath(1,i), dpPath(2,i), 'color', 'k', 'marker', '.');
	end
	subplot(2,2,3);
	mesh(frameTime, 1:stateNum, P'); axis tight; colorbar
	for i=1:frameNum
		line(dpPath(1,i), dpPath(2,i), P(dpPath(1,i), dpPath(2,i)), 'color', 'k', 'marker', '.');
	end
	title('Opt. path over the map');
	
	subplot(2,2,2);
	imagesc(frameTime, 1:stateNum, dpTable'); shading flat; axis xy; axis image; colorbar
	title('dpTable');
	for i=1:frameNum
		line(dpPath(1,i), dpPath(2,i), 'color', 'k', 'marker', '.');
	end
	subplot(2,2,4);
	mesh(frameTime, 1:stateNum, dpTable'); axis tight; colorbar
	for i=1:frameNum
		line(dpPath(1,i), dpPath(2,i), dpTable(dpPath(1,i), dpPath(2,i)), 'color', 'k', 'marker', '.');
	end
	title('Opt. path over the DP table');
	set(gcf, 'name', mfilename);
end

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
