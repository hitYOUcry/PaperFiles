x = 10:10:100;
%{
y_before = [0 0 0 4 10 20 38 58 68 74];
y_after = [0 0 0 6 10 22 40 60 72 82];
figure;
set(gca,'YLim',[0 100]);
plot(x,y_before,'r-*');
hold on;
plot(x,y_after,'b-+');
set(gca,'YLim',[0 100]);
xlabel('声压级/dB SPL');
ylabel('言语识别率/%');
legend('原始词表','处理后词表');
%}

y_before = [0 4 12 32 46 58 64 78 86 92];
y_after = [0 6 20 40 54 64 72 84 90 92];
figure;
set(gca,'YLim',[0 100]);
plot(x,y_before,'r-*');
hold on;
plot(x,y_after,'b-+');
set(gca,'YLim',[0 100]);
xlabel('声压级/dB SPL');
ylabel('言语识别率/%');
legend('原始词表','处理后词表');