%% myPlateauPass
% An m-file implementation of DP over matrix of state probability.
%% Syntax
% * 		optimValue=dpOverMapM(P, transProbMat)
% * 		optimValue=dpOverMapM(P, transProbMat, showPlot)
% * 		[optimValue, dpPath, dpTable, time]=dpOverMapM(...)
%% Description
%
% <html>
% <p>[optimValue, dpPath]=dpOverMap(P, transProbMat) returns the optimum value and the corresponding DP (dynamic programming) for HMM evaluation.
% 	<ul>
% 	<li>P: matrix of log state probabilities
% 	<li>transProbMat: matrix of log transition probabilities
% 	</ul>
% </html>
%% Example
%%
%
m=320;
n=120;
P=rand(m, n);
[stateNum, frameNum]=size(P);
alpha=0;
showPlot=1;
[optimValue, dpPath, dpTable, time]=myPlateauPass(P, alpha, showPlot);
fprintf('Time=%.2f sec\n', time);
%% See Also
% <dpOverMap_help.html dpOverMap>.
