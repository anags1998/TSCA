clear all;
close all;

% Generación del Trellis
G = [0 1 0;
     1 0 1];
nbits_sin_codificar = 1;

trellis = crear_trellis(G, nbits_sin_codificar)

ver_trellis(trellis)

% Constelación tcm_8psk
constelacion = constelacion_tcm_8psk();
ver_constelacion(constelacion);

% Bits fuente y bits codificados
bits = [1 1 1 0 1 1];
bits_cod = codificar_trellis(bits, trellis)

% Modulador
[Ik,Qk] = asignacion_simbolos(bits_cod,constelacion)

fp = 1000;
fb = 300;
fm = 4*fp;

M = size(constelacion,1);
fs = fb / log2(M);
[pulso,retardo] = rect(fm,fs);
[I,Q]   = filtro_tx(Ik,Qk,fm,fs,pulso);
x       = modulador(I,Q,fm,fp);

% Canal ideal
r = x;

% Demodulador
[xI,xQ] = demodulador(r,fm,fp);
[I,Q]   = filtro_rx(xI,xQ,pulso);
[Ik,Qk] = muestreo(I,Q,fm,fs,retardo);
D       = distancias(Ik,Qk,constelacion)

bitsr   = decodificar_trellis(trellis, D)

bits


