%% ldaPerfViaKnncLoo
% LDA recognition rate via KNNC and LOO performance index
%% Syntax
% * 		recogRate=ldaPerfViaKnncLoo(DS)
% * 		recogRate=ldaPerfViaKnncLoo(DS, opt)
% * 		recogRate=ldaPerfViaKnncLoo(DS, opt, plotOpt)
% * 		[recogRate, bestFeaNum, computedClass]=ldaPerfViaKnncLoo(...);
%% Description
%
% <html>
% <p>recogRate=ldaPerfViaKnncLoo(DS) return the leave-one-out recognition rate of KNNC on the dataset DS after dimension reduction using LDA (linear discriminant analysis)
% 	<ul>
% 	<li>DS: the dataset
% 	</ul>
% <p>recogRate=ldaPerfViaKnncLoo(DS, opt) uses LDA with the option opt:
% 	<ul>
% 	<li>opt.maxDim: Use this value as the max. dimensions after LDA projection
% 	<li>opt.mode:
% 		<ul>
% 		<li>'approximate' (default) for approximate evaluation which uses all dataset for LDA project
% 		<li>'exact' for true leave-one-out test, which takes longer
% 		</ul>
% 	</ul>
% <p>The default value of option can be obtained by ldaPerfViaKnncLoo('defaultOpt').
% <p>recogRate=ldaPerfViaKnncLoo(DS, opt, 1) plots the recognition rates w.r.t. dimensions after LDA transformation.
% </html>
%% Example
%%
% Using LDA over WINE dataset
opt=ldaPerfViaKnncLoo('defaultOpt');
opt.mode='approximate';
DS=prData('wine');
recogRate1=ldaPerfViaKnncLoo(DS, opt, 1);
%%
% Compare two mode of LDA performance evaluation via KNNC-LOO
opt=ldaPerfViaKnncLoo('defaultOpt');
opt.mode='approximate';
DS=prData('wine');
tic; recogRate1=ldaPerfViaKnncLoo(DS, opt); time1=toc;
opt.mode='exact';
tic; recogRate2=ldaPerfViaKnncLoo(DS, opt); time2=toc;
figure;
plot(1:length(recogRate1), 100*recogRate1, '.-', 1:length(recogRate2), 100*recogRate2, '.-'); grid on
xlabel('No. of projected features based on LDA');
ylabel('LOO recognition rates using KNNC (%)');
title('Without input normalization');
legend('mode=''approximate''', 'mode=''exact''', 'location', 'southwest');
fprintf('time for approximate mode=%g sec, time for exact mode=%g sec\n', time1, time2);
%%
% Effect of input normalization of LDA over WINE dataset (with both modes)
opt=ldaPerfViaKnncLoo('defaultOpt');
DS=prData('wine');
DS2=DS; DS2.input=inputNormalize(DS2.input);
opt.mode='approximate';
rr11=ldaPerfViaKnncLoo(DS, opt);
rr12=ldaPerfViaKnncLoo(DS2, opt);
opt.mode='exact';
rr21=ldaPerfViaKnncLoo(DS, opt);
rr22=ldaPerfViaKnncLoo(DS2, opt);
figure;
xVec=1:length(recogRate1);
plot(xVec, 100*rr11, '.-b', xVec, 100*rr12, '.-m'); grid on
hold on; plot(xVec, 100*rr21, '^-b', xVec, 100*rr22, '^-m'); hold off
xlabel('No. of projected features based on LDA');
ylabel('LOO recognition rates using KNNC (%)');
title('With both modes');
legend('approximate mode, w/o input normalization', 'approximate mode, w/ input normalization', 'exact mode, w/o input normalization', 'exact mode, w/ input normalization', 'location', 'southwest');
%% See Also
% <lda_help.html lda>.
