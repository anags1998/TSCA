%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parámetros de entrada: 
 % xn secuencia de señal de entrada (vector de columna)
 % dn secuencia de respuesta esperada (vector de columna)
 %Orden de filtro% M (escalar)
 %El factor de convergencia% mu (tamaño de paso) (escalar) requiere el recíproco del valor propio más grande de la matriz de correlación mayor que 0 y menor que xn    
 % Parámetros de salida:
 % W matriz de peso del filtro (matriz)
 % El tamaño es M x itr,
 % en secuencia de error (itr x 1) (vector de columna)  
 % yn secuencia de salida real (vector de columna)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [yn,W,en]=LMS1(xn,dn,M,mu)
 itr = length(xn);
 en = zeros (itr, 1);% secuencia de error, en (k) representa el error entre la salida esperada y la entrada real en la iteración k
 W = zeros (M, itr);% Cada fila representa un parámetro ponderado, cada columna representa iteraciones, la inicial es 0
 % Cálculo iterativo
 for k = M: itr% iteración k
         x = xn (k: -1: k-M + 1);% filtro M entrada de tap
         y = W (:, k-1)'.* x; % de salida del filtro
         en (k) = dn (k) - y(k); % de error de la iteración k
         W (:, k) = W (:, k-1) + 2 * mu.* en(k).* x';% Fórmula iterativa para el cálculo del peso del filtro
end
 % La secuencia de salida del filtro cuando se busca el valor óptimo de R. Si no hay parámetro de retorno yn, lo siguiente
 yn = inf*ones(length (xn));% inf significa infinito
for k = M:length(xn)
    x = xn(k:-1:k-M+1);
         yn (k) = W (:, end).'* x;% utiliza la mejor estimación finalmente obtenida para obtener la salida
end

