clear
%��Enterface�����ݣ�ѡ��enterface_database_new���ļ���
pathname = uigetdir(cd, '��ѡ���ļ���');
if pathname == 0
    msgbox('��û����ȷѡ���ļ���');
    return;
end

%������ж���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%anger
fileswavanger = ls(strcat(pathname,'\anger\*.wav'));
filesanger = [cellstr(fileswavanger)]; % �õ��ļ�·��
lenanger = length(filesanger); % �ļ�����
%disgust
fileswavdisgust = ls(strcat(pathname,'\disgust\*.wav'));
filesdisgust = [cellstr(fileswavdisgust)]; % �õ��ļ�·��
lendisgust = length(filesdisgust); % �ļ�����
%fear
fileswavfear = ls(strcat(pathname,'\fear\*.wav'));
filesfear = [cellstr(fileswavfear)]; % �õ��ļ�·��
lenfear = length(filesfear); % �ļ�����
%happy
fileswavhappy = ls(strcat(pathname,'\happy\*.wav'));
fileshappy = [cellstr(fileswavhappy)]; % �õ��ļ�·��
lenhappy = length(fileshappy); % �ļ�����
%sadness
fileswavsadness = ls(strcat(pathname,'\sadness\*.wav'));
filessadness = [cellstr(fileswavsadness)]; % �õ��ļ�·��
lensadness = length(filessadness); % �ļ�����
%surprise
fileswavsurprise = ls(strcat(pathname,'\surprise\*.wav'));
filessurprise = [cellstr(fileswavsurprise)]; % �õ��ļ�·��
lensurprise = length(filessurprise); % �ļ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%�������ݸ�ֵ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fs=48000;%����Ƶ��Hz
framelength=0.028;%֡��s
frameshift=0.014;%֡��s
hwin=hamming(framelength*fs)';%����
featurenum=408;%��ʼ����ά��
%���������е�����ʸ��������Ϊ�����������������Ϊ��ʼ����ά��
Enterfeatureanger=zeros(lenanger,featurenum);
Enterfeaturedisgust=zeros(lendisgust,featurenum);
Enterfeaturefear=zeros(lenfear,featurenum);
Enterfeaturehappy=zeros(lenhappy,featurenum);
Enterfeaturesadness=zeros(lensadness,featurenum);
Enterfeaturesurprise=zeros(lensurprise,featurenum);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



for i = 1:lenanger
    tempfile=readwav(strcat(pathname,'\anger\',char(filesanger(i))));
    tempfile=tempfile(:,1);
    Enterfeatureanger(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%���������
end
for i = 1:lendisgust
    tempfile=readwav(strcat(pathname,'\disgust\',char(filesdisgust(i))));
    tempfile=tempfile(:,1);
    Enterfeaturedisgust(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%���������
end
for i = 1:lenfear
    tempfile=readwav(strcat(pathname,'\fear\',char(filesfear(i))));
    tempfile=tempfile(:,1);
    Enterfeaturefear(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%���������
end
for i = 1:lenhappy
    tempfile=readwav(strcat(pathname,'\happy\',char(fileshappy(i))));
    tempfile=tempfile(:,1);
    Enterfeaturehappy(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%���������
end
for i = 1:lensadness
    tempfile=readwav(strcat(pathname,'\sadness\',char(filessadness(i))));
    tempfile=tempfile(:,1);
    Enterfeaturesadness(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%���������
end
for i = 1:lensurprise
    tempfile=readwav(strcat(pathname,'\surprise\',char(filessurprise(i))));
    tempfile=tempfile(:,1);
    Enterfeaturesurprise(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%���������
end


save Enterfeatureanger 'Enterfeatureanger';
save Enterfeaturedisgust 'Enterfeaturedisgust';
save Enterfeaturefear 'Enterfeaturefear';
save Enterfeaturehappy 'Enterfeaturehappy';
save Enterfeaturesadness 'Enterfeaturesadness';
save Enterfeaturesurprise 'Enterfeaturesurprise';

% clear
% 
% load 'featurefear.mat';
% load 'featuredisgust.mat';
% load 'featurejoy.mat';
% load 'featureboredom.mat';
% load 'featureneutral.mat';
% load 'featuresadness.mat';
% load 'featureanger.mat';
