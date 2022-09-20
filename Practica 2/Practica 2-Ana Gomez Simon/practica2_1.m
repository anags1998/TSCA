%% Apartado 2.1 Conformado de haz con referencia temporal (TRB) óptimo invariante
clear all;
close all;

N = 8; 
%N=4, 16, 32

%theta = [-15*(pi/180) +10*(pi/180)];
theta = [-15*(pi/180) +10*(pi/180) 0*(pi/180) -20*(pi/180) -40*(pi/180)];

fo=1e9;
lamda = 3e8/fo;
d = lamda/2; 

SNR =20; 
%SNR=10, 0
            
%frecuencia de muestreo
fs = 2e3;

%cantidad de snapshots
tfin = 2000; 

%tiempo en el que muestrear las señales
t = linspace(0,tfin-1/fs,tfin);

senal = cos(2*pi*100*t);
% inter = cos(2*pi*50*t);
inter1 = cos(2*pi*50*t);
inter2 = cos(2*pi*150*t);
inter3 = cos(2*pi*200*t);
inter4 = cos(2*pi*250*t);

%A  = [senal;inter];
A  = [senal;inter1; inter2; inter3; inter4];

%calculo de los snapshot
x = snapshot(N,lamda,d,theta,SNR,A);


% Diseño de array óptimo con referencia temporal
Rxx = x*x';
r = senal;
Prx = x*r';

wopt=inv(Rxx)*Prx;
%%
% Factor de array
alfa=-90:0.1:90;
D = exp(-j*(2*pi/lamda)*d*(0:1:N-1).'*sin(alfa*pi/180));

F=wopt'*D; 

figure
plot(alfa,20*log10(abs(F)))
title( 'Factor de array');
ylabel ('dB');
xlabel('theta º');

%%
%Señal de salida y 
y=wopt'*x;
figure
plot(abs(y));
title ('Señal de salida y');

%%

thetad=-15;
Dd = exp(-j*(2*pi/lamda)*d*(0:1:N-1).'*sin(thetad*pi/180));%DOA señal
% 
% thetai=10;
% Di = exp(-j*(2*pi/lamda)*d*(0:1:N-1).'*sin(thetai*pi/180));%DOA interferencia
% 
% C_I=20*log10(abs(wopt'*Dd)/abs(wopt'*Di));

% % cuando hay mas de una interferencia  
thetai=[10, 0, -20, -40];
for p=1:4
    Di = exp(-j*(2*pi/lamda)*d*(0:1:N-1).'*sin(thetai(p)*pi/180));%DOA interferencia
    C_I(p)=20*log10(abs(wopt'*Dd)/abs(wopt'*Di));

end
