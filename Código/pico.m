%[pval, pind] = pico(s)
%Encuentra el segundo pico en la transformada de la transformada
%Parámetros:
%s: transformada de la transformada suavizada
%Devuelve:
%pval: valor del pico
%pind: índice del pico
function [pval, pind] = pico(s)

	[m1, m2] = max(s);
	val = m1*8/100; %umbral
	cant = 0;
	flag = true;
	for i = 2:length(s)
		if flag & s(i) >= s(i-1)
			continue; %sigo buscando un máximo
		else
			%máximo local, ver si pasa
			if flag & s(i-1) >= val
				cant++;
				if cant == 2 %el segundo pico que necesito
					pval = s(i-1);
					pind = i-1;
					return;
				end
				flag = false;
			end
		end
		if ~flag & s(i) < s(i-1)
			continue; %sigo buscando un valle
		else
			flag = true; %volver a buscar un máximo
		end
	end
	
	%si no encontró un segundo pico:
	pval = m1;
	pind = m2;
	
endfunction
