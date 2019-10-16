 %载频3到8GHZ， 采样频率256MHZ， 码元速率2M，训练集每个1000个，测试集每个500个， -15dB到15dB
close all;
clear all;
clc;
tic

%fc=35e6;%载频
fs=256e6;%采样频率
fd=2e6;%码元速率
%freqsep=1e6;
Ac=1;
N_code=40;%码元数目
N_sample=3000;
N_sample_test=1000;
N_train=N_sample-N_sample_test;
%N_fe=27;
begin_snr=-5;
end_snr=5;
%kindnum_code=2;
num_code=4;
mode1= zeros(N_sample,N_code*fs/fd+1);
mode2= zeros(N_sample,N_code*fs/fd+1);
mode3= zeros(N_sample,N_code*fs/fd+1);
mode4= zeros(N_sample,N_code*fs/fd+1);
mode1tr= zeros(N_train,N_code*fs/fd+1);
mode2tr= zeros(N_train,N_code*fs/fd+1);
mode3tr= zeros(N_train,N_code*fs/fd+1);
mode4tr= zeros(N_train,N_code*fs/fd+1);
mode1te= zeros(N_sample_test,N_code*fs/fd+1);
mode2te= zeros(N_sample_test,N_code*fs/fd+1);
mode3te= zeros(N_sample_test,N_code*fs/fd+1);
mode4te= zeros(N_sample_test,N_code*fs/fd+1);
% mode5= zeros(N_sample,N_code*fs/fd+1);
% mode6= zeros(N_sample,N_code*fs/fd+1);
% mode7= zeros(N_sample,N_code*fs/fd+1);
% mode8= zeros(N_sample,N_code*fs/fd+1);
% mode9= zeros(N_sample,N_code*fs/fd+1);
% mode10=zeros(N_sample,N_code*fs/fd+1);
% mode11=zeros(N_sample,N_code*fs/fd+1);
% mode12=zeros(N_sample,N_code*fs/fd+1);
% mode13=zeros(N_sample,N_code*fs/fd+1);
% mode14=zeros(N_sample,N_code*fs/fd+1);
% mode15=zeros(N_sample,N_code*fs/fd+1);
% mode16=zeros(N_sample,N_code*fs/fd+1);
% mode17=zeros(N_sample,N_code*fs/fd+1);
% mode18=zeros(N_sample,N_code*fs/fd+1);
% mode19=zeros(N_sample,N_code*fs/fd+1);
% mode20=zeros(N_sample,N_code*fs/fd+1);
% mode21=zeros(N_sample,N_code*fs/fd+1);
% mode22=zeros(N_sample,N_code*fs/fd+1);
% mode23=zeros(N_sample,N_code*fs/fd+1);
% mode24=zeros(N_sample,N_code*fs/fd+1);
% mode25=zeros(N_sample,N_code*fs/fd+1);
% mode26=zeros(N_sample,N_code*fs/fd+1);
% mode27=zeros(N_sample,N_code*fs/fd+1);
% mode28=zeros(N_sample,N_code*fs/fd+1);
% mode29=zeros(N_sample,N_code*fs/fd+1);
% mode30=zeros(N_sample,N_code*fs/fd+1);
% mode31=zeros(N_sample,N_code*fs/fd+1);

%不加噪声的训练集
for num_sample=1:N_train    
    fprintf('itr=%d\n',num_sample);
       
    fc1=(1+rand(1))*64e6;
    yr=psk2(N_code,fc1,fs,fd,Ac);
    %yr=awgn(y,snr,'measured','db');
    yr=mapminmax(yr);
    mode1tr(num_sample,:)=[1,yr];  
    
    fc2=(1+rand(1))*64e6;
    yr=psk4(N_code,fc2,fs,fd,Ac);
    %yr=awgn(y,snr,'measured','db');
    yr=mapminmax(yr);
    mode2tr(num_sample,:)=[2,yr]; 
    
    fc3=(1+rand(1))*64e6;
    yr=qam16(N_code,fc3,fs,fd,Ac);
    %yr=awgn(y,snr,'measured','db');
    yr=mapminmax(yr);
    mode3tr(num_sample,:)=[3,yr]; 
    
    fc4=(1+rand(1))*64e6;
    yr=qam64(N_code,fc4,fs,fd,Ac);
    %yr=awgn(y,snr,'measured','db');
    yr=mapminmax(yr);
    mode4tr(num_sample,:)=[4,yr];
end
train_x=[mode1tr(1:N_train,2:end);mode2tr(1:N_train,2:end);mode3tr(1:N_train,2:end);mode4tr(1:N_train,2:end);];
train_y=[mode1tr(1:N_train,1);mode2tr(1:N_train,1);mode3tr(1:N_train,1);mode4tr(1:N_train,1);];
%disp(strcat('saving','train.mat...'))
save('../train.mat','train_x','train_y')
clear train_x train_y 

for snr = begin_snr:1:end_snr
for num_sample=1:N_sample_test
    fprintf('current snr=%d,',snr);
    fprintf('itr=%d\n',num_sample);
    
    fc1=(1+rand(1))*64e6;
    yr=psk2(N_code,fc1,fs,fd,Ac);
    yr=awgn(yr,snr,'measured','db');
    yr=mapminmax(yr);
    mode1te(num_sample,:)=[1,yr];  
    
    fc2=(1+rand(1))*64e6;
    yr=psk4(N_code,fc2,fs,fd,Ac);
    yr=awgn(yr,snr,'measured','db');
    yr=mapminmax(yr);
    mode2te(num_sample,:)=[2,yr]; 
    
    fc3=(1+rand(1))*64e6;
    yr=qam16(N_code,fc3,fs,fd,Ac);
    yr=awgn(yr,snr,'measured','db');
    yr=mapminmax(yr);
    mode3te(num_sample,:)=[3,yr]; 
    
    fc4=(1+rand(1))*64e6;
    yr=qam64(N_code,fc4,fs,fd,Ac);
    yr=awgn(yr,snr,'measured','db');
    yr=mapminmax(yr);
    mode4te(num_sample,:)=[4,yr];
    
    
end    
    if snr <0
    fdata = strcat('test_','-',num2str(abs(snr)));
    else
    fdata = strcat('test_', num2str(snr));
    
    end



test_x=[mode1te(1:N_sample_test,2:end);mode2te(1:N_sample_test,2:end);mode3te(1:N_sample_test,2:end);mode4te(1:N_sample_test,2:end);];
test_y=[mode1te(1:N_sample_test,1);mode2te(1:N_sample_test,1);mode3te(1:N_sample_test,1);mode4te(1:N_sample_test,1);];


    
    
disp(strcat('saving',32, fdata,'.mat...'))
save(strcat('../',fdata),'test_x','test_y')

%train_y=[mode1(1:N_train,1)];



%disp(strcat('saving',32, fdata,'.mat...'))
%save(strcat('../CNN_samples/',fdata),'train_x','train_y','test_x','test_y','-v7.3')

clear test_x test_y 
end


toc
