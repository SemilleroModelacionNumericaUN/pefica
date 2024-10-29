% crea un vector de fuerzas o desplazamientos nodales de la estructura 
% ordenado por GLs a partir de la tabla de fuerzas o desplazamientos ordenada 
% de la forma FX,FY o UX, UY por nudo.
function  [VEC] = ORTAVE(TAB,MGL)
  % entrada:  TAB:  tabla de fuerzas o desplazamientos donde cada fila contiene
  %                 la magnitud de las fuerzas o desplazamientos
  %                 FX, FY o UX, UY de un nudo.
  %           MGL:  matriz de GLs por nudo
  %
  % salida:   VEC:  vector creado de fuerzas o desplazamientos nodales 
  %                 ordenado por GL.                 

  [FTAB,CTAB] = size(TAB);  % dimensión de la tabla de fuerzas/despla ord FX,FY
  [NNUD,NGLN] = size(MGL);  % número de nudos y de GLs por nudo tomado de MGL()
  
  if (FTAB ~= NNUD) || (CTAB ~= NGLN)
    error('Error. ORTAVE: tamano incorrecto de la tabla TAB');
  end % endif
  
  VEC = zeros(NGLN*NNUD,1); % definición de tamaño del vector  
  for IMGL=1:NNUD
    for JMGL=1:NGLN
      if MGL(IMGL,JMGL) ~= 0
        VEC(MGL(IMGL,JMGL), 1) = TAB(IMGL,JMGL);
      end % endif
    end % endfor
  end % endfor

end