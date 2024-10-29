% Constantes de ponderación y ubicación de puntos  
% en el metodo de integración numérica de la cuadratura de Gauss
function [MTX] = PBPGAU(NGAU, NDIM, ENNU)
  % Entrada:
  % NGAU    número de puntos de Gauss del elemento
  % NDIM    número de dimensiones del problema
  %
  % Salida:
  % MTX()   tabla de constans. de ponderac. en la integración numérica de Gauss
  %         MTX(*,1)  coordenada natural x del punto de Gauss
  %         MTX(*,2)  coordenada natural y del punto de Gauss (para NDIM=2)
  %         MTX(*,3)  constantes de ponderación (para NDIM=2)
  % ENNU    =0:en puntos de Gauss, =1: en nudos, =2: en el centro del elemento
  
  MTX = zeros(NGAU,NDIM + 1);  
  
  switch ENNU
    case 0 % en puntos de Gauss
    switch NDIM
      case 1  % uni-dimensional
      switch NGAU
        case 1 
        MTX(1, 2) = 2; % ponderación
        MTX(1, 1) = 0; % ubicación xi
        case 2
        MTX(1, 2) = 1; MTX(2, 2) = 1; % ponderación
        MTX(1, 1) = -0.577350269; MTX(2, 1) = 0.577350269; % ubicación
        case 3
        % ponderación
        MTX(1, 2) = 0.555555556;
        MTX(2, 2) = 0.888888889;
        MTX(3, 2) = 0.555555556;
        % ubicación
        MTX(1, 1) = -0.774596669;
        MTX(2, 1) = 0;
        MTX(3, 1) = 0.774596669;
        case 4
        % ponderación
        MTX(1, 2) = 0.347854845;
        MTX(2, 2) = 0.652145155;
        MTX(3, 2) = 0.652145155;
        MTX(4, 2) = 0.347854845;
        % ubicación xi
        MTX(1, 1) = -0.861136312;
        MTX(2, 1) = -0.339981044;
        MTX(3, 1) = 0.339981044;
        MTX(4, 1) = 0.861136312;
        otherwise
        error('Error. PBPGAU: no hay valores para NGAU puntos');
      end % endswitch NGAU 
      %
      case 2  % bi-dimensional
      switch NGAU
        case 1
        % ponderación
        MTX(1, 3) = 2;
        % ubicación (xi,eta)
        MTX(1, 1) = 0; MTX(1, 2) = 0;
        case 4
        % ponderación W_xi*W_eta
        MTX(1, 3) = 1;
        MTX(2, 3) = 1;
        MTX(3, 3) = 1;
        MTX(4, 3) = 1;
        % ubicación (xi,eta)
        MTX(1, 1) = -0.577350269; MTX(1, 2) = -0.577350269;
        MTX(2, 1) = 0.577350269; MTX(2, 2) = -0.577350269;
        MTX(3, 1) = 0.577350269; MTX(3, 2) = 0.577350269;
        MTX(4, 1) = -0.577350269; MTX(4, 2) = 0.577350269;
        case 9
        % ponderación W_xi*W_eta
        MTX(1, 3) = 0.555555556 * 0.555555556;
        MTX(2, 3) = 0.888888889 * 0.555555556;
        MTX(3, 3) = 0.555555556 * 0.555555556;
        MTX(4, 3) = 0.555555556 * 0.888888889;
        MTX(5, 3) = 0.888888889 * 0.888888889;
        MTX(6, 3) = 0.555555556 * 0.888888889;
        MTX(7, 3) = 0.555555556 * 0.555555556;
        MTX(8, 3) = 0.888888889 * 0.555555556;
        MTX(9, 3) = 0.555555556 * 0.555555556;
        % ubicación (xi,eta)
        MTX(1, 1) = -0.774596669; MTX(1, 2) = -0.774596669;
        MTX(2, 1) = 0; MTX(2, 3) = -0.774596669;
        MTX(3, 1) = 0.774596669; MTX(3, 2) = -0.774596669;
        MTX(4, 1) = -0.774596669; MTX(4, 2) = 0;
        MTX(5, 1) = 0; MTX(5, 2) = 0;
        MTX(6, 1) = 0.774596669; MTX(6, 2) = 0;
        MTX(7, 1) = -0.774596669; MTX(7, 2) = 0.774596669;
        MTX(8, 1) = 0; MTX(8, 2) = 0.774596669;
        MTX(9, 1) = 0.774596669; MTX(9, 2) = 0.774596669;
        otherwise
        error('Error. PBPGAU: no hay valores para NGAU puntos');
      end % endswitch NGAU
    end % endswitch NDIM
  case 1 % en nudos del elemento
    MTX(1, 1) = -1; MTX(1, 2) = -1;
    MTX(2, 1) = 1;  MTX(2, 2) = -1;
    MTX(3, 1) = 1;  MTX(3, 2) = 1;
    MTX(4, 1) = -1; MTX(4, 2) = 1;
  case 2 % en el centro
    % MTX() se conserva en ceros
  end % enswitch ENNU
  
end

