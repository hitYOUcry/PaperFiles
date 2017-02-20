clear
%��berlin������
pathname = uigetdir(cd, '��ѡ���ļ���');
if pathname == 0
    msgbox('��û����ȷѡ���ļ���');
    return;
end

%������ж���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%fear
fileswavfear = ls(strcat(pathname,'\A(fear)\*.wav'));
filesfear = [cellstr(fileswavfear)]; % �õ��ļ�·��
lenfear = length(filesfear); % �ļ�����
%disgust
fileswavdisgust = ls(strcat(pathname,'\E(disgust)\*.wav'));
filesdisgust = [cellstr(fileswavdisgust)]; % �õ��ļ�·��
lendisgust = length(filesdisgust); % �ļ�����
%joy
fileswavjoy = ls(strcat(pathname,'\F(joy)\*.wav'));
filesjoy = [cellstr(fileswavjoy)]; % �õ��ļ�·��
lenjoy = length(filesjoy); % �ļ�����
%boredom
fileswavboredom = ls(strcat(pathname,'\L(boredom)\*.wav'));
filesboredom = [cellstr(fileswavboredom)]; % �õ��ļ�·��
lenboredom = length(filesboredom); % �ļ�����
%neutral
fileswavneutral = ls(strcat(pathname,'\N(neutral)\*.wav'));
filesneutral = [cellstr(fileswavneutral)]; % �õ��ļ�·��
lenneutral = length(filesneutral); % �ļ�����
%sadness
fileswavsadness = ls(strcat(pathname,'\T(sadness)\*.wav'));
filessadness = [cellstr(fileswavsadness)]; % �õ��ļ�·��
lensadness = length(filessadness); % �ļ�����
%anger
fileswavanger = ls(strcat(pathname,'\W(anger)\*.wav'));
filesanger = [cellstr(fileswavanger)]; % �õ��ļ�·��
lenanger = length(filesanger); % �ļ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%�������ݸ�ֵ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fs=16000;%����Ƶ��Hz
framelength=0.028;%֡��s
frameshift=0.014;%֡��s
hwin=hamming(framelength*fs)';%����
featurenum=408;%��ʼ����ά��
%���������е�����ʸ��������Ϊ�����������������Ϊ��ʼ����ά��
featurefear=zeros(lenfear,featurenum);
featuredisgust=zeros(lendisgust,featurenum);
featurejoy=zeros(lenjoy,featurenum);
featureboredom=zeros(lenboredom,featurenum);
featureneutral=zeros(lenneutral,featurenum);
featuresadness=zeros(lensadness,featurenum);
featureanger=zeros(lenanger,featurenum);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



for i = 1:lenfear
    tempfile=wavread(char(filesfear(i)));
    featurefear(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%���������
end
for i = 1:lendisgust
    tempfile=wavread(char(filesdisgust(i)));
    featuredisgust(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%���������
end
for i = 1:lenjoy
    tempfile=wavread(char(filesjoy(i)));
    featurejoy(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%���������
end
for i = 1:lenboredom
    tempfile=wavread(char(filesboredom(i)));
    featureboredom(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%���������
end
for i = 1:lenneutral
    tempfile=wavread(char(filesneutral(i)));
    featureneutral(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%���������
end
for i = 1:lensadness
    tempfile=wavread(char(filessadness(i)));
    featuresadness(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%���������
end
for i = 1:lenanger
    tempfile=wavread(char(filesanger(i)));
    featureanger(i,:)=GetUtterFeature(tempfile,framelength,frameshift,fs)';
    clear tempfile;%���������
end

save featurefear 'featurefear';
save featuredisgust 'featuredisgust';
save featurejoy 'featurejoy';
save featureboredom 'featureboredom';
save featureneutral 'featureneutral';
save featuresadness 'featuresadness';
save featureanger 'featureanger';

% clear
% 
% load 'featurefear.mat';
% load 'featuredisgust.mat';
% load 'featurejoy.mat';
% load 'featureboredom.mat';
% load 'featureneutral.mat';
% load 'featuresadness.mat';
% load 'featureanger.mat';
