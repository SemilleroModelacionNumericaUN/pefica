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
    case 301 % elemento 3D tetrahédrico lineal
      [MTX] = BTETRA(XYE);
    case 302 % elemento 3D hexahédrico bilineal
      % pendiente
    otherwise
      % pendiente
  end
 
end


% ------------------------------------------------------------------------
% matriz B de un elemento tetraédrico lineal
function [MTX] = BTETRA(XYE)
  % entrada:
  % XYE():  tabla de coordenadas de los nudos
  %
  % salida:
  % MTX():  matriz B del elemento finito

  TIPE = 301; % código del tipo de elemento
  VOLU = 6 * PBAVEL(XYE,TIPE); % 6 * volumen del elemento
  % coordenadas de los nudos
  X = XYE(:,1); Y = XYE(:,2); Z = XYE(:,3);
  % constantes
  b(1) = -(Y(3) * Z(4) - Y(4) * Z(3)) + (Y(2) * Z(4) - Y(4) * Z(2)) - ...
          (Y(2) * Z(3) - Y(3) * Z(2));
  c(1) = (X(3) * Z(4) - X(4) * Z(3)) - (X(2) * Z(4) - X(4) * Z(2)) + ...
         (X(2) * Z(3) - X(3) * Z(2));
  d(1) = -(X(3) * Y(4) - X(4) * Y(3)) + (X(2) * Y(4) - X(4) * Y(2)) - ...
          (X(2) * Y(3) - X(3) * Y(2));
  
  b(2) = (Y(3) * Z(4) - Y(4) * Z(3)) - (Y(1) * Z(4) - Y(4) * Z(1)) + ...
         (Y(1) * Z(3) - Y(3) * Z(1));
  c(2) = -(X(3) * Z(4) - X(4) * Z(3)) + (X(1) * Z(4) - X(4) * Z(1)) - ...
          (X(1) * Z(3) - X(3) * Z(1));
  d(2) = (X(3) * Y(4) - X(4) * Y(3)) - (X(1) * Y(4) - X(4) * Y(1)) + ...
         (X(1) * Y(3) - X(3) * Y(1));
  
  b(3) = -(Y(2) * Z(4) - Y(4) * Z(2)) + (Y(1) * Z(4) - Y(4) * Z(1)) - ...
          (Y(1) * Z(2) - Y(2) * Z(1));
  c(3) = (X(2) * Z(4) - X(4) * Z(2)) - (X(1) * Z(4) - X(4) * Z(1)) + ...
         (X(1) * Z(2) - X(2) * Z(1));
  d(3) = -(X(2) * Y(4) - X(4) * Y(2)) + (X(1) * Y(4) - X(4) * Y(1)) - ...
         (X(1) * Y(2) - X(2) * Y(1));
       
  b(4) = (Y(2) * Z(3) - Y(3) * Z(2)) - (Y(1) * Z(3) - Y(3) * Z(1)) + ...
         (Y(1) * Z(2) - Y(2) * Z(1));
  c(4) = -(X(2) * Z(3) - X(3) * Z(2)) + (X(1) * Z(3) - X(3) * Z(1)) - ...
          (X(1) * Z(2) - X(2) * Z(1));
  d(4) = (X(2) * Y(3) - X(3) * Y(2)) - (X(1) * Y(3) - X(3) * Y(1)) + ...
         (X(1) * Y(2) - X(2) * Y(1));
 
  % matriz B
  MTX = zeros(6,12,'double');
  for I = 1:4
    MTX(1, 3 * I - 2) = b(I) / VOLU;
    MTX(2, 3 * I - 1) = c(I) / VOLU;
    MTX(3, 3 * I) = d(I) / VOLU;
    MTX(4, 3 * I - 2) = c(I) / VOLU;
    MTX(4, 3 * I - 1) = b(I) / VOLU;
    MTX(5, 3 * I - 2) = d(I) / VOLU;
    MTX(5, 3 * I) = b(I) / VOLU;
    MTX(6, 3 * I - 1) = d(I) / VOLU;
    MTX(6, 3 * I) = c(I) / VOLU;
  end % endfor
 
end
