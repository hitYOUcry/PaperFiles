function FRMNT = formantCep(x,fs)
u = x;
wlen = length(x);
cepstL=50;                                        % ��Ƶ���ϴ������Ŀ��
wlen2=wlen/2;               
freq=(0:wlen2-1)*fs/wlen;                        % ����Ƶ���Ƶ�ʿ̶�
u2=u.*hamming(wlen);                                     % �źżӴ�����
U=fft(u2);                                       % ��ʽ(9-2-1)����
U_abs=log(abs(U(1:wlen2)));                      % ��ʽ(9-2-2)����
Cepst=ifft(U_abs);                               % ��ʽ(9-2-3)����
cepst=zeros(1,wlen2);           
cepst(1:cepstL)=Cepst(1:cepstL);                 % ��ʽ(9-2-5)����
cepst(end-cepstL+2:end)=Cepst(end-cepstL+2:end);
spect=real(fft(cepst));                          % ��ʽ(9-2-6)����
%%  ��spect�İ���
[Loc,Val]=findpeaks(spect);                      % Ѱ�ҷ�ֵ
data = spline(Loc,Val,Loc(1):Loc(length(Loc)));

FRMNT=freq(Loc);                                 % ����������Ƶ��