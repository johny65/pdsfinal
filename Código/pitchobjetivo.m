%[pitch, notas] = pitchobjetivo(s, long)
%Analiza la señal objetivo y determina la nota objetivo
%a lo largo del tiempo.
%Parámetros:
%s: señal objetivo (tonos puros)
%long: tamaño de la ventana temporal
%Devuelve:
%pitch: notas objetivos (frecuencia)
%notas: notas objetivos (nombre)
function [pitch, notas] = pitchobjetivo(s, long)

	%Método:
	%Para encontrar la frecuencia correspondiente, al ser tonos
	%puros sólo busco el pico en Fourier
	
	%cargo las notas
	load "freq.m" fq fqs

	% fm = 22050;
	[s, fm] = wavread(s);
	
	dt = 1/fm;
	N = length(s);
	nw = long;
	vent = hanning(nw);
	dk = floor(nw/2); %ventanas solapadas la mitad
	df = fm/nw;
	f = 0:df:df*nw/2-df;
	pitch = [];
	notas = [];
	k = 1;
	while k+nw < length(s)
		pedazo = s(k:k+nw-1);
		pedazo .*= vent;
		ft = abs(fft(pedazo))(1:floor(nw/2)); %frecuencias positivas
		[p, ind] = max(ft);
		p = f(ind); %valor en frecuencia
		%encontrar nota exacta:
		for i = 1:length(fq)-1
			if (p >= fq(i)) & (p < fq(i+1))
				if abs(p - fq(i)) < abs(p - fq(i+1))
					mejor = i;
				else
					mejor = i+1;
				end
				p = fq(mejor);
			end
		end
		%acomodar saltos:
		if length(pitch) > 2
			if p != pitch(length(pitch))
				if pitch(length(pitch)) != pitch(length(pitch)-1)
					pitch(length(pitch)) = pitch(length(pitch)-1);
				end
			end
		end
		%encontrar nombres de las notas:
		if length(pitch) == 0
			notas = [notas fqs(mejor,:)];
		elseif p != pitch(length(pitch)) %agrego una nota sólo cuando hubo un cambio
			notas = [notas fqs(mejor,:)];
		end
		%agregar pitch
		pitch = [pitch p];
		k += dk;
	end
	
	%plot(pitch, 'ro')
	
endfunction	
