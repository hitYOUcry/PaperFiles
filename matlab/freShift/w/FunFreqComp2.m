function [y,SO] = FunFreqComp(s, fs, fl, fh, ratio, Nw, Ns)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  frequency compression function                       %
%  s -- input signal                                    %
%  fs -- samping ratio                                  %
%  fl -- low freq of the stretching frequency field     %
%  fh -- high freq of the stretching frequency field    %
%  ratio -- stretching ratio                            %
%  Nw -- FFT points                                     %
%  Ns -- shift points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%窗函数
winfunc = @(L,S)(sqrt(2*S/(L*(2*0.5^2+(-0.5)^2)))*(0.5-0.5*cos((2*pi*((0:L-1)+0.5))/L)));
w = winfunc(Nw, Ns); 
nfft=Nw;

D = mod(length(s), Ns);                          % we will add Nw-D zeros to the end
G = (ceil(Nw/Ns)-1)*Ns;                          % we will add G zeros to the beginning
s = [zeros(1,G) s' zeros(1,Nw-D)];               % zero pad signal to allow an integer number of segments
L = length(s);                                   % length of the signal for processing (after padding)
M = ((L-Nw)/Ns)+1;                               % number of overlapped segments
indf = Ns*[0:(M-1)].';                           % frame indices
inds = [1:Nw];                                   % sample indices in each frame
refs = indf(:,ones(1,Nw)) + inds(ones(M,1),:);   % absolute sample indices for each frame
frames = s(refs) * diag(w);                      % split into overlapped frames using indexing (frames as rows), apply analysis window
S = fft(frames, nfft, 2);
%SO =S;
SO=zeros(1,length(S));
nl=floor(Nw*fl/fs);
nh=floor(Nw*fh/fs);
ls2=nh-nl;
temp=zeros(1,ls2);
for i=1:M
    % Stretching
    temp=S(i,nl+1:nh);
    ST1=interp(temp,2);
    temp=S(Nw-nh+1:Nw-nl);
    ST2=interp(temp,2);
    % filter
%     [b,a]=butter(4,1/2,'low');
%     ST1=filter(b,a,ST1);
%     ST2=filter(b,a,ST2);
    SO(i,nl-ls2/2+1:nh+ls2/2)=ST1;
    SO(i,Nw-nh-ls2/2+1:Nw-nl+ls2/2)=ST2;


%    for k=1:ls2
%        SO(i,nl-ls2/2+(k-1)*2+1)=S(i,nl+k);  %   S[nl+1,nh]
%        SO(i,nl-ls2/2+(k-1)*2+2)=S(i,nl+k);
%        SO(i,Nw-nh-ls2/2+(k-1)*2+1)=S(i,Nw-nh+(k-1)*2+1);
%        SO(i,Nw-nh-ls2/2+(k-1)*2+2)=S(i,Nw-nh+(k-1)*2+2);
%    end

    % Compression
    cr1=floor(nl/(ls2/2)); % ls2/2 is the added point number of [0, nl]
    N=floor(nl/cr1);
    SC1=zeros(1,nl-ls2/2);
    for k=0:N-1            % get rid of a point per cr1 points
       for j=1:(cr1-1)
          SC1(k*(cr1-1)+j)=S(i,k*cr1+j);
       end
    end
    SC1(N*(cr1-1)+1:nl-ls2/2)=S(i,N*cr1+1:nl);
    SC2=zeros(1,nl-ls2/2);
    for k=0:N-1            % get rid of a point per cr1 points
        for j=0:(cr1-2)
            SC2(nl-ls2/2-(k*(cr1-1)+j))=S(i,Nw-(k*cr1+j));
        end
    end
    SC2(1:nl-ls2/2-N*(cr1-1))=S(i,Nw-nl+1:Nw-N*cr1);
    %connect pieces into the output
    SO(i,1:nl-ls2/2)=SC1;
    SO(i,Nw-nl+ls2/2+1:Nw)=SC2;
    cr2=floor((Nw/2-nh)/(ls2/2)); % ls2/2 is the added point number of [nh+1, ls/2]
    N=floor((Nw/2-nh)/cr2);
    SR1=zeros(1,(Nw/2-nh)-ls2/2);
    for k=0:N-1            % get rid of a point per cr2 points
        for j=1:(cr2-1)
            SR1(k*(cr2-1)+j)=S(i,nh+k*cr2+j);
        end
    end
    SR1(N*(cr2-1)+1:Nw/2-nh-ls2/2)=S(i,nh+N*cr2+1:Nw/2);
    SR2=zeros(1,(Nw/2-nh)-ls2/2);
    for k=0:N-1            % get rid of a point per cr2 points
        for j=0:(cr2-2)
            SR2(Nw/2-nh-ls2/2-(k*(cr2-1)+j))=S(i,Nw-nh-(k*cr2+j));
        end
    end
    SR2(1:Nw/2-nh-ls2/2-N*(cr2-1))=S(i,Nw/2+1:Nw-nh-N*cr2);
    %connect pieces into the output
    SO(i,nh+ls2/2+1:Nw/2)=SR1;
    SO(i,Nw/2+1:Nw-nh-ls2/2)=SR2;
end
figure(2);
% frequency response 
f=([1:Nw]-1)*fs/Nw;

ami=abs(S(9,:));
amo=abs(SO(9,:));
angi=angle(S(9,:));
ango=angle(SO(9,:));
subplot(2,2,1);plot(f,ami);title('处理前幅频响应');xlabel('f /Hz');ylabel('Mag');axis([fl-500 fh+500 0 0.5]);%axis([3 8000 0 1.5]);
subplot(2,2,2);plot(f,amo);;title('处理后幅频响应');xlabel('f /Hz');ylabel('Mag');axis([fl-500 fh+500 0 0.5]);%axis([3 8000 0 1.5]);
subplot(2,2,3);plot(f,angi);title('处理前相频响应');xlabel('f /Hz');ylabel('Angle');axis([fl-500 fh+500 -4 4]);%axis([3 8000 -4 4]);
subplot(2,2,4);plot(f,ango);title('处理后相频响应');xlabel('f /Hz');ylabel('Angle');axis([fl-500 fh+500 -4 4]);%axis([3 8000 -4 4]);

%reconstruction
x = real(ifft(SO, nfft, 2));                  % perform inverse STFT analysis
x = x(:, 1:Nw);                               % discard FFT padding from frames
x = x .* w(ones(M,1),:);                     % apply synthesis window (Griffin & Lim's method)
y = zeros(1, L); for i = 1:M, y(refs(i,:)) = y(refs(i,:)) + x(i,:); end; % overlap-add processed frames
wsum2 = zeros(1, L); for i = 1:M, wsum2(refs(i,:)) = wsum2(refs(i,:)) + w.^2; end; % overlap-add squared window samples
y = y./wsum2;                                % divide out squared and summed-up analysis windows
y = y(G+1:L-(Nw-D))';                             % remove the padding
% regulation
yy=mapminmax(y',-1,1);
y=yy';
