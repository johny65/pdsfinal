%e = energia(s)
%Calcula la energía de la señal s
function e = energia(s)
	e = sum(s.^2);
endfunction
