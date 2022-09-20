clear all;
close all;
%% 8PSK
numero_de_bits = 30000;%multiplo de 3
bits = fuente(numero_de_bits);

% Constelación 8psk
constelacion = constelacion_tcm_8psk();
ver_constelacion(constelacion);
Eav=mean(sum(constelacion.^2,2))
M = size(constelacion,1)

% Crear Trellis
%G = [1 1 1;
 %    1 0 1];
%G = [0 1 0; 1 0 1];
G = [1 0 1; 0 1 0];%mejor
nbits_sin_codificar = 1;
trellis = crear_trellis(G, nbits_sin_codificar);
ver_trellis(trellis);

% Codificación TCM bits 
bits_cod = codificar_trellis(bits, trellis);

[Ik,Qk] = asignacion_simbolos(bits_cod,constelacion);

fp = 3000;
fb = 300;
fm = 4*fp;
fs = fb / log2(M);

[pulso,retardo] = rcos(fm,fs,0.5,5);
[I,Q] = filtro_tx(Ik,Qk,fm,fs,pulso);
[xI,xQ] = modulador(I,Q,fm,fp);
x=xI+xQ;

%----------------------------------------
% CANALES: ideal, awgn
% Canal ideal
% r = x;

% Canal_awgn
Es = sum(pulso.^2);
Eb = Es/log2(M);
EbN0dB = 0:1:6;
for i=1:7
n = canal_awgn(x,Eb,EbN0dB(i));
r=x+n;
%---------------------------------------

% Demodulador
[xI,xQ] = demodulador(r,fm,fp);
[I,Q]   = filtro_rx(xI,xQ,pulso);
[Ik,Qk] = muestreo(I,Q,fm,fs,retardo);
D = distancias(Ik,Qk,constelacion);

bitsr   = decodificar_trellis(trellis, D);
bits;
%Pb = sum(bits ~= bitsr )/numero_de_bits

Pbtcm(i) = sum(bits ~= bitsr )/numero_de_bits; %tasa real de error



end
%% 4PSK
randn('seed',-1);rand('seed',-1);

% Parámetros
numero_de_bits=1000;%tiene que ser multiplo de 2

%--- modulacion

bits    = fuente(numero_de_bits);
M=4;
constelacion = constelacion_4psk();
Eav=mean( sqrt(sum(constelacion.^2,2)));

[Ik,Qk] = asignacion_simbolos(bits,constelacion);

ver_constelacion(constelacion);

fp=1000;
fb=100;
fs = fb / log2(M);
fm = 2*(fp + fb) * 10;

% Pulso conformador rectangular
[pulso,retardo] = rcos(fm,fs,0.5,5);

[I,Q] = filtro_tx(Ik,Qk,fm,fs,pulso);

[xI,xQ] = modulador(I,Q,fm,fp);
x=xI+xQ;

%%%% Canal gaussiano
Es = sum(pulso.^2);
Eb = Es/log2(M);

%esta es la que venia EbN0dB = 0;  % Relación Eb/N0 (dB)
%la nueva para 15
EbN0dB = 0:1:6;

for i=1:7
n = canal_awgn(x,Eb,EbN0dB(i));  % Ruido generado
r=x+n;

%--- demodulacion

[xI,xQ] = demodulador(r,fm,fp);

[I,Q]   = filtro_rx(xI,xQ,pulso);

[Ik,Qk] = muestreo(I,Q,fm,fs,retardo);

D       = distancias(Ik,Qk,constelacion);

bitsr   = decodificador_map(D);
bits;

% Plot constelación recibida
% figure(2)
% plot(Ik, Qk, 'ob')
% grid on;


Pb4psk(i) = sum(bits ~= bitsr )/numero_de_bits;
%--- Pb teorica
EbN0(i) = 10.^(EbN0dB(i)/10);
Pb_teorica(i) = fQ(sqrt(2*EbN0(i)*(10^(3/10))));
end
%% figuras
figure,
semilogy(EbN0dB,Pbtcm)
hold on
semilogy(EbN0dB,Pb4psk)
hold on
semilogy(EbN0dB,Pb_teorica)
legend("Pb 8PSK TCM en funcion de EbN0","Pb 4PSK en funcion de EbN0","Pb PSK teorica")