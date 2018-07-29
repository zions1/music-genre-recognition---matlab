%% dsCreateFromMm
% Create DS from multimedia dataset
%% Syntax
% * 		ds=dsCreateFromMm(mmSet, opt);
%% Description
%
% <html>
% </html>
%% Example
%%
% Create mmSet
mmDir=[mltRoot, '/dataSet/att_faces(partial)'];
opt=mmSetCollect('defaultOpt');
opt.extName='pgm';
mmSet=mmSetCollect(mmDir, opt);
%%
% Invoke dsCreateFromMm
opt2=dsCreateFromMm('defaultOpt');
ds=dsCreateFromMm(mmSet, opt2);
