function musicClassifierFigure(ecocAccurancy, knnAccurancy, training)
color = [[191/255 6/255 3/255]; [18/255 46/255 255/255]];
figure
h = plot(training, ecocAccurancy, '-.d', training, knnAccurancy, '-.o');
for i=1:1:length(h)
    set(h(i), 'color', color(i,:));
end
legend('ECOC', 'KNN'),
ylabel('Accuracy [%]'), xlabel('Number of training data'), grid on;

end