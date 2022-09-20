close all;
addpath('../../funciones_simulador')
addpath('../../funciones_tp6')
addpath('../../.')

tiempo_maximo   = 100;
potencia_maxima = 1;
Pb_max = 1e-3;

fprintf('tiempo maximo:   %d (s)\n', tiempo_maximo);
fprintf('potencia maxima: %d\n',     potencia_maxima);
fprintf('Pb maxima:       %g\n',     Pb_max);
fprintf('.................\n');



%% --- transmision
[x,fm,bits] = codificar_ej2_ofdm(tiempo_maximo);

%% --- comprobacion: tiempo y potencia
verificar_x(x, fm, tiempo_maximo, potencia_maxima);

%% --- canal
r = canal2a(x,fm);

%% --- recepcion
bitsr = decodificar_ej2_ofdm(r, fm);

%% --- comprobacion: error
verificar_error(bits, bitsr, Pb_max);

%% --- tasa de bit
fprintf('\n.................\n');

fprintf('Bits enviados: %d\n', length(bits))
fprintf('Rb:            %.3f kbps\n', length(bits)/tiempo_maximo/1e3)
