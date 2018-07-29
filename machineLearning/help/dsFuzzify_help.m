%% dsFuzzify
% Initialize fuzzy membership grades from a crisp dataset.
%% Syntax
% * 		membership = dsFuzzify(ds)
% * 		membership = dsFuzzify(ds, opt)
% * 		membership = dsFuzzify(ds, opt, showPlot)
%% Description
%
% <html>
% <p>membership = dsFuzzy(ds, opt) returns the membership grades from a crisp dataset
% 	<ul>
% 	<li>ds: dataset with crisp class information
% 	<li>opt: options
% 		<ul>
% 		<li>opt.k: no. of nearest neighbors for estimating membership grades (default to 3)
% 		<li>opt.leadingTerm: Leading term of the formula to compute membership grades (default to 0.51)
% 		</ul>
% 	<li>membership: membership grades of each sample point
% 	</ul>
% </html>
%% References
% # 		J. M. Keller, M. R. Gray, and J. A. Givens, Jr., "A Fuzzy K-Nearest Neighbor Algorithm", IEEE Transactions on Systems, Man, and Cybernetics, Vol. 15, No. 4, pp. 580-585.
%% Example
%%
%
ds=prData('3classes');
opt=dsFuzzify('defaultOpt');
membership=dsFuzzify(ds, opt, 1);
%% See Also
% <FKNN_help.html FKNN>.
