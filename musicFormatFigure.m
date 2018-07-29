function musicFormatFigure(wavFlacAccurancy, mp3Accurancy, training)
color = [[191/255 6/255 3/255]; [18/255 46/255 255/255]];
figure
h = plot(training, wavFlacAccurancy, '-.d', training, mp3Accurancy, '-.o');
for i=1:1:length(h)
    set(h(i), 'color', color(i,:));
end
legend('WAV/FLAC', 'MP3'),
ylabel('Accuracy [%]'), xlabel('Number of training data'), grid on;
end