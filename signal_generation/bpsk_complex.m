function y=bpsk_complex(N_code,fc,fs,fd)
    N_samples=fs/fd;
    t = 1:N_samples;
    x_bpsk = randi(2,1,N_code);
    s_bpsk = pskmod(x_bpsk-1, 2);
    fc_bpsk = cos(2*pi*fc*t/fs)+j*sin(2*pi*fc*t/fs);
    gt=ones(1,N_samples);
    St_complex=zeros(1,N_samples*N_code);
    for n1=1:N_code
        St_complex((N_samples*(n1-1)+1):(N_samples*(n1-1)+N_samples))=(s_bpsk(n1)*fc_bpsk).*gt;
    end
    y=St_complex;