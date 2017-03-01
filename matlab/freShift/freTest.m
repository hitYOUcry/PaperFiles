clc;
clear all;
close all;
inf = 1E-10;
%% read wav file
filename = 'sa1.wav';
%filename = 'TX5_4.wav';
%filename='si1549.wav';
[y ,fs] = audioread(filename);
y = y(:,1);
n = size(y,1);
N = 512;
midN = mid(N);
f_o_s = 0;
f_o_e = fs / 2;
f_t_s = 0;
f_t_e = fs / 2 - 100;
comRatio = (f_o_e - f_o_s) / (f_t_e - f_t_s);
new_N = N * comRatio;
midN_new = mid(new_N);
%% base zero detect
for i = 1:n
    if abs(y(i)) > 10e-04
        break;
    end
end
for j = n:-1:1
     if abs(y(j)) > 10e-04
        break;
    end
end
y = y(i:j);
n = size(y,1);
%% enframe
win_len = N;
inc = round( 0.5 * win_len);
w = hamming(win_len);
s = enframe(y,win_len,inc);
y = i_enframe(s,inc);
frame_num = size(s,1);

%% frequency shift
%N = 1024;
%midN = mid(N);
for i = 1: frame_num
    x =  s(i,:);
   %  s_new(i,:) = alogTwo(x,7000,fs);
 % s_new(i,:) = comAndTen(x,1,7599,8000,1,7999,fs);
    s_new(i,:) = alogCore(x,900,8000,8000,8000,5980,8000,fs);
 %   [NewFFT,s_new(i,:)] = alogOne(x,1000,1100,979,1131,fs);
    spec = 20 * log(inf + abs(fft(x)));
    Spe(i,:) = spec(1:(midN-1));
    spec = abs(fft(s_new(i,:)));
    spec = 20 * log(inf + spec);
    Spe_new(i,:) = spec(1:(midN-1));
   %{
    S = fft(x,N);
    S_new = zeros(1,new_N);
    S_new(1:midN) = S(1:midN);
    if mod(new_N,2) == 1
        for j = midN_new:-1:2
         S_new(2 * midN_new - j + 1) = conj(S_new(j));
        end
    else
        for j = (midN_new-1):-1:2
            S_new(2 * midN_new - j) = conj(S_new(j));
        end
    end
   % S_new = resample(S_new,N,new_N);
   temp = cal_amp(ifft(S_new));
    s_new(i,:) = resample(temp,N,new_N);
    %}
    
    %{
    %% ��֡plot
    S_amp = abs(S);
    t1 = (0 : (N - 1))/N * fs;
    S_amp_new = abs(S_new);
    t2 = (0 : (new_N - 1))/new_N * fs;
    figure
    subplot(2,1,1)
    plot(t1, S_amp);
    subplot(2,1,2);
    plot(t2,S_amp_new);
    %}
    
    %{
    %% ����ѹ��
    len_ori = length(x);
    x = resample(x,len_ori * 3,len_ori);
    S = fft(x);
    S_amp = abs(S);
    S_angle = angle(S);
    %% Ƶ�װ���

    N_t =  length(x);
    midN = mid(N_t);
    S_m = S_amp(1:midN);
    S_m_new = S_m;
    delta_f = fs /2 /(midN - 1);
    index_a = 1 + f_o_s / delta_f;
    index_b = 1 + f_o_e / delta_f;
    index_c = 1 + f_t_s / delta_f;
    index_d = 1 + f_t_e / delta_f;
    for j = 1 : midN
        if j < index_c || j > index_d;
            S_m_new(j) = 0;
        else
            o_j = (j - index_c) / (index_d - index_c) * (index_b - index_a) + index_a;
            o_j = round(o_j);
            S_m_new(j) = S_m(o_j);
        end
    end
    if mod(N,2) == 1
        for j = midN:-1:2
         S_m_new(2 * midN - j + 1) = S_m_new(j);
        end
    else
        for j = (midN-1):-1:2
            S_m_new(2 * midN - j) = S_m_new(j);
        end
    end
   new_fft = S_m_new.*exp(1i*S_angle);
   new_wav = cal_amp(ifft(new_fft));
   new_wav = resample(new_wav,len_ori,N_t);
   s_new(i,:) = new_wav;
   %}
    
    %{
    %% ����ֵ
    xx = Inter(x,1);
    SS_amp = abs(fft(xx));
    %}
end
y_new = i_enframe(s_new,inc);



figure;
t = (1:length(y))/fs;
f = (1:(midN-1))*fs/win_len;


subplot(2,2,1)
plot(t,y);
title('ԭʼ����');

subplot(2,2,2)
plot(t,y_new);
title('����������');


subplot(2,2,3)
imagesc(t,f,Spe');
axis xy; 
colormap(jet)
title('ԭʼƵ��');
xlabel('ʱ�� / s')
ylabel('Ƶ�� / Hz')

%image((0:frame_num) * inc / fs,(0:midN)/N * fs,Spe')
%axis xy
%colormap(jet)

subplot(2,2,4)
%f = (1:(midN*0.75))*fs/win_len;
imagesc(t,f,Spe_new');
axis xy; 
colormap(jet);
title('������Ƶ��');
xlabel('ʱ�� / s')
ylabel('Ƶ�� / Hz')
caxis([-200,30])
%}

%{
figure;
subplot(1,2,1)
%plot_spec(y,win_len,fs,-60,15);
%plotSpec2(y,win_len,fs);
n = N;
spectrogram(y,n,n * 3 / 4,n,fs,'yaxis');
colormap(jet);
colorbar('off')
title('ԭʼ����');
%xlabel('ʱ�� / s')
%ylabel('Ƶ�� / Hz')
subplot(1,2,2)
%plot_spec(y_new,win_len,fs,-50,15);
%plotSpec2(y_new,3*win_len,fs);
spectrogram(y_new,n,n * 3 / 4,n,fs,'yaxis');
colormap(jet);
colorbar('off')
axis([0 length(y)/fs 0 8]);
title('�㷨�������');
%xlabel('ʱ�� / s')
%ylabel('Ƶ�� / Hz')



fprintf('Press any key to play the first wav...\n');
pause;
p = audioplayer(y, fs);
play(p);

fprintf('Press any key to play the second wav...\n');
pause;
p = audioplayer(3 * y_new, fs);
play(p);

%}

%{
figure;
subplot(2,1,1);
t1 = (0 : (N - 1)) * fs;
plot(t1,S_amp);
subplot(2,1,2);
t2 = (0 : (N - 1)) * 2fs;
plot(S_m_new);
%}
