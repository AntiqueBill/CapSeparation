clear all
Nt=3;
Nr=2;
fc=3.5; %Carrier Frequency
fs=14;  %Sample Frequency
fd=0.1; %Code Rate
%freqsep=0.15;  %Frequency Interval
N_code=15;  %Number of Symbols
length = 2000;%Final length of signals
%N_samples_m = 3000;%Number of overlapped samples
%num_classes = 10;
N_train=1000;
N_valid=400;
N_test=400;
N_samples=fs/fd;%每个码元采点数目

fc_max = 1.2;
fc_min = 0.8;

Ac_max = 1.1;
Ac_min = 0.9;

snr_max = 10;
snr_min = -5;

max_shift = fs*N_code/fd - length;%14*15/0.1-2000=2100-2000
x_train=[];
y_train=[];
x_valid=[];
y_valid=[];
x_test=[];
y_test=[];
%for snr =snr_min:snr_max
    for n=1:N_train
        fc_bpsk=fc_min+(fc_max-fc_min)*unifrnd(0,1);
        fc_qpsk=fc_min+(fc_max-fc_min)*unifrnd(0,1);
        fc_qam=fc_min+(fc_max-fc_min)*unifrnd(0,1);
        Ac_bpsk=Ac_min+(Ac_max-Ac_min)*unifrnd(0,1);
        Ac_qpsk=Ac_min+(Ac_max-Ac_min)*unifrnd(0,1);
        Ac_qam=Ac_min+(Ac_max-Ac_min)*unifrnd(0,1);
        
        s_bpsk=Ac_bpsk*bpsk_complex(N_code,fc_bpsk,fs,fd);
        s_qpsk=Ac_qpsk*qpsk_complex(N_code,fc_bpsk,fs,fd);
        s_qam=Ac_qam*qam_complex(N_code,fc_bpsk,fs,fd,16);
        
        shift = randi([1, max_shift], 1, 3);
        s_bpsk = s_bpsk(1, shift(1):shift(1)+length-1);
        s_qpsk = s_qpsk(1, shift(2):shift(2)+length-1);
        s_qam = s_qam(1, shift(3):shift(3)+length-1);
        
        s_tr=[s_bpsk;s_qpsk;s_qam];
        order=randperm(3);
        s_tr=s_tr(order,:);
        
        s_tr_real=real(s_tr);
        s_tr_real=s_tr_real./sqrt(sum(s_tr_real.^2)/(fs*N_code/fd));
        s_tr_real=mapminmax(s_tr_real);
        y_train=[y_train;s_tr_real];
        
        h=sqrt(1/2) * ( randn(Nr,Nt) + sqrt(-1)*  randn(Nr,Nt) );
        
        s_trh=h*s_tr;
        s_trh_real=real(s_trh);%加入噪声前就real还是加入噪声后real？
        s_trh_real=s_trh_real./sqrt(sum(s_trh_real.^2)/(fs*N_code/fd));%先设置为功率相同以避免信噪比问题
        
        snr = randi([snr_min, snr_max],1);
        s_trh_real=awgn(s_trh_real,snr,'measured','db');
        s_trh_real=mapminmax(s_trh_real);
        
        x_train=[x_train;s_trh_real];
        fprintf('Saving...training\n');
    end
