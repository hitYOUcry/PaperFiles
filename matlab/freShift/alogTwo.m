%
%ÆµÂÊÑ¹Ëõ´¦Àí
%
function y = alogTwo(x,fc,fs)
N = length(x);
X = fft(x);
X_amp = abs(X);
X_angle = angle(X);
midN = mid(N);
delta_f = fs / 2 / (midN - 1);
C = round(fc/delta_f);
X_amp_new = zeros(1,N);
X_angle_new = zeros(1,N);

X_amp_new(1:C) = imresize(X_amp,[1,C]);
X_angle_new(1:C) = imresize(X_angle,[1,C]);
if mod(N,2) == 1
        for j = midN:-1:2
         X_amp_new(2 * midN - j + 1) = X_amp_new(j);
         X_angle_new(2 * midN - j + 1) = -X_angle_new(j);
        end
    else
        for j = (midN-1):-1:2
            X_amp_new(2 * midN - j) = X_amp_new(j);
             X_angle_new(2 * midN - j) = -X_angle_new(j);
        end
end
new_fft = X_amp_new.*exp(1i*X_angle_new);
y = cal_amp(ifft(new_fft));
