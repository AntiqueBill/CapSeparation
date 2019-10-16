function y=qpsk_complex(N_code,fc,fs,fd)
    N_samples=fs/fd;
    t = 1:N_samples;
    x_qpsk = randi(4,1,N_code);
    s_qpsk = pskmod(x_qpsk-1, 4);
    fc_qpsk = exp(1i*2*pi*fc/fs*t);
    gt=ones(1,N_samples);
    St_complex=zeros(1,N_samples*N_code);
    for n1=1:N_code
        St_complex((N_samples*(n1-1)+1):(N_samples*(n1-1)+N_samples))=(s_qpsk(n1)*fc_qpsk).*gt;
    end
    y=St_complex;