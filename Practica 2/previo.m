%% Apartado 2.1 Conformado de haz con referencia temporal (TRB) óptimo invariante
clear all;
close all;

%definicion de parametros
N = 8; 
tfin = 2000; 
lamda = 1; 
d = lamda/2; 
theta = [-15*(pi/180) 10*(pi/180)];
SNR = 20;

fs = 2e3;
t = linspace(0,tfin-1/fs,tfin);
senal = cos(2*pi*100*t);
inter = cos(2*pi*50*t);
A  = [senal;inter];

%calculo de los snapshot
x = snapshot (N,lamda,d,theta,SNR,A);
Rxx = x*x';
r = senal;
Prx = x*r';

%Factor de Array
w_opt = inv(Rxx)*Prx;
theta_array = linspace(-pi/2,pi/2,2000);
vector = (0:1:N-1).';
Dd = exp(-i*(2*pi/lamda)*d*vector*sin(theta_array));
Factor_array = w_opt'*Dd;

figure,
plot(theta_array*180/pi,20*log10(abs(Factor_array))),title("Factor de Array");

%Señal de salida
y =w_opt'*x;

figure,
plot((abs(y))),title("Señal de salida");

Ddmax = max(20*log10(abs(Factor_array)));
Ddmin = min(20*log10(abs(Factor_array)));
CI = Ddmax - Ddmin;
