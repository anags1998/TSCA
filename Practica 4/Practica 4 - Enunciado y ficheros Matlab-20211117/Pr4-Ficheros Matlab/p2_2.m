%% Ejemplo para 'canal1a' y 'canal1b' 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;

tiempo_maximo   = 1000;
potencia_maxima = 1;
Pb_max = 1e-4;
fprintf('tiempo maximo:   %d (s)\n', tiempo_maximo);
fprintf('potencia maxima: %d\n',     potencia_maxima);
fprintf('Pb maxima:       %g\n',     Pb_max);
fprintf('.................\n');

%--- constelacion
constelacion = constelacion_4psk();
%constelacion = constelacion_8psk();
constelacion = constelacion_tcm_8psk();
M = size(constelacion,1);

%--- fb, fp, fm
    fp = 1935;
    beta = 0.10; 
    ntaps = 12;
    
    Rb = 9140;
    fs = Rb/log2(M);
    fm = fs*20;        % 100 muestras simbolo: fm > 2*(fm+fs)

%% --- transmision

%--- fuente
% numero de bits que podemos transmitir en el tiempo asignado 
% descontando el tiempo del transitorio del filtro conformador/adaptado
num_de_bits = floor( Rb*tiempo_maximo ) - 2*ntaps*log2(M); 
numero_de_bits = num_de_bits - mod(num_de_bits,log2(M)); % Para que funcione con 8psk (3 bits/simbolo)

%--- modulacion
bits    = fuente(numero_de_bits);

[Ik,Qk] = asignacion_simbolos(bits,constelacion);
ver_constelacion(constelacion)

[pulso,retardo] = rcos(fm,fs,beta,ntaps);
[I,Q]   = filtro_tx(Ik,Qk,fm,fs,pulso);
[xI,xQ] = modulador(I,Q,fm,fp);
x=xI+xQ;
%--- -> canal: potencia 1
x = x * sqrt((fm/fs));          %x = x/sqrt(mean(x.^2));

%% --- comprobacion: tiempo y potencia
verificar_x(x, fm, tiempo_maximo, potencia_maxima);

%% --- canal
r = canal1b(x,fm);
%plot(r);
%% --- recepcion
%bitsr = decodificar(r, fm);

%--- nivel de potencia Es = 1
r = r/sqrt((fm/fs));

%--- demodulador
[xI,xQ] = demodulador(r,fm,fp);
[I,Q]   = filtro_rx(xI,xQ,pulso);
[Ik,Qk] = muestreo(I,Q,fm,fs,retardo);
D       = distancias(Ik,Qk,constelacion);

bitsr   = decodificador_map(D);

plot_eye(I,Q,fm,fs,retardo,1000)

%% --- comprobacion: error
verificar_error(bits, bitsr, Pb_max);
%% --- tasa de bit
fprintf('\n.................\n');
fprintf('Bits enviados: %d\n', length(bits))
fprintf('Rb:            %.3f kbps\n', length(bits)/tiempo_maximo/1e3)