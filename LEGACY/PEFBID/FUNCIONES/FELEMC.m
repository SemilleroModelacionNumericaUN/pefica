% Vector de fuerzas equivalentes a la acción del peso específico
% del material en un elemento finito
function [FEL] = FELEMC(XYE,CAE)
  % Entrada:
  % XYE():  coordenadas de los nudos del elemento
  % CAE():  propiedades de la categoría del elemento
  %       
  % Salida:
  % FEL():  matriz de rigidez del elemento

  GAMM = CAE(3);  % peso específico del material
  TESP = CAE(4);  % espesor del elemento
  TIPE = CAE(5);  % código del tipo de elemento
  
  switch TIPE
    case 201 % elemento 2D triangular lineal
      AREA = PBAVEL(XYE,TIPE);    % área del elemento
      VOLU = AREA*TESP;           % volumen del elemento
      [FEL] = FTRIEC(3,VOLU,GAMM);
    case 202 % elemento 2D cuadrilateral bilineal
      [FEL] = FCUDEC(XYE,CAE);
    case 203 % elemento 2D triangular cuadrático
      % pendiente
    case 204 % elemento 2D cuadrilateral bicuadrático
      % pendiente
    otherwise
      error('FELEMC. Tipo incorrecto de elemento finito');
  end
 
end


% ------------------------------------------------------------------------
% Vector de fuerzas equivalentes a la acción del peso específico
% del material para un elemento triangular lineal
function [FEL] = FTRIEC(NNUE,VOLU,GAMM)
  % Entrada:
  % NNUE:   número de nudos del elemento
  % VOLU:   volumen del elemento
  % GAMM:   peso específico del material, que representa la componente
  %         de la fuerza de cuerpo en dirección -y.       
  % Salida:
  % FEL():  vector de fuerzas de cuerpo del elemento
  
  NGLN = 2; % número de GL por nudo en problemas bidimensionales
  FEL = zeros(NNUE*NGLN,1); % definición de tamaño del vector FEL()
  
  for INUE = 1:NNUE
        FEL(2*INUE,1) = -VOLU*GAMM/NNUE;
  end % endfor

end


% ------------------------------------------------------------------------
% Vector de fuerzas equivalentes a la acción del peso específico
% del material para un  elemento cuadrilateral bilineal
function [FEL] = FCUDEC(XYE,CAE)
  % Entrada:
  % XYE():  tabla de coordenadas de los nudos del elemento 
  % CAE():  tabla de propiedades del material y del elementos
  %       
  % Salida:
  % FEL():  vector de fuerza equivalente

  GAMM = CAE(3);  % peso específico del material
  TESP = CAE(4);  % espesor del elemento
  NGAU = CAE(7);  % número de puntos de Gauss del elemento
  NDIM = 2;       % número de dimensiones del elemento
  ENNU = 0;       % ubicación de evaluación: 0: puntos Gauss, 1: nudos elem
  
  [GAU] = PBPGAU(NGAU, NDIM, ENNU);  % tabla de ponderac. y ubicación de PGs
  FEL = zeros(8,1);                 % definir tamaño vector de fuerzas equival
  
  % definir el vector de fuerzas de cuerpo asociado al peso específico
  % aplicado en dirección -y
  FCB = [ 0 -GAMM 0 -GAMM 0 -GAMM 0 -GAMM]';
  
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
      
      % Matriz de funciones de forma
      NEL = zeros(8,2);
      NEL(1,1) = 0.25*(1-PXIH)*(1-PETA); % N1
      NEL(1,3) = 0.25*(1+PXIH)*(1-PETA); % N2
      NEL(1,5) = 0.25*(1+PXIH)*(1+PETA); % N3
      NEL(1,7) = 0.25*(1-PXIH)*(1+PETA); % N4
      NEL(2,2) = NEL(1,1); NEL(2,4) = NEL(1,3);
      NEL(2,6) = NEL(1,5); NEL(2,8) = NEL(1,7);
      
      % factor del vector de fuerzas
      FGAU = PWPW * TESP * DJAC;
      FPG = FGAU .* (NEL' * FCB );
      % sumar factores del vector de fuerzas en cada PG
      FEL = FEL + FPG;
      
  end % endfor IGAU
      
end