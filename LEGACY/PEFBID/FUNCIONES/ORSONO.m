% tabla de promedio de cada componente sobre los nudos
% a partir de la misma cantidad obtenida en los extremos de los elementos
% funciona para mallas con elementos con el mismo número de nudos.
function [RNU] = ORSONO(ELE,REL,NNUD,NCOM)
  % entrada:  ELE(): tabla de categorias y conectividades de los elementos
  %           REL(): tabla con la cantidad espec. en los extrem de cada elemento 
  %           NNUD:  número de nudos
  %           NCOM:  número de componentes de resultados 
  % salida:   RNU(): tabla de resultados promedio de cantidad en los nudos
  
  [NELE,NNUE] = size(ELE);  % número de elementos y de nudos por elemento +1
  NNUE = NNUE-1; % número de nudos por elemento
  
  % definición de tamaño y tipo de matriz
  RNU = zeros(NNUD,NCOM,'double'); % tabla de cantidad espec. promedio en los nudos
  
  % sumatoria y número de elementos por nudo
  for ICOM=1:NCOM
    NEN = zeros(NNUD,1,'double'); % tabla de número de elementos asociados a nudo
    for IELE=1:NELE
      for INUE=2:NNUE+1
        if ELE(IELE, INUE) ~= 0
          IRES=(IELE-1)*NNUE+(INUE-1);
          RNU(ELE(IELE,INUE),ICOM) = RNU(ELE(IELE,INUE),ICOM) + ...
                                     REL(IRES,ICOM+2);
          NEN(ELE(IELE,INUE)) = NEN(ELE(IELE,INUE)) + 1;
        end % endif
      end % endfor JELE
    end % endfor IELE
    % promedio
    for INUD=1:NNUD
      RNU(INUD,ICOM) = RNU(INUD,ICOM) / NEN(INUD);
    end % endfor INUD
  end % endfor ICOM
 
  
end