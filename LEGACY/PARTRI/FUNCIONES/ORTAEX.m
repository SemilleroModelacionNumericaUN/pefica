% construcción de una tabla extendida a todos los nudos a partir de
% una tabla de características de algunos nudos.
function [TEX] = ORTAEX(TAL,NNUD)
  % entrada:  TAL():  tabla de características de algunos nudos
  %           NNUD:   número de nudos de la malla de EF
  % salida:   TEX():  tabla extendida a todos los nudos

  [FTAL,CTAL] = size(TAL);  % número de filas y columnas de TAL()
  TEX = zeros(NNUD,CTAL-1);   % definición del tamaño de TEX()
  
  if TAL(1,1)~=0 % control cuando la matriz TAL() llena de ceros
    for ITAL=1:FTAL
      INUD = TAL(ITAL,1); % la primera colum de TAL() indica el número del nudo
      if INUD > NNUD
        error('Error. PBTAEX: número del nudo superior al máximo');
      end % endif
      for JTAL=2:CTAL
        TEX(INUD,JTAL-1) = TAL(ITAL,JTAL);
      end % endfor JTAL
    end % endfor ITAL
  end % endif TAL(1,1)~=0
    
end  
  