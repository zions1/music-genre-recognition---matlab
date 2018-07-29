function color=getColor(index, useVec)
% getColor: Get a color from a palette
%
%	Usage:
%		color=getColor(index)
%
%	Description:
%		color=getColor(index) return a color (in a string) from a palette based on the given index.
%		color=getColor(index) return a color in the format a RGB vector.
%
%	Example:
%		for i=1:6
%			line(1:10, rand(1, 10), 'color', getColor(i), 'lineWidth', 3);
%		end
%		legend('Color 1', 'Color 2', 'Color 3', 'Color 4', 'Color 5', 'Color 6');

%	Category: Utility
%	Roger Jang, 20040910, 20071009

if nargin<1, selfdemo; return; end
if nargin<2, useVec=0; end
allColor=[0.95 0 0; 0 0.95 0; 0 0 0.95; 0 0.95 0.95; 0.95 0.95 0; 0.95 0 0.95; 0 1 0.8; 0.85 0 0; 0 0.75 0; 0 0 0.75;];
color=allColor(mod(index-1, length(allColor))+1, :);

% ====== Self demo
function selfdemo
mObj=mFileParse(which(mfilename));
strEval(mObj.example);
