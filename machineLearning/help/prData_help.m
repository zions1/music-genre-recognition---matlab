%% prData
% Various test datasets for pattern recognition
%% Syntax
% * 		DS=prData(dataName)
% * 		[DS, TS]=prData(dataName)
%% Description
%
% <html>
% <p>DS=prData(dataName) generate different dataset for classification.
% 	<ul>
% 	<li>dataName:
% 		<ul>
% 		<li>'iris': Iris dataset
% 		<li>'wine': Wine dataset
% 		<li>'abalone': Abalone dataset
% 		<li>'taiji': TaiJi dataset
% 		<li>'random2': 2D dataset of random numbers
% 		<li>'random3': 3D dataset of random numbers
% 		<li>'random6': 6D dataset of random numbers
% 		<li>'digit': MNIST dataset of hand-written isolated digits
% 		<li>'2spirals': Dataset of two spirals
% 		<li>'gender': Gender dataset
% 		</ul>
% 	</ul>
% </html>
%% Example
%%
%
subplot(2,3,1);
DS=prData('random2'); dsScatterPlot(DS);
subplot(2,3,2);
DS=prData('taiji'); dsScatterPlot(DS);
subplot(2,3,3);
DS=prData('linSeparable'); dsScatterPlot(DS);
subplot(2,3,4);
DS=prData('peaks'); dsScatterPlot(DS);
subplot(2,3,5);
DS=prData('3classes'); dsScatterPlot(DS);
subplot(2,3,6);
DS=prData('nonlinearSeparable'); dsScatterPlot(DS);
%% See Also
% <dcData_help.html dcData>.
