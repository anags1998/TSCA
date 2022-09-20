clear all
close all

randn('seed',-1);rand('seed',-1);

% Parámetros
numero_de_bits=480;%tiene que ser multiplo de 3

%--- modulacion

bits    = fuente(numero_de_bits);
M=8;
constelacion = constelacion_8psk();
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
EbN0dB = 0:1:8;

for i=1:9
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


Pb(i) = sum(bits ~= bitsr )/numero_de_bits; %tasa teorica de error
%--- Pb teorica
EbN0(i) = 10.^(EbN0dB(i)/10);
Pb_teorica(i) = (2/log2(M))*fQ(sqrt(2*EbN0(i)*log2(M))*sin(pi/M));
Pb_cotaexp(i) = 1/2 * exp(-EbN0(i));

end
figure, 
subplot(2,1,1);plot(pulso), title("Pulso conformado")
subplot(2,1,2);semilogy(EbN0dB,Pb)
hold on 
semilogy(EbN0dB,Pb_teorica)
hold on 
semilogy(EbN0dB,Pb_cotaexp)
legend("Pb real en funcion de EbN0","Pb teórica en funcion de EbN0","Cota exponencia")