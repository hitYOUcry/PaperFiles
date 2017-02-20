function logspec = cal_outSpl2(fs , logOriginal)
%      125  250   500  750 1K    1.5K 2K   3K  4K   5K  8K ��dB SPL��
k_fs =  [0 125 250 500 750 1000 1500 2000 3000 4000 5000 8000];
%% GB4854-84
thr_gb  =   [45 45   25.5    11.5   7.5   7    6.5    9   10    9.5   13   13];
thr  =   [70 70   68    66   67    69   65    70   75    80   86   90];%dB SPL
N = length(logOriginal);
logspec = logOriginal;

maxSpec = max(logOriginal);
minSpec = min(logOriginal);
midN = mid(N);

maxThr = max(thr);
minThr = min(thr);

for i = 1:midN
    f = i / N * fs;
    a = 1;
    b = 2;
    while b < length(k_fs) && f>k_fs(b)
        a = a + 1;
        b = b + 1;
    end
    k = (f - k_fs(a)) / (k_fs(b) - k_fs(a));
    thr0_low = linearInterp(k,thr_gb(a),thr_gb(b));
    thr_f = linearInterp(k,thr(a),thr(b));
     if logOriginal(i) < thr0_low
        continue;
    end
    
    b = (thr_f - minThr) / (maxThr - minThr);
    amp_c = (logOriginal(i) - minSpec) / (maxSpec - minSpec);
    f_c =  f / ( fs) ;
    logspec(i) =  logspec(i) + thr_f / 3 * f_c;
    %logspec(i) =  logspec(i) + (getGain(thr_f,logOriginal(i)) + thr_f )  * b * (1 - amp_c) * f_c;
    %{
    l_c = logOriginal(i)/thr_f;
    if l_c>1
         logspec(i) =  logspec(i) + 1 / l_c * f_c * (logOriginal(i) - thr_f);
    else
        logspec(i) =  logspec(i) * (1 + f_c * (thr_f - logspec(i)) / thr_f);
    end
    %}
end

if mod(N,2) == 1
    for j = midN:-1:2
        logspec(2 * midN - j + 1) = logspec(j);
    end
else
    for j = (midN-1):-1:2
        logspec(2 * midN - j) = logspec(j);
    end
end
%{
t = 1 : N;
figure;
plot(t,logOriginal,t,logspec);
%}
