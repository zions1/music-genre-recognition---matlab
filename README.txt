Music Genre Recognition

Project title: 
Music genre recognition using the machine learning technology.

A brief description of the project:
The project aim is to create and develop an application for recognition of music genres. The application is expected to recognize the music genre for input sounds.

Dataset:
The dataset used for this application is GTZAN dataset (http://marsyasweb.appspot.com/download/data_sets/).
The dataset consists of 1000 audio tracks each 30 seconds long. It contains 10 genres, each represented by 100 tracks. The tracks are all 22,050 Hz Mono 16-bit audio files.
The data are subjected to feature extraction and saved into ds_wav, ds_flac, ds_mp3 files. Thus, for the future experiments, the data are loaded from these files. The extraction is not required.

Formats:
Tha application allows to read data in different format type:
-> uncompressed format - .wav - /genres/genres_wav
-> lossless compression format - .flac - /genres/genres_mp3
-> lossy compression format - .mp3 - /genres/genres_flac

HOW TO RUNs?
1. Open the MusicGenreRecognition Matlab script. 
2. Change the path to genres samples.
3. Run the MusicGenreRecognition script.





