% Matriz de funciones de forma N de un elemento finito
function [MTX] = NELEME(XYE,XYP,TIPE)
  % Entrada:
  % XYE():  coordenadas globales de los nudos del elemento.
  % XYP():  coordenadas del punto donde se evalúa N dentro del elemento.
  % TIPE:   código del tipo del elemento
  %       
  % Salida:
  % MTX():  matriz N del elemento

  switch TIPE
    case 201 % elemento 2D triangular lineal
      [MTX] = NTRIEL(XYE,XYP);
    case 202 % elemento 2D cuadrilateral bilineal
      [MTX] = NCUDEL(XYE,XYP);
    case 203 % elemento 2D triangular cuadrático
      % escriba aquí
    case 204 % elemento 2D cuadrilateral bicuadrático
      % escriba aquí
    otherwise
      error('NELEME. Tipo incorrecto de elemento finito.');
  end
 
end

% ------------------------------------------------------------------------
% matriz N de un elemento triangular lineal
function [MTX] = NTRIEL(XYE,XYP)
  % entrada:
  % XYE():  coordenadas globales de los nudos del elemento
  % XYP():  coordenadas globales del punto donde se evaúla N dentro del elem.
  %
  % salida:
  % MTX():  matriz N del elemento finito

  % área del elemento
  AREA = PBAVEL(XYE,201,0);
  % diferencias entre coordenadas
  A = zeros(3); B = zeros(3); C = zeros(3); N = zeros(3);
  A(1) = XYE(2,1) * XYE(3,2) - XYE(3,1) * XYE(2,2);
  A(2) = XYE(3,1) * XYE(1,2) - XYE(1,1) * XYE(3,2);
  A(3) = XYE(1,1) * XYE(2,2) - XYE(2,1) * XYE(1,2);
  B(1) = XYE(2,2) - XYE(3,2);
  B(2) = XYE(3,2) - XYE(1,2);
  B(3) = XYE(1,2) - XYE(2,2);
  C(1) = XYE(3,1) - XYE(2,1);
  C(2) = XYE(1,1) - XYE(3,1);
  C(3) = XYE(2,1) - XYE(1,1);
  
  % matriz N
  MTX = zeros(2,6);
  for INUD=1:3
    % funciones de forma
    N(INUD)=(A(INUD)+B(INUD)*XYP(1)+C(INUD)*XYP(2))/(2*AREA);
    % control de punto fuera del elemento
    if (N(INUD)>1 || N(INUD)<0)
      error('NELEME: las coordenadas del punto estan fuera del elemento.');
    end % endif
    % matriz N
    MTX(1, 2*INUD-1)  = N(INUD);
    MTX(2, 2*INUD)    = N(INUD);
  end %endfor INUD

end

% ------------------------------------------------------------------------
% matriz N de un elemento cuadrilateral bilineal
function [MTX] = NCUDEL(XYE,XYN)
  % entrada:
  % XYE():  coordenadas globales de los nudos del elemento
  % XYP():  coordenadas naturales del punto donde se evaúla N dentro del elem.
  %         entre -1 y 1. XYN(1) es \xi y XYN(2) es \eta.
  %
  % salida:
  % MTX():  matriz N del elemento finito
  
  % control de punto fuera del elemento
  if (XYN(1)>1 || XYN(1)<-1 || XYN(2)>1 || XYN(2)<-1)
    error('NELEME: las coordenadas del punto estan fuera del elemento.');
  end % endif
  
  % funciones de forma
  N = zeros(4);
  N(1)=0.25*(1-XYN(1))*(1-XYN(2));
  N(2)=0.25*(1+XYN(1))*(1-XYN(2));
  N(3)=0.25*(1+XYN(1))*(1+XYN(2));
  N(4)=0.25*(1-XYN(1))*(1+XYN(2));
  
  % matriz N
  MTX = zeros(2,4);
  for INUD=1:4
    MTX(1,2*INUD-1) = N(INUD);
    MTX(2,2*INUD)   = N(INUD);
  end %endfor INUD

end