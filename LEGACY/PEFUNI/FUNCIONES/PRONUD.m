% construcción de una tabla de resultados promedio en cada nudo a partir de la 
% tabla de resultados de los elementos.
function [PRO] = PRONUD(NNUD,ELE,REL)
  % entrada:  NNUD:   número de nudos de la malla de EF
  %           ELE():  tabla de nudos asociados a cada elemento
  %           REL():  tabla de un resultado de los elementos
  %           
  % salida:   PRO():  tabla de los resultados promedio por nudo. El número
  %                   de la fila indica el número del nudo.

  [NELE,NNUE] = size(ELE);
  [NELE,NREL] = size(REL);
  NNUE = NNUE-1; % número de nudos por elemento
  NPRO = NREL/NNUE; % número de resultados contenidos en REL() que serán promedi
  PRO = zeros(NNUD,NPRO);
  
  for IPRO=1:NPRO

    CON = zeros(NNUD,1);
    % calcular sumatoria y número de repeticiones
    for IELE=1:NELE
      for INUE=1:NNUE
        INUD = ELE(IELE,INUE+1);
        PPRO = (2*(IPRO-1)+INUE);
        PRO(INUD,IPRO) = PRO(INUD,IPRO) + REL(IELE,PPRO); % sumatoria del valor
        CON(INUD,1) = CON(INUD,1) + 1; % contador
      end % endfor INUE
    end % endfor IELE
    
    % calcular promedio
    for INUD=1:NNUD
      PRO(INUD,IPRO) = PRO(INUD,IPRO)/CON(INUD,1);
    end % endfor INUD
  
  end % endfor IPRO
  
end  
  