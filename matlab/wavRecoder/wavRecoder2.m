fs=44100;           %ȡ��Ƶ��
duration=2;         %¼��ʱ��
fprintf('Press any key to start %g seconds of recording...\n',duration);
pause;
fprintf('Recording...\n');
y=wavrecord(duration*fs,fs);         %duration*fs ���ܵĲ�������
fprintf('Finished recording.\n');
fprintf('Press any key to play the recording...\n');
pause;
wavplay(y,fs);
plot(y(1000:1500));