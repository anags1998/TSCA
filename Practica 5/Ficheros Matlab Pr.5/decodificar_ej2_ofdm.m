function bitsr = decodificar_ofdm(r, fm)

%--- OFDM 
n_bandas = 32;

%---constelaciones por banda
M_estimado = [8 64 64 64 64 64 64 64 64 64 64 64 64 64 64 16 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4]; 
%M_estimado = [4 4]; 
M_banda    = kron(M_estimado, ones(1, n_bandas/length(M_estimado)));
bits_simb_banda  = log2(M_banda);
bits_simb_total  = sum(log2(M_banda));

%--- Parámetros fb, fp, fm, ntaps, muestras por símbolo
    f0 = 940; 
    f1 = 9130;
    fp = (f0+f1)/2;
    ntaps = 12;
    BW = f1 - f0;                    % BW = n_bandas / Ts
    fs = floor( BW / n_bandas);
    beta=0.1;
     
    factor_n_t=12;
    %fm = fs*n_bandas*factor_n_t     % muestras simbolo: fm > 2*(fp+fs)
    
%--- nivel de potencia Es = 1
r=r/sqrt((fm/fs));

%--- demodulador
[xI,xQ] = demodulador(r,fm,fp);

%------- Filtrado
pulso = rcosdesign(beta,2*ntaps,factor_n_t); %puede ser otro filtro
retardo = ntaps*2*factor_n_t +1;
%[pulso,retardo]=psinc(fm/fs/n_bandas, ntaps);
n_t=factor_n_t
jj = linspace( -ntaps,ntaps,2*ntaps*n_t +1 );
%jj = linspace( -ntaps,ntaps,2*ntaps*n_t +1 );
figure;plot(jj,pulso);hold on;stem(jj,pulso);grid on

pulso = pulso/sqrt(sum(pulso.^2)); %normalizar
disp('retardo =')
disp(retardo)

[I,Q]   = filtro_rx(xI,xQ,pulso);

%-------diezmado
fmnobd=fs*n_bandas;
disp('fmnobd =')
disp(fmnobd)
[Ik,Qk] = muestreo(I,Q,fm,fs*n_bandas,retardo);
%------- De serie a paralelo
XIk_ = reshape(Ik, n_bandas, length(Ik)/n_bandas);
XQk_ = reshape(Qk, n_bandas, length(Qk)/n_bandas);

%------ FFT: Obtiene los simbolos de cada banda
X = fft( XIk_ + j * XQk_ ,[],1);
Ik_ = real(X);
Qk_ = imag(X);

%%Dibuja los símbolos recibidos por bandas
figure; N = ceil( sqrt(n_bandas) );
for b=1:n_bandas
subplot(N,N,b); plot_const(Ik_(b,:),Qk_(b,:),fm,fs,retardo,1000) ; title(num2str(b))
end;

%%Decodififca los simbolos recibidos
Bitsr=decodifica_simbolos(Ik_,Qk_,M_banda);
bitsr = Bitsr(:)';

