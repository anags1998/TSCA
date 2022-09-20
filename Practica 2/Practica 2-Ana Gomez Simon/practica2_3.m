%% 2.3 Conformado de haz con restricciones espaciales óptimo invariante
close all;
clear all;


%numero de sensores
N=8;

%angulo theta para el doa
theta = [-15*(pi/180) +10*(pi/180) 0*(pi/180) -20*(pi/180) -40*(pi/180)];

%lamda y d, parámetros necesario para el DOA
fo=1e9;
lamda = 3e8/fo; 
d = lamda/2; 

%relación señal a ruido del canal
SNR = 20; 
            
%frecuencia de muestreo
fs = 2e3;

%cantidad de snapshots
tfin = 5000; 

%tiempo en el que muestrear las señales
t = linspace(0,tfin-1/fs,tfin);

senal = cos(2*pi*100*t);
inter1 = cos(2*pi*50*t);
inter2 = cos(2*pi*150*t);
inter3 = cos(2*pi*200*t);
inter4 = cos(2*pi*250*t);

A  = [senal;inter1; inter2; inter3; inter4];

%calculo de los snapshot
x = snapshot(N,lamda,d,theta,SNR,A);



thetad=-15;
Dd = exp(-j*(2*pi/lamda)*d*(0:1:N-1).'*sin(thetad*pi/180));

thetai=[10, 0, -20, -40];
Di = exp(-j*(2*pi/lamda)*d*(0:1:N-1).'*sin(thetai*pi/180));

C=[Dd , Di];
f=[1, 0, 0, 0, 0];

wopt=C*inv(C'*C)*f';

alfa=-90:0.1:90;
D = exp(-j*(2*pi/lamda)*d*(0:1:N-1).'*sin(alfa*pi/180));

F=wopt'*D; 

figure
plot(alfa,20*log10(abs(F)))
title( 'Factor de array');
ylabel ('dB');
xlabel('theta º');


for p=1:4
    C_I(p)=20*log10(abs(wopt'*C(:,1))/abs(wopt'*C(:,p+1)));

end
%% Conociendo el Doa de la señal solo
thetad=-15;
Dd = exp(-j*(2*pi/lamda)*d*(0:1:N-1).'*sin(thetad*pi/180));%DOA señal

Rxx=x*x';


wopt=(inv(Rxx)*Dd)/(Dd'*inv(Rxx)*Dd);


alfa=-90:0.1:90;
D = exp(-j*(2*pi/lamda)*d*(0:1:N-1).'*sin(alfa*pi/180));
F=wopt'*D; 

figure
plot(alfa,20*log10(abs(F)))
title( 'Factor de array');
ylabel ('dB');
xlabel('theta º');


thetad=-15;
Dd = exp(-j*(2*pi/lamda)*d*(0:1:N-1).'*sin(thetad*pi/180));%DOA señal

thetai=[10, 0, -20, -40];
for p=1:4
    Di = exp(-j*(2*pi/lamda)*d*(0:1:N-1).'*sin(thetai(p)*pi/180));%DOA interferencia
    C_I(p)=20*log10(abs(wopt'*Dd)/abs(wopt'*Di));

end