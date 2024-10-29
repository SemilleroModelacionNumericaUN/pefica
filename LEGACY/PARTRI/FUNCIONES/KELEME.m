% Matriz de rigidez de un elemento finito
function [MTX] = KELEME(TIPR,XYE,CAE)
  % Entrada:
  % TIPR:   código del tipo de problema
  % XYE():  coordenadas de los nudos del elemento
  % CAE():  propiedades de la categoría del elemento
  %       
  % Salida:
  % MTX():  matriz de rigidez del elemento

  TIPE = CAE(8); % código del tipo de elemento

  switch TIPE
    case 102 % armaduras tridimensional
      [MTX] = KARMA(TIPR,XYE,CAE);
    otherwise
      % pendiente
  end
 
end

% ------------------------------------------------------------------------
% Matriz de rigidez del elemento armadura tridimensional
function [MTX] = KARMA(TIPR,XYE,CAE)
  % Entrada:
  % TIPR:   tipo de problema
  % XYE():  coordenadas de los nudos del elemento 
  % CAE():  propiedades de la categoría del elemento
  %       
  % Salida:
  % MTX():  matriz de rigidez del elemento
  
  TIPE = 102;                 % código del tipo de elemento
  EYOU = CAE(1);              % módulo de elasticidad del elemento
  AREA = CAE(4);              % área de la sección transversal del elemento
  
  [LONE,TRA] = PBTRAN(XYE);   % longitud y matriz de transformación del elem
  
  % matriz de rigidez en sistema local de coordenadas
  MTL = (EYOU*AREA/LONE)*[ 1  -1 ;
                          -1   1 ];
  % matriz de rigidez en sistema global de coordenadas
  MTX = TRA' * MTL * TRA;
  
end





% ------------------------------------------------------------------------
% Matriz de rigidez del elemento triangular lineal de elasticidad
function [MTX] = KTRIEL(TIPR,XYE,CAE)
  % Entrada:
  % TIPR:   tipo de problema
  % XYE():  coordenadas de los nudos del elemento 
  % CAE():  propiedades de la categoría del elementos
  %       
  % Salida:
  % MTX():  matriz de rigidez del elemento
  
  TIPE = 201;                 % código del tipo de elemento
  TESP = CAE(4);              % espesor del elemento
  AREA = PBAVEL(XYE,TIPE);    % área del elemento
  VOLU = AREA*TESP;           % volumen del elemento
  [BEL] = BELEME(XYE,0,TIPE); % matriz B
  [DEL] = DELEME(CAE,TIPR);   % matriz D
  MTX = VOLU.*BEL'*DEL*BEL ;  % matriz de rigidez
      
end

% ------------------------------------------------------------------------
% Matriz de rigidez del elemento cuadrilateral bilineal de elasticidad
function [KEL] = KCUDEL(TIPR,XYE,CAE)
  % Entrada:
  % IELE:   número del elemento
  % TIPR:   código del tipo de problema
  % XYE():  tabla de coordenadas de los nudos del elemento 
  % CAE():  tabla de propiedades del material y del elementos
  %       
  % Salida:
  % KEL():  matriz de rigidez del elemento

  TESP = CAE(4);  % espesor del elemento
  NGAU = CAE(7);  % número de puntos de Gauss del elemento
  NDIM = 2;       % número de dimensiones del elemento
  ENNU = 0;       % ubicación de evaluación: 0: puntos Gauss, 1: nudos elem
  
  [GAU] = PBPGAU(NGAU, NDIM, ENNU);  % tabla de ponderac. y ubicación de PGs
  [DEL] = DELEME(CAE,TIPR);          % matriz constitutiva del material 
  KEL = zeros(8,8);                 % definir tamaño matriz rigidez
  
  for IGAU = 1:NGAU % ciclo por punto de Gauss
      PXIH = GAU(IGAU, 1);    % coordenada xi
      PETA = GAU(IGAU, 2);    % coordenada eta
      PWPW = GAU(IGAU, 3);    % ponderación W_xi*W_eta
      % Derivadas de las funciones de forma con respecto a las 
      % coordenadas naturales xi - eta
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
      % Matriz de operadores diferenciales (respecto a x-y) 
      % actuando sobre funciones de forma
      for INUD = 1:4
        % Derivadas de la funcion de forma del nudo INUD con respecto 
        % a las coordenadas generales x-y
        DNG(1,INUD) = DJAI*(JAC(2,2)*DNN(1,INUD)-JAC(1,2)*DNN(2,INUD));
        DNG(2,INUD) = DJAI*(-JAC(2, 1)*DNN(1,INUD)+JAC(1,1)*DNN(2, INUD));
        % Submatriz de operadores diferenciales actuando sobre 
        % la funcion de forma del nudo INUD
        ICOL = 2 * INUD - 1;
        BEL(1, ICOL) = DNG(1, INUD);
        BEL(2, ICOL + 1) = DNG(2, INUD);
        BEL(3, ICOL) = DNG(2, INUD);
        BEL(3, ICOL + 1) = DNG(1, INUD);
      end % endfor INUD
      % factor de la matriz de rigidez
      FGAU = PWPW * TESP * DJAC;
      KPG = FGAU .* (BEL' * DEL * BEL);
      % sumar factores de la matriz de rigidez en cada PG
      KEL = KEL + KPG;
  end % endfor IGAU
      
end
