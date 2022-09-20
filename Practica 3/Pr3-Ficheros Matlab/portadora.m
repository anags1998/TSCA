clear all; close all;

% simulación portadora 

numero_de_bits=1
fp=1000;
fb=10;
fm = 20*(fp + fb)
tiempo_de_simulacion = numero_de_bits / fb
t = 0:1/fm:tiempo_de_simulacion-1/fm;
x = cos(2*pi*fp*t);
figure;
plot(t,x)
ylabel('portadora')
xlabel('t')


% FFT
fm = 2*(fp + fb)
t = 0:1/fm:tiempo_de_simulacion-1/fm;
x = cos(2*pi*fp*t);
N = length(x);
X = fftshift( abs(  fft(x, N )) );
f=-fm/2:fm/N:fm/2-fm/N;
figure;
plot(f,X)
xlabel('f')

% FFT, sobremuestreo f
N = length(x)*10;  
X = fftshift( abs(  fft(x, N )) );
f=-fm/2:fm/N:fm/2-fm/N;
figure;
plot(f,X)
xlabel('f')

% FFT, sobremuestreo t
fm = 2*(fp + fb) * 10; 
t = 0:1/fm:tiempo_de_simulacion-1/fm;
x = cos(2*pi*fp*t);
N = length(x);
X = fftshift( abs(  fft(x, N )) );
f=-fm/2:fm/N:fm/2-fm/N;
figure;
plot(f,X)
xlabel('f')