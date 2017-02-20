% ���� 11-5 AudioAcquisitionInFixedDuration.m
duration = 0.5;  % ���ݲɼ�ʱ�䳤��
ai = analoginput('winsound');
addchannel(ai, 1);
sampleRate = get(ai, 'SampleRate');
requiredSamples = floor(sampleRate * duration); % ���ݲɼ�����
set(ai, 'SamplesPerTrigger', requiredSamples);
waitTime = duration * 1.1 + 0.5;
start(ai)                     % ����
tic
wait(ai, waitTime);
toc
[data, time] = getdata(ai); % ��ȡ����
figure;                        %%%% ��ͼ
plot(time,data);             % ��ͼ
xlabel('ʱ��(s)');            % ����x��
ylabel('�ź�(V)');            % ����y��
title('�����ɼ��õ�������');   % ���ñ���
grid on;                       % ��ʾ����
% wavplay(data,sampleRate);   %%%% ���Ųɼ������ź�
delete(ai);
clear ai;