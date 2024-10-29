% Vector de fuerzas equivalentes a la carga distribuida uniforme
% en dirección y-local y positiva hacia el elemento.
function [FEL] = FELEMS(XYE,WYLO,WZLO)
% Entrada:  XYE():  coordenadas de los nudos del elemento
%           WYLO:   carga distribuida uniforme en dirección y-local
%                   positiva en el sentido positivo del eje
%           WZLO:   carga distribuida uniforme en dirección z-local
%                   positiva en el sentido positivo del eje
%
% Salida:   FEL():  vector de fuerza equivalente a la carga distribuida

  TIPE = 104; TEM=zeros(1,3);
  % longitud y matriz de transformación del elem                        
  [LONE,TRA] = PBTRAN(XYE,TIPE,TEM);
  
  FLO = zeros(12,1);
  % vector de fuerzas equiv a la carga distribuida en dirección y-local
  % definido en sistema coordenado local
  FLO(2,1) = WYLO*LONE/2;
  FLO(6,1) = WYLO*LONE^2/12;
  FLO(8,1) = WYLO*LONE/2;
  FLO(12,1) = -WYLO*LONE^2/12;
  % vector de fuerzas equiv a la carga distribuida en dirección z-local
  % definido en sistema coordenado local
  FLO(3,1) = WZLO*LONE/2;
  FLO(5,1) = -WZLO*LONE^2/12;
  FLO(9,1) = WZLO*LONE/2;
  FLO(11,1) = WZLO*LONE^2/12;
  
  % vector de fuerzas equv a la carga distribuida en sistema global
  FEL = TRA' * FLO;
 
end


