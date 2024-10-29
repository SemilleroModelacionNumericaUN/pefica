% tabla grados de libertad por elemento o matriz de incidencias
function [INC] = NGLELE(ELE,MGL)
  % entrada:  ELE(): tabla de categorias y conectividades de los elementos
  %           MGL(): tabla de GL por nudo
  % salida:   INC(): tabla de GL por elemento o matriz de incidencias
  
  [NELE,NNUE] = size(ELE);  % número de elementos y de nudos por elemento +1
  NNUE = NNUE-1; % número de nudos por elemento
  [NNUD,NGLN] = size(MGL);  % número de nudos y de GL por nudo
  
  NGLE = NGLN*NNUE; % número de GL por elemento
  INC = zeros(NELE,NGLE,'int64'); % definición de tamaño y tipo de matriz INC()

  for IINC = 1:NELE
    for JINC = 1:NNUE
      for HINC = 1:NGLN
        SINC = (JINC-1)*NGLN + HINC;
        if ELE(IINC, JINC+1) == 0
          INC(IINC, SINC) = 0;
        else
          INC(IINC, SINC) = MGL(ELE(IINC, JINC+1), HINC);
        end % endif
      end % endfor HINC
    end % endfor JINC
  end % endfor IINC
  
end