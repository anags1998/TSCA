clear all
close all

randn('seed',-1);rand('seed',-1);

% Parámetros
numero_de_bits=1000

%--- modulacion

bits    = fuente(numero_de_bits);

M=4;
constelacion = constelacion_4psk();

Eav=mean( sqrt(sum(constelacion.^2,2)))

[Ik,Qk] = asignacion_simbolos(bits,constelacion);

ver_constelacion(constelacion);

fp=1000
fb=100
fs = fb / log2(M);
fm = 2*(fp + fb) * 10;

% Pulso conformador rectangular
[pulso,retardo] = rect(fm,fs);

[I,Q] = filtro_tx(Ik,Qk,fm,fs,pulso);

[xI,xQ] = modulador(I,Q,fm,fp);
x=xI+xQ;

%%%% Canal gaussiano
Es = sum(pulso.^2)
Eb = Es/log2(M);

EbN0dB = 3;  % Relación Eb/N0 (dB)
n = canal_awgn(x,Eb,EbN0dB);  % Ruido generado
r=x+n;

%--- demodulacion

[xI,xQ] = demodulador(r,fm,fp);

[I,Q]   = filtro_rx(xI,xQ,pulso);

[Ik,Qk] = muestreo(I,Q,fm,fs,retardo);

D       = distancias(Ik,Qk,constelacion);

bitsr   = decodificador_map(D);
bits;

% Plot constelación recibida
figure(2)
plot(Ik, Qk, 'ob')
grid on;

Pb = sum(bits ~= bitsr )/numero_de_bits
Pb_teorica = fQ(sqrt(2*EbN0dB));

