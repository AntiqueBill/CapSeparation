function y=qam_complex(N_code,fc,fs,fd,M)
    N_samples=fs/fd;
    t = 1:N_samples;
    x_qam = randi(M,1,N_code);
    s_qam = qammod(x_qam-1, M);
    fc_qam = exp(1i*2*pi*fc/fs*t);
    gt=ones(1,N_samples);
    St_complex=zeros(1,N_samples*N_code);
    for n1=1:N_code
        St_complex((N_samples*(n1-1)+1):(N_samples*(n1-1)+N_samples))=(s_qam(n1)*fc_qam).*gt;
    end
    y=St_complex;