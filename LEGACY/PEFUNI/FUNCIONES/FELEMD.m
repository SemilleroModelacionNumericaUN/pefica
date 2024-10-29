% Vector de fuerzas distribuidas del elemento finito unidimensional
function [FEL] = FELEMD(XYE,CAE,WELE)
  % Entrada:  XYE():  coordenadas de los nudos del elemento
  %           CAE():  propiedades del catergoría del elemento
  %           WELE:   carga distribuida
  %
  % Salida:   FEL():  vector de fuerzas distribuida del elemento  

  TIPE = CAE(3);  % código del tipo de elemento
  LELE = abs(XYE(2,1)-XYE(1,1)); % longitud del elemento medida entre nudos I y J
  
  switch TIPE
    case 101 % elemento de fuerza axial unimensional lineal de cont c0
      [FEL] = FAXIAL(LELE,WELE);
    case 102 % elemento de fuerza axial unidimensional cuadrático de cont c0
      [FEL] = FAXIAC(LELE,WELE);
    case 111 % elemento de flexión unidimensional cúbico de cont c1
      [FEL] = FBEAME(LELE,WELE);
    otherwise
      error(['FELEMD. El identificador %g no corresponde a un tipo de ' ...
            'elemento finito de la libreria'],TIPE);
    end
 
end


% ------------------------------------------------------------------------
% Vector de fuerzas equivalentes a una carga distribuida uniforme en un 
% elemento de fuerza axial unidimensional lineal de continuidad c0
function [FEL] = FAXIAL(LELE,WELE)
  % Entrada:  LELE:   longitud del elemento
  %           WELE:   carga distribuida
  % Salida:   FEL():  vector de fuerzas distribuida del elemento  
  FEL = (WELE*LELE/2)*[1 ; 1];
end

% ------------------------------------------------------------------------
% Vector de fuerzas equivalentes a una carga distribuida uniforme en un 
% elemento de fuerza axial unidimensional cuadrático de continuidad c0
function [FEL] = FAXIAC(LELE,WELE)
  % Entrada:  LELE:   longitud del elemento
  %           WELE:   carga distribuida
  % Salida:   FEL():  vector de fuerzas distribuida del elemento  
  FEL = (WELE*LELE/6)*[1 ; 1 ; 4];
end

% ------------------------------------------------------------------------
% Vector de fuerzas equivalentes a una carga distribuida uniforme del elemento 
% para flexión unidimensional cúbico de continuidad c1
function [FEL] = FBEAME(LELE,WELE)
  % Entrada:  LELE:   longitud del elemento
  %           WELE:   carga distribuida uniforme
  % Salida:   FEL():  vector de fuerzas distribuida del elemento  
  FEL = (WELE*LELE/12)*[6 ; LELE ; 6 ; -LELE];
end
