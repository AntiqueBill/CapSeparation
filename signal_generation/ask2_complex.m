%N_code 码元 fs 抽样频率，fc载频， fd码元速率
function [y, y_complex]=ask2_complex(N_code,fc,fs,fd,Ac)
x=randi([0,1],1,N_code);
N=length(x);
nsamp=fs/fd;
% x=2*x-1;
for j=1:N
    for i=1:nsamp
		y((j-1)*nsamp+i)=sqrt(2)*x(j)*Ac*cos(2*pi*fc*(i-1)/fs);
        y_complex((j-1)*nsamp+i)=sqrt(2)*x(j)*Ac*cos(2*pi*fc*(i-1)/fs)+j*sqrt(2)*x(j)*Ac*sin(2*pi*fc*(i-1)/fs);
    end
end