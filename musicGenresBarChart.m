function musicGenresBarChart(confMat, genreNames, classifier)
color = [18/255 46/255 255/255];
y = confMat(sub2ind(size(confMat),1:size(confMat,1),1:size(confMat,2)));
x = categorical(genreNames);
figure
b = bar(x, y);
set(b,'FaceColor', color(1,:));
legend(classifier),
ylabel('Number of correct predictions');
end