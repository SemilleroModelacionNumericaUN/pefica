% Matriz de funciones de forma N de un elemento finito
function [MTX] = NELEME(XYE,XIPN,TIPE)
  % Entrada:
  % XYE():  coordenadas de los nudos del elemento
  % XIPN:  coordenadas del punto donde se evalúa N dentro del elemento.
  % TIPE:   código del tipo del elemento
  %       
  % Salida:
  % MTX():  matriz N del elemento

  switch TIPE
    case 101 % elemento de fuerza axial unidimensional lineal de continuidad c0
      [MTX] = NAXIAL(XIPN);
    case 102 % elemento de fuerza axial unidimensional cuadrático de continuidad c0
      [MTX] = NAXIAC(XIPN);
    case 111 % elemento de flexión unidimensional cúbico de continuidad c1
      [MTX] = NBEAME(XYE,XIPN);
    otherwise
      error(['NELEME. El identificador %g no corresponde a un tipo de ' ...
            'elemento finito de la libreria'],TIPE);
    end
 
end

% ------------------------------------------------------------------------
% matriz N de un elemento de fuerza axial unidimensional lineal de cont c0
function [MTX] = NAXIAL(XYPN)
  % entrada:
  % XYPN:   coordenadas naturales 0<xi<1 del punto donde se evaúla 
  %         N dentro del elem.
  % salida:
  % MTX():  matriz N del elemento finito
  MTX = [(1 - XYPN) XYPN];
end

% ------------------------------------------------------------------------
% matriz N de un elemento de fuerza axial unidimensional cuadrático de cont c0
function [MTX] = NAXIAC(XIPN)
  % entrada:
  % XIPN:   coordenadas naturales 0<xi<1 del punto donde se evaúla N dentro del elem.
  %
  % salida:
  % MTX():  matriz N del elemento finito
  MTX = [(1-3*XIPN+2*XIPN^2) (-XIPN+2*XIPN^2) (4*XIPN-4*XIPN^2)];
end

% ------------------------------------------------------------------------
% matriz N de un elemento de flexión unidimensional cúbico de continuidad c1
function [MTX] = NBEAME(XYE,XIPN)
  % entrada:
  % XYE():  coordenadas de los nudos del elemento
  % XIPN:   coordenadas naturales 0<xi<1 del punto donde se evaúla 
  %         N dentro del elem.
  % salida:
  % MTX():  matriz N del elemento finito
  
  LELE = abs(XYE(2,1)-XYE(1,1));
  MTX = [(1-3*XIPN^2+2*XIPN^3) (XIPN-2*XIPN^2+XIPN^3)*LELE ...
         (3*XIPN^2-2*XIPN^3) (-XIPN^2+XIPN^3)*LELE ];
end