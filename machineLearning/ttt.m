		dsName='iris';
 		ds=prData(dsName);
	%	ds.input=inputNormalize(ds.input);
		dsLda=ds;
		dsLda.output=dsFuzzify(ds);
 		dsLda=lda(dsLda);
 		ds12=dsLda; ds12.input=ds12.input(1:2, :); ds12.output=ds.output; ds12.inputName={'in1', 'in2'};
 		subplot(1,2,1); dsScatterPlot(ds12); xlabel('Input 1'); ylabel('Input 2');
 		title(sprintf('%s dataset projected on the first 2 lda vectors', dsName)); 
 		ds34=dsLda; ds34.input=ds34.input(end-1:end, :); ds34.output=ds.output; ds34.inputName={'in3', 'in4'};
 		subplot(1,2,2); dsScatterPlot(ds34); xlabel('Input 3'); ylabel('Input 4');
 		title(sprintf('%s dataset projected on the last 2 lda vectors', dsName));
 		% === Leave-one-out accuracy of the projected dataset using KNNC
 		fprintf('LOO accuracy of KNNC over the original %s dataset = %g%%\n', dsName, 100*perfLoo(ds, 'knnc'));
 		fprintf('LOO accuracy of KNNC over the %s dataset projected onto the first two lda vectors = %g%%\n', dsName, 100*perfLoo(ds12, 'knnc'));
 		fprintf('LOO accuracy of KNNC over the %s dataset projected onto the last two lda vectors = %g%%\n', dsName, 100*perfLoo(ds34, 'knnc'));
