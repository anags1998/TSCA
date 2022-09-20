function [x,fm,bits] = codificar_ofdm(tiempo_maximo)

%--- OFDM 
n_bandas = 32;

%---constelaciones por banda
M_estimado = [8 64 64 64 64 64 64 64 64 64 64 64 64 64 64 16 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4];  % proportional to n_bandas in size 
M_banda    = kron(M_estimado, ones(1, n_bandas/length(M_estimado)));
bits_simb_banda  = log2(M_banda);
bits_simb_total  = sum(log2(M_banda));

%--- Parámetros fb, fp, fm, ntaps, muestras por símbolo
    f0 = 940; %830   
    f1 = 9130;%9179
    fp = (f0+f1)/2;
    ntaps = 12;
    beta=0.1;
    BW = f1 - f0;                    % BW = n_bandas / Ts
    fs = floor( BW/ n_bandas); 

    factor_n_t = 12;
    fm = fs*n_bandas*factor_n_t     % muestras simbolo: fm > 2*(fp+fs)

%--- fuente de bits
numero_de_bits = floor( tiempo_maximo * fs ) * bits_simb_total;
bits    = fuente(numero_de_bits);

%--- modulacion. Paso de bits a símbolos
[Ik_,Qk_] = asignacion_simbolosbandas(n_bandas,M_banda,bits);

%---------Paso de paralelo a serie
Ik_ = cell2mat(Ik_);
Qk_ = cell2mat(Qk_);

%---------IFFT : OFDM 
X = ifft( Ik_ + j * Qk_ ,[],1);
Ik = real(X(:))';
Qk = imag(X(:))';

%--------Filtrado
pulso = rcosdesign(beta,2*ntaps,factor_n_t); %puede ser otro filtro
retardo = ntaps*2*factor_n_t +1;
%[pulso,retardo]=psinc(fm/fs/n_bandas, ntaps);
n_t=factor_n_t
jj = linspace( -ntaps,ntaps,2*ntaps*n_t +1 );
%jj = linspace( -ntaps,ntaps,2*ntaps*n_t +1 );
figure;plot(jj,pulso);hold on;stem(jj,pulso);grid on

pulso = pulso/sqrt(sum(pulso.^2)); %normalizar

[I,Q]  = filtro_tx(Ik,Qk,fm,fs*n_bandas,pulso);

%------- Modulador 
x  = modulador(I,Q,fm,fp);

%--- -> canal: potencia 1
x = x * sqrt((fm/fs));%x = x/sqrt(mean(x.^2));

