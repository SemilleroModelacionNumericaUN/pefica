% matriz constitutiva para material lineal elástico bidimensional
function [MTX] = DELEME(CAE,TIPR)
  % entrada:
  % MAE():  tabla de propiedades del material y de los elementos
  % TIPR:   código del tipo de problema:
  %
  % salida:
  % MTX():  matriz constitutiva para material lineal elástico bidimensional
  
  switch TIPR
  case 30       % elasticidad tridimenional isotrópica
    [MTX] = DELA3D(CAE);
  otherwise
    error('Error. DELEME: código de tipo de problema incorrecto');
  end

end


% ------------------------------------------------------------------------
% matriz constitutiva para material lineal elástico tridimensional
function [MTX] = DELA3D(CAE)
  % entrada:
  % CAE():  tabla de propiedades del material y de los elementos
  %
  % salida:
  % MTX():  matriz constitutiva para material lineal elástico tridimensional

  % propiedades del material
  EYOU = CAE(1); % módulo de Young
  POIS = CAE(2); % relación de Poisson

  % matriz D
  MTX = zeros(6,6);
  
  % coeficientes de la matriz
  D11 = (1-POIS) * EYOU / ((1+POIS)*(1-2*POIS));
  D12 = POIS * EYOU / ((1+POIS)*(1-2*POIS));
  D44 = EYOU / (2*(1+POIS));
  
  MTX = [ D11 D12 D12 000 000 000 ;
          D12 D11 D12 000 000 000 ;
          D12 D12 D11 000 000 000 ;
          000 000 000 D44 000 000 ;
          000 000 000 000 D44 000 ;
          000 000 000 000 000 D44 ];
end