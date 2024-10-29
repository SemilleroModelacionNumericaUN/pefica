% Matriz B de un elemento finito
function [MTX] = BELEME(XYE,XIPN,TIPE)
  % Entrada:
  % XYE():  tabla de coordenadas globales de los nudos del elemento.
  % XIPN:   coordenada natural 0<\xi<1 del punto donde se evalúa B
  % TIPE:   código del tipo del elemento
  %       
  % Salida:
  % MTX():  matriz B del elemento

  switch TIPE
    case 101 % elemento de fuerza axial unidimensional lineal de continuidad c0
      [MTX] = BAXIAL(XYE);
    case 102 % elemento de fuerza axial undimensional cuadrático de cont c0
      [MTX] = BAXIAC(XYE,XIPN);
    case 111 % elemento de flexión undimensional cúbico de continuidad c1
      [MTX] = BBEAME(XYE,XIPN);
    otherwise
      error(['BELEME. El identificador %g no corresponde a un tipo de ' ...
            'elemento finito de la libreria'],TIPE);
  end
 
end

% ------------------------------------------------------------------------
% matriz B de un elemento de fuerza axial unidimensional lineal de cont c0
function [MTX] = BAXIAL(XYE)
  % entrada: XYE():  coordenadas de los nudos del elemento
  % salida:  MTX():  matriz B del elemento finito
  LELE = abs(XYE(2,1)-XYE(1,1)); % longitud del elemento
  MTX = (1/LELE)*[ -1 1 ];
end

% ------------------------------------------------------------------------
% matriz B de un elemento de fuerza axial unidimensional cuadrático de cont c0
function [MTX] = BAXIAC(XYE,XIPN)
  % entrada: XYE():  coordenadas de los nudos del elemento, considerando
  %                  los extremos como los dos primeros nudos del elemento
  %          XIPN:   coordenada natural 0<\xi<1 del punto donde se evalúa B
  % salida:  MTX():  matriz B del elemento finito
  LELE = abs(XYE(2,1)-XYE(1,1)); % longitud del elemento
  MTX = (1/LELE)*[ (-3+4*XIPN) (-1+4*XIPN) (4-8*XIPN) ];
end

% ------------------------------------------------------------------------
% matriz B de un elemento unidimensional viga de continuidad c1
function [MTX] = BBEAME(XYE,XIPN)
  % entrada: XYE():  coordenadas de los nudos del elemento
  %          XIPN:   coordenada natural 0<\xi<1 del punto donde se evalúa B
  % salida:  MTX():  matriz B del elemento finito
  LELE = abs(XYE(2,1)-XYE(1,1)); % longitud del elemento
  MTX = [ (-6+12*XIPN)/LELE^2 (-4+6*XIPN)/LELE ...
          (6-12*XIPN)/LELE^2 (-2+6*XIPN)/LELE ];
end
