close all;
clear all;
clc;

warning off

fc=3.5; %Carrier Frequency
fs=14;  %Sample Frequency
fd=0.1; %Code Rate
freqsep=0.15;  %Frequency Interval
N_code=15;  %Number of Symbols
length = 2000;%Final length of signals
N_samples_m = 30000;%Number of overlapped samples
N_samples_valid = 10000;
num_classes = 6;

fc_max = 1.15;
fc_min = 0.85;

Ac_max = 1.1;
Ac_min = 0.9;

snr_max = 15;
snr_min = 0;
max_targets = 3;
min_targets = 3;

max_shift = fs*N_code/fd - length;

fprintf('Generating overlapped samples...\nMax_target = %d\n', max_targets);

x_train = zeros(N_samples_m*2, length);
y_label = zeros(N_samples_m*3, num_classes);
y_transmitter = zeros(N_samples_m*3, length);

idx_tar = randi([min_targets, max_targets], 1, N_samples_m);
for i=1:N_samples_m
    if mod(i, 2000) == 0
        fprintf('   itr=%d\n',i);
    end
    class_i = randperm(6);
    class_i = class_i(1:idx_tar(i));
    fcc = unifrnd (fc_min, fc_max,size(class_i,2),1);
    Acc = unifrnd (Ac_min, Ac_max,size(class_i,2),1);
    shift = unidrnd (max_shift,size(class_i,2),1);
    y = zeros(idx_tar(i), length);%idx_i(i)这一条的混合数目
    y_complex = zeros(idx_tar(i), length);
    for j =1:size(class_i,2)
        switch class_i(j)
            case 1
                [yr, yr_complex]=ask2_complex(N_code,fcc(j),fs,fd,1);
                yr = yr/sqrt(sum(yr.^2)/(fs*N_code/fd))*Acc(j);
                yr_complex = yr_complex/sqrt(sum(yr_complex.*conj(yr_complex))/(fs*N_code/fd))*Acc(j);
                y(j,:) = yr(1, shift(j):shift(j)+length-1);
                y_complex(j,:) = yr_complex(1, shift(j):shift(j)+length-1);
                y_label(i, class_i(j))=1;
            case 2
                [yr, yr_complex]=fsk2_complex(N_code,fcc(j),fs,fd,freqsep,1);
                yr = yr/sqrt(sum(yr.^2)/(fs*N_code/fd))*Acc(j);
                yr_complex = yr_complex/sqrt(sum(yr_complex.*conj(yr_complex))/(fs*N_code/fd))*Acc(j);
                y(j,:) = yr(1, shift(j):shift(j)+length-1);
                y_complex(j,:) = yr_complex(1, shift(j):shift(j)+length-1);
                y_label(i, class_i(j))=1;
%             case 3
%                 yr=fsk4(N_code,fcc(j),fs,fd,freqsep,1);
%                 yr = yr/sqrt(sum(yr.^2)/(fs*N_code/fd))*Acc(j);
%                 y(j,:) = yr(1, shift(j):shift(j)+length-1);
%                 y_train(i, class_i(j))=1;
%             case 4
%                 yr=fsk8(N_code,fcc(j),fs,fd,freqsep,1);
%                 yr = yr/sqrt(sum(yr.^2)/(fs*N_code/fd))*Acc(j);
%                 y(j,:) = yr(1, shift(j):shift(j)+length-1);
%                 y_train(i, class_i(j))=1;
            case 3
                [yr, yr_complex]=psk2_complex(N_code,fcc(j),fs,fd,1);
                yr = yr/sqrt(sum(yr.^2)/(fs*N_code/fd))*Acc(j);
                yr_complex = yr_complex/sqrt(sum(yr_complex.*conj(yr_complex))/(fs*N_code/fd))*Acc(j);
                y(j,:) = yr(1, shift(j):shift(j)+length-1);
                y_complex(j,:) = yr_complex(1, shift(j):shift(j)+length-1);
                y_label(i, class_i(j))=1;
            case 4
                [yr, yr_complex]=psk4_complex(N_code,fcc(j),fs,fd,1);
                yr = yr/sqrt(sum(yr.^2)/(fs*N_code/fd))*Acc(j);
                yr_complex = yr_complex/sqrt(sum(yr_complex.*conj(yr_complex))/(fs*N_code/fd))*Acc(j);
                y(j,:) = yr(1, shift(j):shift(j)+length-1);
                y_complex(j,:) = yr_complex(1, shift(j):shift(j)+length-1);
                y_label(i, class_i(j))=1;
%             case 5
%                 yr=psk8(N_code,fcc(j),fs,fd,1);
%                 yr = yr/sqrt(sum(yr.^2)/(fs*N_code/fd))*Acc(j);
%                 y(j,:) = yr(1, shift(j):shift(j)+length-1);
%                 y_train(i, class_i(j))=1;
            case 5
                [yr, yr_complex]=qam_complex(N_code,fcc(j),fs,fd,16);
                yr = yr/sqrt(sum(yr.^2)/(fs*N_code/fd))*Acc(j);
                yr_complex = yr_complex/sqrt(sum(yr_complex.*conj(yr_complex))/(fs*N_code/fd))*Acc(j);
                y(j,:) = yr(1, shift(j):shift(j)+length-1);
                y_complex(j,:) = yr_complex(1, shift(j):shift(j)+length-1);
                y_label(i, class_i(j))=1;
%             case 7
%                 yr=qam64(N_code,fcc(j),fs,fd,1);
%                 yr = yr/sqrt(sum(yr.^2)/(fs*N_code/fd))*Acc(j);
%                 y(j,:) = yr(1, shift(j):shift(j)+length-1);
%                 y_train(i, class_i(j))=1;
            case 6
                [yr, yr_complex]=msk_complex(N_code,fs,fd,fcc(j),1);
                yr = yr/sqrt(sum(yr.^2)/(fs*N_code/fd))*Acc(j);
                yr_complex = yr_complex/sqrt(sum(yr_complex.*conj(yr_complex))/(fs*N_code/fd))*Acc(j);
                y(j,:) = yr(1, shift(j):shift(j)+length-1);
                y_complex(j,:) = yr_complex(1, shift(j):shift(j)+length-1);
                y_label(i, class_i(j))=1;
        end
    end
    %y_r = sum(y, 1);
    y_transmitter(3*i-2:3*i, :) = y;
    
    h=sqrt(1/2) * ( randn(2,3) + sqrt(-1)*  randn(2,3) );%3发2收
    s_trh=h*y_complex;
    s_trh_real=real(s_trh);
    snr = randi([snr_min, snr_max],1);
    x_train(2*i-1:2*i,:) = awgn(s_trh_real, snr, 'measured','db');
end

Ac = [Ac_min, Ac_max];
fc = [fc_min, fc_max];
snr = [snr_min, snr_max];
x_valid = x_train(1: N_samples_valid*2, :);
x_train = x_train(N_samples_valid*2+1:N_samples_m*2, :);
y_label_valid = y_label(1:N_samples_valid*3, :);
y_label = y_label(N_samples_valid*3+1:N_samples_m*3, :);
y_valid = y_transmitter(1:N_samples_valid*3, :);
y_transmitter = y_transmitter(N_samples_valid*3+1:N_samples_m*3, :);

fprintf('Saving...train\n');
save('../data/dataset_train','x_train','y_label','y_transmitter','x_valid', 'y_label_valid', 'y_valid', 'Ac','fc', 'snr','length','-v7.3')