function y = alogCore(x,fa,fb,fc,fd,fbb,fcc,fs)

% cal fft of original signal
N = length(x);
X = fft(x,N,2);
X_angle = angle(X);
X = abs(X);


% cal delta f
M = mid(N);
XNew = zeros(1,M);

delta_f = fs / 2 / (M - 1);

na = floor(fa/delta_f);
nb = floor(fb/delta_f);
nc = floor(fc/delta_f);
nd = floor(fd/delta_f);
nbb = floor(fbb/delta_f);
ncc = floor(fcc/delta_f);
k = 1;
m = 1;

% cal compress segment
T = nb - nbb;
if T == 0
    Xab = X(na+1:nbb);
else
    Xab = zeros(1,nbb-na);
    L = floor((nb - na)/T);
    remain = mod(nb-na,T);
    for i = 1:T
        for j = 1:(L-1)
            m = (i-1) * (L-1) + j;
            k =  na + (i-1) * L + j;
            Xab(m) = X(k);
        end
    end
    for i = 1:remain
        m = m+1;
        k = k+1;
        Xab(m) = X(k);
    end 
end
%



% cal stretch segment
T = nc-nb;
if T == 0
    Xbc = zeros(1,ncc-nbb);
else
    temp = X(nb+1:nc);
    R = floor((ncc-nbb)/(nc-nb))+ 1;
    %ST = interp(temp,R);
    ST = resample(temp,R*length(temp),length(temp));
    %Xbc = ST(1:ncc-nbb);
    Xbc = zeros(1,ncc-nbb);
    L1 = R * length(temp);
    L2 = ncc - nbb;
    T = L1 - L2;
    L = floor(L1 / T);
    remain = mod(L1,T);
    for i = 1:T
        for j = 1:(L-1)
             m = (i-1) * (L-1) + j;
             k =  (i-1) * L + j;
             Xbc(m) = ST(k);
        end
    end
    for i = 1:remain
        m = m+1;
        k = k+1;
        Xbc(m) = ST(k);
    end
end



% cal compress segment
T = (nd - nc) - (nd - ncc);
if T == 0
    Xcd = X(ncc+1:nd);
else
    Xcd = zeros(1,nd - ncc);
    L = floor((nd - nc) / T);
    remain = mod(nd-nc,T);
    for i = 1:T
        for j = 1:(L-1)
             m = (i-1) * (L-1) + j;
             k = nc + (i-1) * L + j;
             Xcd(m) = X(k);
        end
    end
    for i = 1:remain
        m = m+1;
        k = k+1;
        Xcd(m) = X(k);
    end
end




% reconstruction
XNew(1:na) = X(1:na);
XNew(na+1:nbb) = Xab(1:nbb-na);
XNew(nbb+1:ncc) = Xbc(1:ncc - nbb);
XNew(ncc+1:nd) = Xcd(1:nd - ncc);
XNew(nd+1:M) = X(nd+1:M);
if mod(N,2) == 1
        for j = M:-1:2
            XNew(2 * M - j + 1) = XNew(j);
        end
    else
        for j = (M-1):-1:2
            XNew(2 * M - j) = XNew(j);
        end
end

XNew = XNew.*exp(1i*X_angle);
y = (ifft(XNew, N, 2));
end



