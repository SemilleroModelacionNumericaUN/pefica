% Matriz de rigidez de un elemento finito
function [MTX] = KELEME(TIPR,XYE,CAE)
  % Entrada:
  % TIPR:   código del tipo de problema
  % XYE():  coordenadas de los nudos del elemento
  % CAE():  propiedades de la categoría del elemento
  %       
  % Salida:
  % MTX():  matriz de rigidez del elemento

  PCAT = size(CAE,2);
  TIPE = CAE(1,PCAT-2); % código del tipo de elemento

  switch TIPE
    case 102 % armaduras tridimensional
      [MTX] = KARMA(TIPR,XYE,CAE);
    case 104 % pórtico tridimensional
      [MTX] = KPORT(TIPR,XYE,CAE);
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
% Matriz de rigidez del elemento pórtico tridimensional
function [MTX] = KPORT(TIPR,XYE,CAE)
  % Entrada:
  % TIPR:   tipo de problema
  % XYE():  coordenadas de los nudos del elemento 
  % CAE():  propiedades de la categoría del elemento
  %       
  % Salida:
  % MTX():  matriz de rigidez del elemento
  
  TIPE = 104;                 % código del tipo de elemento
  EYOU = CAE(1);              % módulo de elasticidad del material del elemento
  POIS = CAE(2);              % relación de Poisson del material del elemento
  AREA = CAE(4);              % área de la sección transversal del elemento
  INEY = CAE(5);              % inercia respecto a y local de la sec. transv.
  INEZ = CAE(6);              % inercia respecto a z local de la sec. transv.
  JTOR = CAE(7);              % constante torsional de la sec. transv.
  ALSH = CAE(8);              % factor de forma asociado a deformaciones por cortante
  VEL = CAE(11:13);           % vector auxiliar para determinar el plano xy-local
  
  GMOD = EYOU/(2*(1+POIS));   % módulo de elasticidad a cortante del material
  
  % longitud y matriz de transformación del elem                        
  [LONE,TRA] = PBTRAN(XYE,TIPE,VEL);
  
  % matriz de rigidez en sistema local de coordenadas
  MTL = zeros(12,12);
  % términos de la diagonal superior
  MTL(1,1) = EYOU*AREA/LONE;
  MTL(1,7) = -EYOU*AREA/LONE;
  %
  MTL(2,2) = 12*EYOU*INEZ/LONE^3;
  MTL(2,6) = 6*EYOU*INEZ/LONE^2;
  MTL(2,8) = -12*EYOU*INEZ/LONE^3;
  MTL(2,12) = 6*EYOU*INEZ/LONE^2;
  %
  MTL(3,3) = 12*EYOU*INEY/LONE^3;
  MTL(3,5) = -6*EYOU*INEY/LONE^2;
  MTL(3,9) = -12*EYOU*INEY/LONE^3;
  MTL(3,11) = -6*EYOU*INEY/LONE^2;
  %
  MTL(4,4) = GMOD*JTOR/LONE;
  MTL(4,10) = -GMOD*JTOR/LONE;
  %
  MTL(5,5) = 4*EYOU*INEY/LONE;
  MTL(5,9) = 6*EYOU*INEY/LONE^2;
  MTL(5,11) = 2*EYOU*INEY/LONE;
  %
  MTL(6,6) = 4*EYOU*INEZ/LONE;
  MTL(6,8) = -6*EYOU*INEZ/LONE^2;
  MTL(6,12) = 2*EYOU*INEZ/LONE;
  %
  MTL(7,7) = EYOU*AREA/LONE;
  %
  MTL(8,8) = 12*EYOU*INEZ/LONE^3;
  MTL(8,12) = -6*EYOU*INEZ/LONE^2;
  %
  MTL(9,9) = 12*EYOU*INEY/LONE^3;
  MTL(9,11) = 6*EYOU*INEY/LONE^2;
  %
  MTL(10,10) = GMOD*JTOR/LONE;
  %
  MTL(11,11) = 4*EYOU*INEY/LONE;
  %
  MTL(12,12) = 4*EYOU*INEZ/LONE;
  
  % matriz de reducción de rigidez debida a las deformaciones por cortante
  % Cada coeficiente de esta matriz se multiplica por el correspondiente de
  % la matriz de rigidez para considerar las deforaciones por cortante.
  MSH = ones(12,12);
  % términos de la diagonal superior
  % coeficientes de reducción de rigidez en el plano xy - local
  BETA = ALSH*12*(1 + POIS)*INEZ / (AREA*LONE^2);
  DC(1) = 1/(1 + 2*BETA);
  DC(2) = (2+BETA) / (2*(1 + 2*BETA));
  DC(3) = (1-BETA) / (1 + 2*BETA);
  % coeficientes de reducción de rigidez en el plano xz - local
  BETA = ALSH*12*(1 + POIS)*INEY / (AREA*LONE^2);
  DC(4) = 1/(1 + 2*BETA);
  DC(5) = (2+BETA) / (2*(1 + 2*BETA));
  DC(6) = (1-BETA) / (1 + 2*BETA);
  %
  MSH(2, 2) = DC(1);
  MSH(2, 6) = DC(1);
  MSH(2, 8) = DC(1);
  MSH(2, 12) = DC(1);
  %
  MSH(3, 3) = DC(4);
  MSH(3, 5) = DC(4);
  MSH(3, 9) = DC(4);
  MSH(3, 11) = DC(4);
  %
  MSH(5, 5) = DC(5);
  MSH(5, 9) = DC(4);
  MSH(5, 11) = DC(6);
  %
  MSH(6, 6) = DC(2);
  MSH(6, 8) = DC(1);
  MSH(6, 12) = DC(3);
  %
  MSH(8, 8) = DC(1);
  MSH(8, 12) = DC(1);
  %
  MSH(9, 9) = DC(4);
  MSH(9, 11) = DC(4);
  %
  MSH(11, 11) = DC(5);
  %
  MSH(12, 12) = DC(2);
  % producto entre coeficientes de la matriz de rigidez estandar y la
  % matriz de reducción de la rigidez debida a deformaciones por cortante
  TEM = MTL.*MSH;
  MTL = TEM;
  
  % llena los términos de la diagonal inferior
  NMTL=12;
  for IMTL=1:NMTL
    for JMTL=IMTL:NMTL
      MTL(JMTL,IMTL) = MTL(IMTL,JMTL);
    end % endfor
  end % endfor
  
  % matriz de rigidez en sistema global de coordenadas
  MTX = TRA' * MTL * TRA;
  
end