%    fprintf('Saving...\n');
%   save('../data/train_receiver ','x_train','y_train')
%end
    for n=1:N_valid
        fc_bpsk=fc_min+(fc_max-fc_min)*unifrnd(0,1);
        fc_qpsk=fc_min+(fc_max-fc_min)*unifrnd(0,1);
        fc_qam=fc_min+(fc_max-fc_min)*unifrnd(0,1);
        Ac_bpsk=Ac_min+(Ac_max-Ac_min)*unifrnd(0,1);
        Ac_qpsk=Ac_min+(Ac_max-Ac_min)*unifrnd(0,1);
        Ac_qam=Ac_min+(Ac_max-Ac_min)*unifrnd(0,1);
        
        s_bpsk=Ac_bpsk*bpsk_complex(N_code,fc_bpsk,fs,fd);
        s_qpsk=Ac_qpsk*qpsk_complex(N_code,fc_bpsk,fs,fd);
        s_qam=Ac_qam*qam_complex(N_code,fc_bpsk,fs,fd,16);
        
        shift = randi([1, max_shift], 1, 3);
        s_bpsk = s_bpsk(1, shift(1):shift(1)+length-1);
        s_qpsk = s_qpsk(1, shift(2):shift(2)+length-1);
        s_qam = s_qam(1, shift(3):shift(3)+length-1);
        
        s_tr=[s_bpsk;s_qpsk;s_qam];
        order=randperm(3);
        s_tr=s_tr(order,:);
        
        s_tr_real=real(s_tr);
        s_tr_real=s_tr_real./sqrt(sum(s_tr_real.^2)/(fs*N_code/fd));
        s_tr_real=mapminmax(s_tr_real);
        y_valid=[y_valid;s_tr_real];
        
        h=sqrt(1/2) * ( randn(Nr,Nt) + sqrt(-1)*  randn(Nr,Nt) );
        
        s_trh=h*s_tr;
        s_trh_real=real(s_trh);%加入噪声前就real还是加入噪声后real？
        s_trh_real=s_trh_real./sqrt(sum(s_trh_real.^2)/(fs*N_code/fd));%先设置为功率相同以避免信噪比问题
        
        snr = randi([snr_min, snr_max],1);
        s_trh_real=awgn(s_trh_real,snr,'measured','db');
        s_trh_real=mapminmax(s_trh_real);
        
        x_valid=[x_valid;s_trh_real];
        fprintf('Saving...validing\n');
    end
    fprintf('Saving...\n');
    save('../data/train_receiver ','x_train','y_train','x_valid','y_valid')

for snr =snr_min:snr_max
    for n=1:N_test
        fc_bpsk=fc_min+(fc_max-fc_min)*unifrnd(0,1);
        fc_qpsk=fc_min+(fc_max-fc_min)*unifrnd(0,1);
        fc_qam=fc_min+(fc_max-fc_min)*unifrnd(0,1);
        Ac_bpsk=Ac_min+(Ac_max-Ac_min)*unifrnd(0,1);
        Ac_qpsk=Ac_min+(Ac_max-Ac_min)*unifrnd(0,1);
        Ac_qam=Ac_min+(Ac_max-Ac_min)*unifrnd(0,1);
        
        s_bpsk=Ac_bpsk*bpsk_complex(N_code,fc_bpsk,fs,fd);
        s_qpsk=Ac_qpsk*qpsk_complex(N_code,fc_bpsk,fs,fd);
        s_qam=Ac_qam*qam_complex(N_code,fc_bpsk,fs,fd,16);
        %s_bpsk=bpsk_complex(N_code,fc,fs,fd);
        %s_qpsk=qpsk_complex(N_code,fc,fs,fd);
        %s_qam=qam_complex(N_code,fc,fs,fd,16);
        
        shift = randi([1, max_shift], 1, 3);
        s_bpsk = s_bpsk(1, shift(1):shift(1)+length-1);
        s_qpsk = s_qpsk(1, shift(2):shift(2)+length-1);
        s_qam = s_qam(1, shift(3):shift(3)+length-1);
        
        s_tr=[s_bpsk;s_qpsk;s_qam];
        order=randperm(3);
        s_tr=s_tr(order,:);
        
        s_tr_real=real(s_tr);
        s_tr_real=s_tr_real./sqrt(sum(s_tr_real.^2)/(fs*N_code/fd));
        s_tr_real=mapminmax(s_tr_real);
        y_test=[y_test;s_tr_real];
        
        h=sqrt(1/2) * ( randn(Nr,Nt) + sqrt(-1)*  randn(Nr,Nt) );
        
        s_trh=h*s_tr;
        s_trh_real=real(s_trh);%加入噪声前就real还是加入噪声后real？
        s_trh_real=s_trh_real./sqrt(sum(s_trh_real.^2)/(fs*N_code/fd));%先设置为功率相同以避免信噪比问题
        
        s_trh_real=awgn(s_trh_real,snr,'measured','db');
        s_trh_real=mapminmax(s_trh_real);
        
        x_test=[x_test;s_trh_real];
    end
    if snr <0
        fdata = strcat('test','_',num2str(abs(snr)));
    else
        fdata = strcat('test', num2str(snr));
    end
    disp(strcat('saving',snr,'.mat...'))
    save(strcat('../data/',fdata),'x_test','y_test','snr')
    
    x_test=[];
    y_test=[];
end

