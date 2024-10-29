%  crea una tabla de fuerzas o desplazamientos en los nudos del sólido ordenada
%  de la forma FX,FY,FZ o UX, UY, UZ a partir del vector de fuerzas o desplazamientos
%  nodales.
function [TAB] = ORVETA(VEC,MGL)
% entrada:  VEC:  vector existente de fuerzas o desplazamientos nodales 
%                 ordenado por GL.
%           MGL:  matriz de GLs por nudo
%
% salida:   TAB:  tabla creada de fuerzas o desplazamientos donde cada fila 
%                 contiene la magnitud de las fuerzas o desplazamientos
%                 FX, FY, FZ o UX, UY, UZ de un nudo.
  
  [NNUD,NGLN] = size(MGL);  % número de nudos y de GLs por nudo tomado de MGL()
  TAB = zeros(NNUD,NGLN); % definición de tamaño de la tabla

  for INUD = 1:NNUD
    for JGLN = 1:NGLN
      if MGL(INUD, JGLN) ~= 0
        TAB(INUD, JGLN) = VEC(MGL(INUD, JGLN), 1);
      end % endif
    end % endfor
  end % endfor

end
