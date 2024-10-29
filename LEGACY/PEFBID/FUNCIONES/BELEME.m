% Matriz B de un elemento finito
function [MTX] = BELEME(XYE,XYP,TIPE)
  % Entrada:
  % XYE():  tabla de coordenadas globales de los nudos del elemento.
  % XYP():  tabla de coordenadas naturales del punto donde se evalúa B
  %         elemento.
  % TIPE:   código del tipo del elemento
  %       
  % Salida:
  % MTX():  matriz B del elemento

  switch TIPE
    case 201 % elemento 2D triangular lineal de 3 nudos
      [MTX] = BTRIEL(XYE);
    case 202 % elemento 2D cuadrilateral bilineal de 4 nudos
      [MTX] = BCUDEL(XYE,XYP);
    case 203 % elemento 2D triangular cuadrático de 6 nudos
      % escriba aquí
    case 204 % elemento 2D cuadrilateral bicuadrático de 9 nudos
      % escriba auí
    otherwise
      error('BELEME. Tipo incorrecto de elemento finito');
  end
 
end

% ------------------------------------------------------------------------
% matriz B de un elemento triangular lineal
function [MTX] = BTRIEL(XYE)
  % entrada:
  % XYE():  tabla de coordenadas de los nudos
  %
  % salida:
  % MTX():  matriz B del elemento finito

  TIPE = 201; % código del tipo de elemento
  AREA = PBAVEL(XYE,TIPE); % área del elemento
  % diferencias entre coordenadas
  B = zeros(1,3); C = zeros(1,3);
  B(1) = XYE(2,2) - XYE(3,2);
  B(2)= XYE(3,2) - XYE(1,2);
  B(3) = XYE(1,2) - XYE(2,2);
  C(1) = XYE(3,1) - XYE(2,1);
  C(2) = XYE(1,1) - XYE(3,1);
  C(3) = XYE(2,1) - XYE(1,1);

  % matriz B
  MTX = zeros(3,6,'double');
  MTX = [ B(1) 0    B(2) 0    B(3) 0   ;
          0    C(1) 0    C(2) 0    C(3);
          C(1) B(1) C(2) B(2) C(3) B(3)]./(2*AREA);

end

% ------------------------------------------------------------------------
% matriz B de un elemento cuadrilateral bilineal
function [BEL] = BCUDEL(XYE,XYP);
  % entrada:
  % XYE():  tabla de coordenadas de los nudos
  % XYP():  tabla de coordenadas naturales del punto donde se evalúa B
  %         elemento.
  %
  % salida:
  % BEL():  matriz B del elemento finito
  
  
  
  BEL = zeros(3,8); % definición de dimensiones de la matriz B.
  DNN = zeros(2,4); % definición de dimensiones de la matriz de derivadas 
  DNG = zeros(2,4);
        
  % identificar coordenadas naturales en el punto a evaluar
  % PXIH,PETA coordenadas naturales del punto en el interior del elemento 
  % donde se evalúa B
  PXIH = XYP(1, 1); PETA = XYP(1, 2);

  % Derivadas de las funciones de forma con respecto a las coordenadas 
  % naturales xi - eta
  DNN(1, 1) = -0.25 * (1 - PETA); % derivada de N1 con respecto a xi
  DNN(1, 2) = 0.25 * (1 - PETA);  % derivada de N2 con respecto a xi
  DNN(1, 3) = 0.25 * (1 + PETA);  % derivada de N3 con respecto a xi
  DNN(1, 4) = -0.25 * (1 + PETA); % derivada de N4 con respecto a xi
  DNN(2, 1) = -0.25 * (1 - PXIH); % derivada de N1 con respecto a eta
  DNN(2, 2) = -0.25 * (1 + PXIH); % derivada de N2 con respecto a eta
  DNN(2, 3) = 0.25 * (1 + PXIH);  % derivada de N3 con respecto a eta
  DNN(2, 4) = 0.25 * (1 - PXIH);  % derivada de N4 con respecto a eta
  % Matriz Jacobiano y su determinante
  JAC = DNN * XYE;
  DJAC = JAC(1, 1) * JAC(2, 2) - JAC(1, 2) * JAC(2, 1);
  DJAI = 1 / DJAC;
  % Matriz de operadores diferenciales (respecto a x-y) actuando sobre 
  % funciones de forma
  for INUD = 1:4
    % Derivadas de la funcion de forma del nudo INUD con respecto a las
    % coordenadas generales x-y
    DNG(1, INUD) = DJAI * (JAC(2,2) * DNN(1,INUD) - JAC(1,2) * DNN(2,INUD));
    DNG(2, INUD) = DJAI * (-JAC(2,1) * DNN(1,INUD) + JAC(1,1) * DNN(2,INUD));
    % Submatriz de operadores diferenciales actuando sobre la funcion de forma 
    % del nudo INUD
    ICOL = 2 * INUD - 1;
    BEL(1, ICOL) = DNG(1, INUD);
    BEL(2, ICOL + 1) = DNG(2, INUD);
    BEL(3, ICOL) = DNG(2, INUD);
    BEL(3, ICOL + 1) = DNG(1, INUD);
  end % endfor INUD

end
