%% knncLoo
% Leave-one-out recognition rate of KNNC
%% Syntax
% * 		recogRate=knncLoo(DS)
% * 		recogRate=knncLoo(DS, opt)
% * 		recogRate=knncLoo(DS, opt, showPlot)
% * 		[recogRate, computed, nearestIndex]=knncLoo(...)
%% Description
%
% <html>
% <p>recogRate=knncLoo(DS) returns the recognition rate of the KNNC over the dataset DS based on the leave-one-out criterion.
% <p>recogRate=knncLoo(DS, opt) uses the parameters in opt for the computation. (In fact, only opt.k will be used for this function.)
% <p>recogRate=knncLoo(DS, opt, showPlot) plots the results if the dimension of the dataset is 2.
% <p>[recogRate, computed, nearestIndex]=knncLoo(...) also returns the computed class and the nearest index of each data instance.
% <p>opt=knncLoo('defaultOpt') returns the default options obtain from knncTrain('defaultOpt'). (In fact, only opt.k will be used for this function.)
% </html>
%% Example
%%
%
DS=prData('iris');
DS.input=DS.input(3:4, :);	% Use the last 2 dims for plotting
opt=knncLoo('defaultOpt');
showPlot=1;
tic
[recogRate, computed, nearestIndex] = knncLoo(DS, opt, showPlot);
fprintf('Elapsed time = %g sec\n', toc);
fprintf('Recog. rate = %.2f%% for %s dataSet\n', 100*recogRate, DS.dataName);
%% See Also
% <knncEval_help.html knncEval>,
% <knncTrain_help.html knncTrain>.
