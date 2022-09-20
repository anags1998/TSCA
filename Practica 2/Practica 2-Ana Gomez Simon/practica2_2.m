%% 2.2 Conformado de haz con referencia temporal (TRB) adaptativo con algoritmo LMS
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

x = snapshot(N,lamda,d,theta,SNR,A);


w=zeros(N,  tfin);
w(:,1)=1;

r=senal;
u=0.001;

for i =1:1:tfin
    e=r(i)-w(:,i)'*x(:,i);
    w(:,i+1)=w(:,i)+u*e'*x(:,i);
end
close all
for i=1:8
    figure
    subplot(2,1, 1);
    plot(abs(w(i,:)));
    title(['Magnitud W(',num2str(i),')']);
    hold on
    subplot(2,1, 2);
    plot(angle(w(i,:)));
    title(['Fase W(',num2str(i),')']);
end


alfa=-90:0.1:90;
D = exp(-j*(2*pi/lamda)*d*(0:1:N-1).'*sin(alfa*pi/180)); 


wopt=w(:,end);
F=wopt'*D; 


figure
plot(alfa,20*log10(abs(F)))
title( 'Factor de array');
ylabel ('dB');
xlabel('theta º');
%%


thetad=-15;
Dd = exp(-j*(2*pi/lamda)*d*(0:1:N-1).'*sin(thetad*pi/180));

thetai=[10, 0, -20, -40];
for p=1:4
    Di = exp(-j*(2*pi/lamda)*d*(0:1:N-1).'*sin(thetai(p)*pi/180));
    C_I(p)=20*log10(abs(wopt'*Dd)/abs(wopt'*Di));

end


