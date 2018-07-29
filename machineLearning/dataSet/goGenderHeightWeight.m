
clear all; close all;

file='gender-height-weight.csv';
fprintf('Reading %s...\n', file);
[table, origFieldName]=xlsFile2struct(file, 'gender-height-weight', {'gender', '', '', 'height', 'weight'});
table=table(1:5:end);		% down sampling
ds.name='genderHeightWeight';
ds.inputName={'height', 'weight'};
ds.outputName={'female', 'male'};
ds.input=[[table.height]; [table.weight]];
ds.output=2-strcmp({table.gender}, 'Female');
dsScatterPlot(ds);
