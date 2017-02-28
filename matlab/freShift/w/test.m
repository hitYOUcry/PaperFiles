clc;
close all;
clear all;

%[s,fs]=wavread('chezhan_16k.wav');
[s,fs]=wavread('sa1.wav');
h = audioplayer(s,fs);
play(h);
%wavplay(s,fs);

n=1:length(s);
t=n/fs;
Nw=1024;
Ns=256;

%[y,SO] = FunFreqComp1(s,fs,1875,2125,2,Nw,Ns);
[y,SO] = FunFreqComp2(s,fs,1000,1200,2,Nw,Ns);  % test phase

figure(1);
subplot(2,2,1),plot(t,s),axis([0 1.4 -1 1]),xlabel('时间 /秒'),ylabel('幅度');
subplot(2,2,2),plot(t,y),axis([0 1.4 -1 1]),xlabel('时间 /秒'),ylabel('幅度');
subplot(2,2,3),spectrogram(s,1024,896,1024,fs,'yaxis');
colormap(jet);colorbar('off');
subplot(2,2,4),spectrogram(y,1024,896,1024,fs,'yaxis');
colormap(jet);colorbar('off');
%wavplay(y,fs);
h = audioplayer(y,fs);
play(h);