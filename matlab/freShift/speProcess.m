load data.mat;
a = 200;
b = 250;
c = 175;
d = 275;
N = length(x);

%% 伸缩 处理
x_1 = zeros(N,1);
for i = 1:N
    if i <= c
        t = a * i / c;
    else if i <= d
            t = a + (b - a) * (i - c) / (d- c);
        else
            t = b + (N - b) * (i - d)/(N -d);
        end
    end
    t1 = floor(t);
    t2 = ceil(t);
    if(t1 == t2)
        x_1(i) = x(t);
    else
        x_1(i) = x(t1) + (t - t1)/(t2-t1) * (x(t2) - x(t1));
    end
end

%% 向下压缩 处理
x_2 = zeros(N,1);
for i = 1:N
    if i <= a
        t = b * i / a;
        t1 = floor(t);
        t2 = ceil(t);
        if(t1 == t2)
            x_2(i) = x(t);
        else
            x_2(i) = x(t1) + (t - t1)/(t2-t1) * (x(t2) - x(t1));
        end
    else
         x_2(i) = x(i);
    end
end

%% 向上压缩 处理
x_3 = zeros(N,1);
for i = 1:N
    if i <= b
        x_3(i) = x(i);
    else
          t =(N - a) / (N - b) * (i - b) + a;
          t1 = floor(t);
          t2 = ceil(t);
          if(t1 == t2)
              x_3(i) = x(t);
          else
              x_3(i) = x(t1) + (t - t1)/(t2-t1) * (x(t2) - x(t1));
          end
    end
end

%% 画图
axis_x = 0.5 * (1:N)/ N * fs;
figure;
subplot(4,1,1);
plot(axis_x,x);
hold on;
plot([axis_x(a) axis_x(a)],[x(a) -200],'--k')
plot([axis_x(b) axis_x(b)],[x(b) -200],'--k')
xlabel('频率/Hz');
title('原始频谱');

subplot(4,1,2);
plot(axis_x,x_1);
hold on;
plot([axis_x(c) axis_x(c)],[x_1(c) -150],'--k')
plot([axis_x(d) axis_x(d)],[x_1(d) -150],'--k')
xlabel('频率/Hz');
title('伸缩频谱');

subplot(4,1,3);
plot(axis_x,x_2);
hold on;
plot([axis_x(a) axis_x(a)],[x_2(a) -150],'--k')
xlabel('频率/Hz');
title('向下压缩频谱');

subplot(4,1,4);
plot(axis_x,x_3);
hold on;
plot([axis_x(b) axis_x(b)],[x_3(b) -150],'--k')
xlabel('频率/Hz');
title('向上压缩频谱');