function color=getColorLight(index)
% getColor: Get color from a rotating palette
%	Usage: color=getColorLight(index)
%
%	For example:
%		for i=1:6
%			line(1:10, rand(1, 10), 'color', getColorLight(i), 'lineWidth', 3);
%		end
%		legend('Color 1', 'Color 2', 'Color 3', 'Color 4', 'Color 5', 'Color 6');

% Roger Jang, 20040910, 20071009

if nargin<1, index=1; end

%allColor={'b', 'r', 'g', 'm', 'c', 'y'};
allColor=[0.95 0 0; 0 0.95 0; 0 0 0.95; 0 0.95 0.95; 0.95 0.95 0; 0.95 0 0.95; 0 1 0.8; 0.85 0 0; 0 0.75 0; 0 0 0.75;];
ind=find(allColor==0);
allColor(ind)=0.75;
%color=allColor{mod(index-1, length(allColor))+1};
color=allColor(mod(index-1, length(allColor))+1, :);
