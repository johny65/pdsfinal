%Entrenador de Canto
%-----------------------------------------------

%Autores:	Bertinetti, Juan
%			Gómez, Virginia

%Trabajo Final Procesamiento Digital de Señales
%2011
%FICH - UNL

%Dada una melodía o nota de prueba, analiza el canto del usuario
%según qué tan bien entonó la prueba, poniéndole un puntaje.
%
%Uso:
%canto(prueba, archivo)
%Parámetros:
%prueba: nombre de la prueba (debe ser un archivo de la carpeta
%"pruebas" sin la extensión)
%archivo: archivo grabado con el canto de la prueba
%Ejemplo:
%canto("octava4", "octava4cantada.wav")
function canto(prueba, archivo)

	%cargar frecuencias:
	load "freq.m" fq fqs
	
	%objetivo:
	tamvent = 2048; %aproximadamente 92 ms (para fm=22050 Hz)
	[pobjetivo, nn] = pitchobjetivo(strcat("pruebas/", prueba, ".wav"), tamvent);
	p = mipitch(archivo, tamvent);
	
	clc; disp "Tus notas a practicar: "; disp(nn)
	
	%analizar performance:
	canto = []; %nombres de las notas cantadas
	notas = 0; %cantidad de notas
	aciertos = 0; %notas bien cantadas
	ini = 1;
	ref = pobjetivo(1); %nota de referencia
	for i = 2:length(pobjetivo)
		if (pobjetivo(i) != ref) | (i == length(pobjetivo))
		
			%cambio de nota, analizar hasta acá
			
			%tomo la nota correspondiente en mi canto:
			if i-1 <= length(p)
				nota = p(ini:i-1);
			else
				nota = p(ini:length(p));
			end
			
			%limpiar un poco valores muy feos:
			mediana = median(nota);
			v = 50;
			for k = 1:length(nota)
				if abs(nota(k) - mediana) >= v %si el valor está muy lejos de la mediana
					nota(k) = NaN; %lo saco
				end
			end
			p(ini:ini+length(nota)-1) = nota;
			
			%encontrar mejor acierto:
			m = mode(nota); %me baso en la moda
			for j = 1:length(fq)-1
				if (m >= fq(j)) & (m < fq(j+1))
					if abs(m - fq(j)) < abs(m - fq(j+1))
						canto = [canto fqs(j,:)];
						cantov = fq(j);
					else
						canto = [canto fqs(j+1,:)];
						cantov = fq(j+1);
					end
				end
			end	
			notas++;
			if ref == cantov
				aciertos++;
			end
			ref = pobjetivo(i); %siguiente nota
			ini = i;
		end
	end
			
	disp "Tu canto: "; disp(canto)
	
	%puntaje:
	disp(strcat("Aciertos: ", num2str(aciertos), "/", num2str(notas)))
	puntaje = aciertos/notas*100;
	disp(strcat("Puntaje: ", num2str(puntaje)))
	if puntaje == 0
		disp "Horrible"
	elseif puntaje > 0 & puntaje <= 40
		disp "Muy mal"
	elseif puntaje > 40 & puntaje <= 80
		disp "Bien"
	elseif puntaje > 80 & puntaje < 100
		disp "Muy bien!"
	elseif puntaje == 100
		disp "Excelente!!"
	end
	
	%eje del tiempo:
	fm = 22050;
	dt = (1/fm) * (tamvent/2);
	t1 = 0:dt:dt*(length(pobjetivo)-1);
	t2 = 0:dt:dt*(length(p)-1);
	
	%mostrar resultados:
	figure(1)
	plot(t1, pobjetivo, 'bo')
	hold on
	plot(t2, p, 'ro')
	hold off
	title "Entrenador de Canto"
	legend("Objetivo", "Tu canto")
	ylabel "Frecuencia (Hz)"; xlabel "Tiempo (seg)";
	zoom; %mejorar la vista
	
endfunction
