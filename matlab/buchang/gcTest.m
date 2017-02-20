load('chapter4_sa2.mat');
load('y_original.mat');
load('y_formant.mat');
load('y_sce.mat');
load('y_new.mat');

t = (1:length(y))/fs;
% wav graph
figure;
subplot(4,1,1)
plot(t,y);
title('ԭʼ ����');
xlabel('ʱ��')
ylabel('����')
subplot(4,1,2)
plot(t,y_formant);
title('�������ǿ ����');
xlabel('ʱ��')
ylabel('����')
subplot(4,1,3)
plot(t,y_sce);
title('�������ǿ&SCE ����');
xlabel('ʱ��')
ylabel('����')
subplot(4,1,4)
plot(t,y_new);
title('������������ǿ && SCE && ��Ȳ���������');
xlabel('ʱ��')
ylabel('����')


figure;
subplot(4,1,1)
plot_spec(y,win_len,fs,-70,15);
title('ԭʼ ����');
xlabel('ʱ�� / s')
ylabel('Ƶ�� / Hz')
subplot(4,1,2)
plot_spec(y_formant,win_len,fs,-70,15);
title('�������ǿ ����');
xlabel('ʱ�� / s')
ylabel('Ƶ�� / Hz')
subplot(4,1,3)
plot_spec(y_sce,win_len,fs,-70,15);
title('�������ǿ&&SCE ����');
xlabel('ʱ�� / s')
ylabel('Ƶ�� / Hz')
subplot(4,1,4)
plot_spec(y_new,win_len,fs,-70,15);
title('������������ǿ && SCE && ��Ȳ���������');
xlabel('ʱ�� / s')
ylabel('Ƶ�� / Hz')


