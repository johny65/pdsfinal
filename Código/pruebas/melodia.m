%melodia:
%Función para generar la melodía de prueba (objetivo a cantar)
function melodia

	fm = 22050;
	[DO, DO_, RE, RE_, MI, FA, FA_, SOL, SOL_, LA, LA_, SI] = enum();
	
	o = 3;	
	dur = 1;
	%escala:
	%s = [cn(DO, o, dur) cn(RE, o, dur) cn(MI, o, dur)] cn(FA, o, dur) cn(SOL, o, dur) ...
		%cn(LA, o, dur) cn(SI, o, dur) cn(DO, o+1, dur)];
	s = cn(SI, 3, 3);
	
	%s = [cn(SOL, 2, dur)];
	wavwrite(s', fm, "si3.wav");
	
endfunction

%Tono puro correspondiente a nota, en tal octava y de tal duración
function x = cn(nota, octava, dur, fm = 22050)	
	frec = 440 * exp(((octava-4)+(nota-10)/12)*log(2));
	dt = 1/fm;
	t = 0:dt:dur-dt;
	x = sin(2*pi*frec*t);
endfunction

%emulación de enum{} de C++
function [varargout] = enum(first_index = 1)
	for k = 1:nargout
		varargout {k} = k + first_index - 1;
	end
endfunction
