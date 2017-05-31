clc
clear all;
close all;
%% read in wav file
%filename = 'test_1.wav';
%filename = 'test.wav';
filename = 'sa1.wav';
[y ,fs] = audioread(filename);
y = y(:,1);
n = size(y,1);

%% enframe
win_len =20 * fs / 1000;
inc = round( 0.5 * win_len);
w = hamming(win_len);
s = enframe(y,win_len,inc);
y = i_enframe(s,inc);
frame_len = size(s,1);
fft_res = zeros(frame_len,win_len/2 + 1);
%% add noise
%y =  awgn(y,55);
snr = 3;
ny = awgn(y,snr,'measured');
noise = ny - y;

snr = 10 * log10(sum(y.*y)/sum(noise.*noise));

%% cal noised signal gains
s_ny = enframe(ny,win_len,inc);
s_y = enframe(y,win_len,inc);
s_n = enframe(noise,win_len,inc);

%% deal with the enframed data
N = mid(win_len);
sny_new = zeros(frame_len,win_len);
sy_new = zeros(frame_len,win_len);
sn_new = zeros(frame_len,win_len);

gains = zeros(frame_len,win_len);

%% diff sce factor snr,snr = 0:0.05:1

M = 20;
max_f = 1;
snr_before = zeros(1,M+1);
snr_after = zeros(1,M+1);
y_reduce = zeros(1,M+1);
noise_reduce = zeros(1,M+1);
for k =  0:M
    factor = max_f/M * k;
    for j = 1:frame_len
        frame_data = s_ny(j,:);
        fft_data = fft(frame_data,win_len);
        fft_res(j,:) = abs(fft_data(1:win_len/2 + 1));

        diff_1 = diff(fft_res(j,:),1);
        power_sum = sum(fft_res(j,:));
        if power_sum < 10e-03
              sny_new(j,:) = frame_data;
              continue;
        end
        [sny_new(j,:),gains(j,:)]= SCE(frame_data,factor,fs);
    end

    for j = 1:frame_len
        temp = s_y(j,:);
        t_fft = fft(temp,win_len);
        t_fft_amp = abs(t_fft) + gains(j,:);
        t_fft_ang = angle(t_fft);
        t_fft = t_fft_amp.*exp(1i*t_fft_ang);
        sy_new(j,:) = cal_amp(ifft(t_fft));

        temp = s_n(j,:);
        t_fft = fft(temp,win_len);
        t_fft_amp = abs(t_fft) + gains(j,:);
        t_fft_ang = angle(t_fft);
        t_fft = t_fft_amp.*exp(1i*t_fft_ang);
        sn_new(j,:) = cal_amp(ifft(t_fft)); 
    end
    y_new = i_enframe(sy_new,inc);
    n_new = i_enframe(sn_new,inc);

    snr_before(k+1) = 10 * log10(sum(y.*y)/sum(noise.*noise));
    snr_after(k+1) = 10 * log10(sum(y_new.*y_new)/sum(n_new.*n_new));
    y_reduce(k+1) = 10 * log10(sum(y.*y)/sum(y_new.*y_new));
    noise_reduce(k+1) = 10 * log10(sum(noise.*noise)/sum(n_new.*n_new));
    disp(k);
end

figure;

width=1200;%宽度，像素数
height=400;%高度
left=200;%距屏幕左下角水平距离
bottem=300;%距屏幕左下角垂直距离
set(gcf,'position',[left,bottem,width,height])

subplot(1,2,1);
x = (0:20)*max_f/M;
plot(x,snr_before,'g');
hold on
plot(x,snr_after,'r--');
%set(gca,'YLim',[0.8 2.1]);
title(['原始信号 SNR = ',num2str(snr),'dB']);
xlabel('SCE factor');
ylabel('SNR值(dB)');
legend('处理前SNR','处理后SNR');

subplot(1,2,2);
x = (0:20)*max_f/M;
plot(x,y_reduce,'g');
hold on
plot(x,noise_reduce,'r--');
%set(gca,'YLim',[0.8 2.1]);
title(['原始信号 SNR = ',num2str(snr),'dB']);
xlabel('SCE factor');
ylabel('reduce (dB)');
legend('信号','噪声');
