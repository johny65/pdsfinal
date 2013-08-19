%pitch = mipitch(s, tamvent)
%Calcula el pitch a lo largo del tiempo en la señal
%Parámetros:
%s: señal a analizar
%tamvent: tamaño de la ventana temporal
function pitch = mipitch(s, tamvent)
	
	%Método: transformada de la transformada

	% fm = 22050;
	[s, fm] = wavread(s);
	
	dt = 1/fm;
	N = length(s);
	nw = tamvent;
	vent = hanning(nw);
	k = 1;
	dk = floor(nw/2); %ventanas solapadas la mitad
	pitch = [];
	while k+nw < length(s)
	
		pedazo = s(k:k+nw-1).*vent;
		
		if energia(pedazo) < 3 %sonido sordo
			pitch = [pitch NaN]; %no lo analizo
			k += dk; continue;
		end
		
		%derivada de la señal:
		der = derivada(pedazo, fm);
		
		%FT^1 (transformada de Fourier de orden 1):
		fou = abs(fft(der))(1:floor(nw/2)); %sólo frecuencias positivas
		
		%transformada de la transformada
		fou2 = abs(fft(fou))(1:140); %frecuencias hasta 80 Hz
		
		%suavizado:
		cc = suavizado(fou2, 15).^3;
		
		%busco el pico:
		[pval, pind] = pico(cc);
		p = fm/2/pind;

		%descomentar para ir viendo análisis:
		%figure(11); stem(fou2); title "Transformada de la transformada"
		%figure(12);
		%stem(cc); hold on;
		%m=max(cc)*8/100; line([0 length(cc)], [m m]);
		%stem(pind, pval, 'r'); hold off; title "Suavizado"
		
		pitch = [pitch p];
		k += dk;
	end
	
	%figure; plot(pitch, 'ro'); title "FT(FT)"
	
endfunction	
