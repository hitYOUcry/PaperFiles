function [X_amp_new,y] = alogOne(x,fa,fb,fc,fd,fs)
N = length(x);
X = fft(x);
X_amp = abs(X);
X_angle = angle(X);
midN = mid(N);
delta_f = fs / 2 / (midN - 1);
X_amp_new = zeros(1,midN);
X_angle_new = zeros(1,midN);

da = 1 + fa/delta_f;
db = 1 + fb/delta_f;
dc = 1 + fc/delta_f;
dd = 1 + fd/delta_f;
for i = 1:midN
    if i <= dc
        t = da / dc * i;
    else if i <= dd
            t = (db - da) / (dd - dc) * (i - dc) + da;
        else
            t = (midN - db) / (midN- dd) * (i - dd) + db;
        end
    end
    t1 = floor(t);
    t2 = ceil(t);
    if(t1 == t2)
        X_amp_new(i) = X_amp(t);
        X_angle_new(i) = X_angle(t);
    else
        X_amp_new(i) = X_amp(t1) + (t - t1)/(t2-t1) * (X_amp(t2) - X_amp(t1));
         X_angle_new(i) = X_angle(t1) + (t - t1)/(t2-t1) * (X_angle(t2) - X_angle(t1));
    end
    
end
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