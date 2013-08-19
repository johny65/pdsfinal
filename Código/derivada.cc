#include <octave/oct.h>
#include <string>

std::string ayuda = "\
y = derivada(s, fm)\n \
Calcula la derivada de la señal s para usar con la \
transformada de Fourier de 1º orden.\n \
Parámetros:\n \
s: señal\n \
fm: frecuencia de muestreo\n \
Devuelve:\n \
y: derivada calculada usando aproximación hacia atrás.\n \
Esto es: y[i] = fm*s[i] - fm*s[i-1]\n";

DEFUN_DLD(derivada, args, nargout, ayuda)
{
	//args: s, fm
	int nargin = args.length();
	if (nargin != 2){
		octave_stdout<<"Error. Ver ayuda.\n";
		return octave_value_list();
	}
	
	const int fm = args(1).int_value();
	RowVector s = args(0).row_vector_value();
	RowVector der(s.length());
	der.fill(0.0);

	der(0) = fm*s(0);
	for (octave_idx_type i=1; i < s.length(); ++i)
		der(i) = fm*s(i) - fm*s(i-1);

	return octave_value(der);
}
