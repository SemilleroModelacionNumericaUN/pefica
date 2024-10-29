% matriz constitutiva para material lineal elástico bidimensional
function [MTX] = DELEME(CAE,TIPR)
  % entrada:
  % MAE():  tabla de propiedades del material y de los elementos
  % TIPR:   código del tipo de problema:
  %
  % salida:
  % MTX():  matriz constitutiva para material lineal elástico bidimensional
  
  switch TIPR
    case {20 21}  % elasticidad bidimensional isotrópica
    [MTX] = DELA2D(CAE,TIPR);
    case 30       % elasticidad tridimenional isotrópica
    % pendiente
    otherwise
    error('Error. DELEME: código de tipo de problema incorrecto');
  end

end

% ------------------------------------------------------------------------
% matriz constitutiva para material lineal elástico bidimensional
function [MTX] = DELA2D(CAE,TIPR)
  % entrada:
  % MAE():  tabla de propiedades del material y de los elementos
  % TIPR:   código del tipo de problema:
  %         20: cond. plana de esfuerzos, 21: cond. plana de deformaciones
  %
  % salida:
  % MTX():  matriz constitutiva para material lineal elástico bidimensional

  % propiedades del material
  EYOU = CAE(1); % módulo de Young
  POIS = CAE(2); % relación de Poisson

  % matriz D
  MTX = zeros(3,3);

  switch TIPR
    case 20 % cond. plana de esfuerzos
      MTX(1,1) = EYOU/(1-POIS^2);
      MTX(1,2) = POIS*EYOU/(1-POIS^2);
      MTX(2,1) = MTX(1,2);
      MTX(2,2) = MTX(1,1);
      MTX(3,3) = 0.5*(1-POIS)*(EYOU/(1-POIS^2));
    case 21 % cond. plana de deformaciones
      MTX(1,1) = (1-POIS)*EYOU/((1+POIS)*(1-2*POIS));
      MTX(1,2) = POIS*EYOU/((1+POIS)*(1-2*POIS));
      MTX(2,1) = MTX(1,2);
      MTX(2,2) = MTX(1,1);
      MTX(3,3) = 0.5*(1-POIS)*(EYOU/(1-POIS^2));  
    otherwise
      error('Error. DELA2D: código de tipo de problema incorrecto');
  end
end