% ����ƽ̨��Windows 7 64bit��MATLAB R2013a
% ¼��¼5����
recObj = audiorecorder(22100,16,1);
disp('Start speaking.')
recordblocking(recObj, 1);
disp('End of Recording.');
% �ط�¼������
play(recObj);
% ��ȡ¼������
myRecording = getaudiodata(recObj);
% ����¼�����ݲ���
plot(myRecording);