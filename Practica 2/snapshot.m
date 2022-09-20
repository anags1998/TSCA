function x = snapshot (N,lamda,d,theta,SNR,A)
%%Definicion de variables
Ns = length(theta);
s = (0:1:N-1).';
%Calculos x
D = exp(-j*(2*pi/lamda)*d*s*sin(theta)); 


xfin = D*A;
x = awgn(xfin,SNR);



