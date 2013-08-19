#include <octave/oct.h>
#include <string>

//Función de suavizado
//Basado en el código fastsmooth.m de T. C. O'Haver (ver al final)

std::string ayuda = "\
s = suavizado(Y, w)\n \
Suavizado triangular de la señal Y usando un ancho de \
suavizado de w muestras.\n \
Parámetros:\n \
Y: señal\n \
w: ancho de suavizado\n \
Devuelve:\n \
s: señal suavizada.\n";

DEFUN_DLD(suavizado, args, nargout, ayuda)
{
	//args: Y, w
	int nargin = args.length();
	if (nargin != 2){
		octave_stdout<<"Error. Ver uso.\n";
		return octave_value_list();
	}
	
	const int w = args(1).int_value();
	RowVector Y = args(0).row_vector_value();
	
	double SumPoints = 0;
	for (octave_idx_type i=0; i < w; ++i)
		SumPoints += Y(i);
	
	RowVector s(Y.length());
	s.fill(0.0);
	double halfw = round(w/2);
	for (octave_idx_type k=0; k <= Y.length()-w-1; ++k){
		s(k+halfw) = SumPoints;
		SumPoints = SumPoints - Y(k);
		SumPoints = SumPoints + Y(k+w);
	}
	for (octave_idx_type k=0; k < s.length(); ++k)
		s(k) /= w;
	
	//segunda pasada:
	SumPoints = 0;
	for (octave_idx_type i=0; i < w; ++i)
		SumPoints += s(i);
	
	RowVector SmoothY(s.length());
	SmoothY.fill(0.0);
	for (octave_idx_type k=0; k <= s.length()-w-1; ++k){
		SmoothY(k+halfw) = SumPoints;
		SumPoints = SumPoints - s(k);
		SumPoints = SumPoints + s(k+w);
	}
	for (octave_idx_type k=0; k < SmoothY.length(); ++k)
		SmoothY(k) /= w;
	
	return octave_value(SmoothY);
	
}

//archivo fastsmooth.m:

//function SmoothY=fastsmooth(Y,smoothwidth)
//%  fastsmooth(Y,w) smooths vector Y by triangular
//% smooth of width = smoothwidth. Works well with signals up to 
//% 100,000 points in length and smooth widths up to 1000 points. 
//% Faster than tsmooth for smooth widths above 600 points.
//% Example: fastsmooth([0 0 0 0 9 0 0 0 0],3) yields [0 0 1 2 3 2 1 0 0]
//%  T. C. O'Haver, 2006.
//w=round(smoothwidth);
//SumPoints=sum(Y(1:w));
//s=zeros(size(Y));
//halfw=round(w/2);
//for k=1:length(Y)-w,
   //s(k+halfw-1)=SumPoints;
   //SumPoints=SumPoints-Y(k);
   //SumPoints=SumPoints+Y(k+w);
//end
//s=s./w;
//SumPoints=sum(s(1:w));
//SmoothY=zeros(size(s));
//for k=1:length(s)-w,
   //SmoothY(k+halfw-1)=SumPoints;
   //SumPoints=SumPoints-s(k);
   //SumPoints=SumPoints+s(k+w);
//end
//SmoothY=SmoothY./w;
