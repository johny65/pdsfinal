%Función "zoom":
%Acomoda la vista del gráfico para tener mejor visualización.
function zoom(f=0)
	if f == 0
		f = gcf;
	end
	figure(f)
	axis "auto"
	x = axis;
	axis([x(1:2) x(3)-250 x(4)+250]);	
endfunction
