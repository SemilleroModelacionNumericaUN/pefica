% Vector de fuerzas equivalentes a la acción de fuerzas de cuerpo
% en un elemento finito
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
    case 301 % elemento 3D tetrahédrico lineal
      VOLU = PBAVEL(XYE,TIPE);    % volumen del elemento
      [FEL] = FTETRC(4,VOLU,GAMM);
    case 302 % elemento 3D hexahédrico bilineal
      % pendiente
    otherwise
      % pendiente
  end
 
end


% ------------------------------------------------------------------------
% Vector de fuerzas de cuerpo del elemento tetraédrico
function [FEL] = FTETRC(NNUE,VOLU,GAMM)
  % Entrada:
  % NNUE:   número de nudos del elemento
  % VOLU:   volumen del elemento
  % GAMM:   peso específico del material, que representa la componente
  %         de la fuerza de cuerpo en dirección -y.       
  % Salida:
  % FEL():  vector de fuerzas de cuerpo del elemento
  
  NGLN = 3; % número de GL por nudo en problemas tridimensionales
  FEL = zeros(NNUE*NGLN,1); % definición de tamaño del vector FEL()
  
  for INUE = 1:NNUE
        FEL(3*INUE-1,1) = -VOLU*GAMM/NNUE;
  end % endfor

end
