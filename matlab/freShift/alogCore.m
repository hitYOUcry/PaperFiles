function y = alogCore(x,fa,fb,fc,fd,fbb,fcc,fs)

% cal fft of original signal
N = length(x);
X = fft(x,N,2);


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


% cal compress segment
Xab = X(na:nbb);
T = nb - nbb;
L = floor((nb - na)/T);
for i = 1:T
    for j = 1:(L-1)
         Xab((i-1) * L + j) = X(na + (i-1) * L + j- 1);
    end
end

% cal stretch segment
Xbc = X(nbb:ncc);
temp = X(nb:nc);
R = floor((ncc-nbb)/(nc-nb))+ 1 * (mod((ncc-nbb),(nc-nb)~=0));
ST = interp(temp,R);
L1 = R * length(temp);
L2 = ncc - nbb + 1;
T = L1 - L2;
L = floor(L1 / T);
for i = 1:T
    for j = 1:(L-1)
         Xbc((i-1) * L + j) = ST((i-1) * L + j);
    end
end

% cal compress segment
Xcd = X(ncc:nd);
T = (nd - nc) - (nd - ncc);
L = floor((nd - nc) / T);
for i = 1:T
    for j = 1:(L-1)
         Xcd((i-1) * L + j) = X(nc + (i-1) * L + j - 1);
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
y = ifft(XNew, N, 2);
end



