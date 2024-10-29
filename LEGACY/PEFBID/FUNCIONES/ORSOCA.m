% tabla de promedio de cada componente sobre los nudos
% a partir de la misma cantidad obtenida en los extremos de los elementos
% cuando existen varias categorías.
function [NUD,NUCA] = ORSOCA(ELE,REL,NNUD,NCOM,ICAT)
  % entrada:  ELE(): tabla de categorias y conectividades de los elementos
  %           REL(): tabla con la cantidad espec. en los extrem de cada elemento 
  %           NNUD:  número de nudos
  %           NCOM:  número de componentes de resultados 
  %           ICAT:  id de la categoría de elementos que será presentada
  % salida:   NUD(): tabla de resultados promedio de cantidad en los nudos
  %           NUCA:  número de nudos de la categoría ICAT
  
  [NELE,NNUE] = size(ELE);  % número de elementos y de nudos por elemento +1
  NNUE = NNUE-1; % número de nudos por elemento
  
  % definición de tamaño y tipo de matriz
  NUD = zeros('double'); 
  RNU = zeros(NNUD,NCOM,'double'); % tabla de cantidad espec. promedio en los nudos
  NUCA=0; % número de nudos de la categoría ICAT
  
  % sumatoria y número de elementos por nudo
  for ICOM=1:NCOM
    NEN = zeros(NNUD,1,'double'); % tabla de número de elementos asociados a nudo
    for IELE=1:NELE
      if ELE(IELE,1)==ICAT
        for INUE=2:NNUE+1
          if ELE(IELE, INUE) ~= 0
            IRES=(IELE-1)*NNUE+(INUE-1);
            RNU(ELE(IELE,INUE),ICOM) = RNU(ELE(IELE,INUE),ICOM) + ...
                                       REL(IRES,ICOM+2);
            NEN(ELE(IELE,INUE)) = NEN(ELE(IELE,INUE)) + 1;
          end % endif ELE(IELE, INUE) ~= 0
        end % endfor INUE
      end % endif ELE(IELE,1)==ICAT
    end % endfor IELE
    % promedio
    INUR=0;
    for INUD=1:NNUD
      if NEN(INUD)~=0
        RNU(INUD,ICOM) = RNU(INUD,ICOM) / NEN(INUD);
        INUR=INUR+1;
        NUD(INUR,1)=double(INUD);
        NUD(INUR,ICOM+1)=RNU(INUD,ICOM);
      end % endif
    end % endfor INUD
  end % endfor ICOM
  NUCA=INUR; % nodos de la categoría ICAT
  
end