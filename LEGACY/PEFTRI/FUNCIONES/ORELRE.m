% crea tabla eliminando repeticiones en la primera columna de una
% tabla original
function [TBS] = ORELRE(TBI)
% entrada:  TBI: tabla original
% salida:   TBS: tabla obtenida en la cual se han eliminado las filas donde
%                el término de la primera columna está repetido
  [FTBI,CTBI] = size(TBI)
  
  FLAG = 0;
  for ITBI=1:FTBI
    for JTBI=1:FTBI
      if JTBI~=ITBI
        if TBI(ITBI,1)==TBI(JTBI,1)
          FLAG = FLAG + 1; % número de repeticiones del primer término de fila
        end % endif
      end % endif
    end % endfor
    if FLAG==0;
      TBS(ITBI,:) = TBI(ITBI,:);
    end % endif
  end % endfor

end  
          
          
          
        
    

      
    




end