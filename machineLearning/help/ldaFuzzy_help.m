%% ldaFuzzy
% fuzzy LDA (linear discriminant analysis)
%% Syntax
% * 		[newSampleIn, discrimVec] = ldaFuzzy(sampleIn, sampleOut, discrimVecNum)
%% Description
%
% <html>
% <p>[NEWSAMPLE, DISCRIM_VEC] = ldaFuzzy(SAMPLE, discrimVecNum) returns the new dataset after fuzzy LDA.
% 	<ul>
% 	<li>SAMPLE: Sample data with class information, where each row of SAMPLE is a sample point, with the last column being the class label ranging from 1 to no. of classes
% 	<li>discrimVecNum: No. of discriminant vectors
% 	<li>NEWSAMPLE: new sample after projection
% 	</ul>
% </html>
