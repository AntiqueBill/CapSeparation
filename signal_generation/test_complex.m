clear all
N_code=10;
fc = 50;
fs = 40;
fd=4;
Ac=1;

M=16;
k=log2(M);
n=N_code*k;%
N_samples=fs/fd;%
x=randi([0,1],1,n);%

x4=reshape(x,k,length(x)/k);%
xsym=bi2de(x4.','left-msb');%

%y=modulate(modem.qammod(M),xsym);%
y=qammod(xsym,M);

t=1:N_samples;
%carrier=Ac*cos(2*pi*fc*t/fs);
carrier=Ac*cos(2*pi*fc*t/fs);
carrier2=Ac*sin(2*pi*fc*t/fs);
gt=ones(1,length(carrier));

St_complex=zeros(1,length(carrier)*length(y));
q=length(carrier);
p=length(y);
z= St_complex;
St_complex2=zeros(1,length(carrier)*length(y));
for n1=1:length(y)
    St_complex((N_samples*(n1-1)+1):(N_samples*(n1-1)+N_samples))=(y(n1)*carrier).*gt;
    St_complex2((N_samples*(n1-1)+1):(N_samples*(n1-1)+N_samples))=(y(n1)*carrier2).*gt;
end
%figure(3)
y2=St_complex+j*St_complex2;
y=real(St_complex);
% 
% fc=7e7;
% fs=2e8;
% fd=2e6;
% freqsep=1e6;
% df=25e5;
% dalpha=0.25e5;
% Ac=1;
% N_code = 1000;
% 
% N_sample=81;
% N_sample_test=1;
% N_train=N_sample-N_sample_test;
% begin_snr=0;
% end_snr=20;
% kindnum_code=2;
% num_code=4;
% N_fe=15;
% 
% 
% Rsym = fd;                % Input symbol rate
% Rbit = Rsym;
% %Rbit = Rsym * log2(M);      % Input bit rate
% Nos = fs/fd;                    % Oversampling factor
% ts = (1/Rbit) / Nos/3;        % Input sample period
% chan = stdchan(ts, 0, 'cost207RAx6');
% yr=filter(chan,y);
% %title('QAM仿真波形�?g(t)为升余弦脉冲');
% %xlabel('采样�?)
% %ylabel('幅度')