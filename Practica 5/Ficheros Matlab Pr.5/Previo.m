%% Canal 2a
% ancho de banda
close all
clear all
N=40000;
fm=20e3;
delta=zeros(1,N);
delta(N/2)=1;
h=canal2a(delta,fm);
H=abs(fft(h));
figure
f=linspace(0,fm,length(delta));
plot(f,10*log10(H));

% SNR
fp=2500;
fm=20000;
mean_window=5;
t_sim= 100;
t=0:1/fm:t_sim-1/fm;
x=cos(2*pi*fp*t);
Y=abs(fft(canal2a(x,fm)));
Y_mean=movmean(Y/max(Y),mean_window);
f=linspace(-fm/2,fm/2,length(x));
figure
plot(f,10*log10(Y_mean));

% capacidad
B=3e3;
SNR_dB=25;
SNR=10^(SNR_dB/10);
C= B*log2(1+SNR);
