function [y, y_complex]=psk2_complex(N_code,fc,fs,fd,Ac)
x=randi([0,1],1,N_code);
N=length(x);
nsamp=fs/fd;
for j=1:N
	if x(j)==0
	   for i=1:nsamp
		 y((j-1)*nsamp+i)=Ac*cos(2*pi*fc*(i-1)/fs);
         y_complex((j-1)*nsamp+i)=Ac*cos(2*pi*fc*(i-1)/fs)+j*Ac*sin(2*pi*fc*(i-1)/fs);
       end
	else
	   for i=1:nsamp
		 y((j-1)*nsamp+i)=Ac*cos(2*pi*fc*(i-1)/fs+pi);
         y_complex((j-1)*nsamp+i)=Ac*cos(2*pi*fc*(i-1)/fs+pi) + j*Ac*sin(2*pi*fc*(i-1)/fs+pi);
        end     
    end
end