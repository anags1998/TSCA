clear all
close all

randn('seed',-1);rand('seed',-1);

% Parámetros
numero_de_bits=12

%--- modulacion

bits    = fuente(numero_de_bits)

M = 4
constelacion = constelacion_4psk();
Eav=mean( sqrt(sum(constelacion.^2,2)))

[Ik,Qk] = asignacion_simbolos(bits,constelacion);
figure, plot(Ik,".")
figure, plot(Qk,".")
ver_constelacion(constelacion);

fp=1000
fb=100
fs = fb / log2(M);
fm = 2*(fp + fb) * 10;

% Pulso conformador rectangular
[pulso,retardo] = rect(fm,fs);

[I,Q] = filtro_tx(Ik,Qk,fm,fs,pulso);
figure, plot(I,"LineStyle","-")
figure, plot(Q,"LineStyle","-")
[xI,xQ] = modulador(I,Q,fm,fp);
x=xI+xQ;
figure, plot(xI,"LineStyle","-")
figure, plot(xQ,"LineStyle","-")

%---- Sin canal
r = x; 

Es = sum(pulso.^2)

%--- demodulacion

[xI,xQ] = demodulador(r,fm,fp);

[I,Q]   = filtro_rx(xI,xQ,pulso);

[Ik,Qk] = muestreo(I,Q,fm,fs,retardo);

D       = distancias(Ik,Qk,constelacion);

bitsr   = decodificador_map(D)

bits

Pb = sum(bits ~= bitsr )/numero_de_bits