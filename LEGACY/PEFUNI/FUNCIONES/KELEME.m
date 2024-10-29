% Matriz de rigidez de un elemento finito
function [MTX] = KELEME(XYE,CAE)
  % Entrada:
  % TIPR:   código del tipo de problema
  % XYE():  coordenadas de los nudos del elemento
  % CAE():  propiedades de la categoría del elemento
  %       
  % Salida:
  % MTX():  matriz de rigidez del elemento

  TIPE = CAE(3); % código del tipo de elemento

  switch TIPE
    case 101 % elemento de fuerza axial unidimensional lineal de continuidad c0
      [MTX] = KAXIAL(XYE,CAE);
    case 102 % elemento de fuerza axial unidimensional cuadrático de continuidad c0
      [MTX] = KAXIAC(XYE,CAE);
    case 111 % elemento de flexión unidimensional cúbico de continuidad c1
      [MTX] = KBEAME(XYE,CAE);
    otherwise
      error(['KELEME. El identificador %g no corresponde a un tipo de ' ...
            'elemento finito de la libreria'],TIPE);
    end
 
end

% ------------------------------------------------------------------------
% Matriz de rigidez del elemento unidimensional lineal
function [MTX] = KAXIAL(XYE,CAE)
  % Entrada:
  % XYE():  coordenadas de los nudos del elemento 
  % CAE():  propiedades de la categoría del elemento
  %       
  % Salida:
  % MTX():  matriz de rigidez del elemento
  
  EYOU = CAE(1);              % módulo de elasticidad del elemento
  AREA = CAE(2);              % área de la sección transversal del elemento
  LONE = XYE(2,1) - XYE(1,1); % longitud y matriz de transformación del elem
  
  % matriz de rigidez
  MTX = (EYOU*AREA/LONE)*[ 1  -1 ;
                          -1   1 ];
  
end

% ------------------------------------------------------------------------
% Matriz de rigidez del elemento unidimensional cuadrático
function [MTX] = KAXIAC(XYE,CAE)
  % Entrada:
  % XYE():  coordenadas de los nudos del elemento, considerando los extremos
  %         como los dos primeros nudos del elemento
  % CAE():  propiedades de la categoría del elemento
  %       
  % Salida:
  % MTX():  matriz de rigidez del elemento
  
  EYOU = CAE(1);              % módulo de elasticidad del elemento
  AREA = CAE(2);              % área de la sección transversal del elemento
  LONE = XYE(2,1) - XYE(1,1); % longitud y matriz de transformación del elem
  
  % matriz de rigidez
  MTX = (EYOU*AREA/(3*LONE))*[ 7  1 -8 ;
                               1  7 -8 ;
                              -8 -8 16 ];
  
end

% ------------------------------------------------------------------------
% Matriz de rigidez del elemento unidimensional viga de continuidad c1
function [MTX] = KBEAME(XYE,CAE)
  % Entrada:
  % XYE():  coordenadas de los nudos del elemento 
  % CAE():  propiedades de la categoría del elemento
  %       
  % Salida:
  % MTX():  matriz de rigidez del elemento
  
  EYOU = CAE(1);              % módulo de elasticidad del elemento
  INER = CAE(2);              % área de la sección transversal del elemento
  LONE = XYE(2,1) - XYE(1,1); % longitud del elemento
  
  % matriz de rigidez
  MTX = (EYOU*INER)*[ 12/LONE^3  6/LONE^2  -12/LONE^3  6/LONE^2 ;
                       6/LONE^2  4/LONE    -6/LONE^2   2/LONE   ;
                     -12/LONE^3 -6/LONE^2  12/LONE^3  -6/LONE^2 ;
                       6/LONE^2  2/LONE    -6/LONE^2   4/LONE  ];
end
