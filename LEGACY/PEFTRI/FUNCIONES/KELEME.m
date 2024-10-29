% Matriz de rigidez de un elemento finito
function [MTX] = KELEME(TIPR,XYE,CAE)
  % Entrada:
  % TIPR:   código del tipo de problema
  % XYE():  coordenadas de los nudos del elemento
  % CAE():  propiedades de la categoría del elemento
  %       
  % Salida:
  % MTX():  matriz de rigidez del elemento

  TIPE = CAE(5); % código del tipo de elemento

  switch TIPE
    case 301 % elemento 3D tetrahédrico lineal
      [MTX] = KTETRA(TIPR,XYE,CAE);
    case 302 % elemento 3D hexahédrico bilineal
      % pendiente
    otherwise
      % pendiente
  end
 
end


% ------------------------------------------------------------------------
% Matriz de rigidez del elemento tetraédrico lineal de elasticidad
function [MTX] = KTETRA(TIPR,XYE,CAE)
  % Entrada:
  % TIPR:   tipo de problema
  % XYE():  coordenadas de los nudos del elemento 
  % CAE():  propiedades de la categoría del elementos
  %       
  % Salida:
  % MTX():  matriz de rigidez del elemento
  
  TIPE = 301;                 % código del tipo de elemento
  [BEL] = BELEME(XYE,0,TIPE); % matriz B
  [DEL] = DELEME(CAE,TIPR);   % matriz D
  VOLU = PBAVEL(XYE,TIPE);    % volumen del elemento
  MTX = VOLU.*BEL'*DEL*BEL ;  % matriz de rigidez
      
end