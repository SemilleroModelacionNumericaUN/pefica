% ------------------------------------------------------------------------------
% identifica el lado de un elemento triangular lineal o cuadrilateral 
% bilineal, calcula su vector normal que entra al elemento 
% y su longitud a partir de la tabla de conectividades, la 
% tabla de coordenadas de los nudos y los nudos que lo conforman.
% entradas:   XYZ():  tabla de coordenadas de los nudos
%             ELE():  tabla de conectividades
%             FDE():  características del lado =[ IELE NUDI  NUDJ ]
% salidas:    NLA():  vector identificador del lado
%                     para elementos triangulares:
%                     =[1 -1 0]: lado 1 de I a J, =[-1 1 0]: lado 1 de J a I
%                     =[0 1 -1]: lado 2 de I a J, =[0 -1 1]: lado 2 de J a I
%                     =[1 0 -1]: lado 3 de I a J, =[-1 0 1]: lado 3 de J a I
%                     para elementos cuadrilaterales
%                     =[1 -1 0 0]: lado 1 de I a J, =[-1 1 0 0]: lado 1 de J a I 
%                     =[0 1 -1 0]: lado 2 de I a J, =[0 -1 1 0]: lado 2 de J a I
%                     =[1 0 -1 0]: lado 3 de I a J, =[-1 0 1 0]: lado 3 de J a I
%                     =[1 0 0 -1]: lado 4 de I a J, =[-1 0 0 1]: lado 4 de J a I
%             LLAD:   longitud del lado.
%             VNR():  vector unitario normal al lado cargado que entra al
%                     elemento finito
% ------------------------------------------------------------------------------
function [NLA,LLAD,VNR] = PBLADO(XYZ,ELE,FDE)
  % características del lado
  IELE = FDE(1);  % identificador del elemento
  NUDI = FDE(2);  % identificador del nudo inicial del lado
  NUDJ = FDE(3);  % identificador del nudo final del lado
  
  % longitud del lado
  LLAD = (XYZ(NUDJ,1)-XYZ(NUDI,1))^2 + (XYZ(NUDJ,2)-XYZ(NUDI,2))^2;
  LLAD = sqrt(LLAD);
  
  % vector unitario direccional del lado cargado IJ
  VLA = [ (XYZ(NUDJ,1)-XYZ(NUDI,1))/LLAD; (XYZ(NUDJ,2)-XYZ(NUDI,2))/LLAD ];
  
  % vector unitario direccional normal al lado cargado IJ conservando el eje
  % z saliendo del plano en un sistema coordenado derecho
  VNR = [ -VLA(2,1); VLA(1,1)];

  % identificador del lado
  NNUE = size(ELE,2)-1;  % número máximo de nudos por elemento en la malla
  NLA = zeros(1,NNUE); % vector identificador del lado
  for INUE = 1:NNUE
    switch ELE(IELE,INUE+1)
    case NUDI % nudo ini del lado cargado
      NLA(INUE)=1;
    case NUDJ % nudo fin del lado cargado
      NLA(INUE)=-1;
    case 0 % nudo no definido en el elemento
      % nada
    otherwise % nudo del lado no cargado
      NUDK = ELE(IELE,INUE+1);
    end % endswitch
  end % endfor
  
  % vector unitario direccional de un lado sin carga IK
  LVLB = (XYZ(NUDK,1)-XYZ(NUDI,1))^2 + (XYZ(NUDK,2)-XYZ(NUDI,2))^2;
  LVLB = sqrt(LVLB);
  VLB = [ (XYZ(NUDK,1)-XYZ(NUDI,1))/LVLB; (XYZ(NUDK,2)-XYZ(NUDI,2))/LVLB ];
  
  % definición del vector normal al lado cargado entrante al elemento finito
  % si el producto punto anterior es positivo VNR está entrando al ef, en
  % cambio, si PPNB es negativo VNR sale del ef y en consecuencia se cambia su
  % sentido para garantizar que VNR siempre está saliendo del ef.
  PPNB = dot(VNR,VLB); % producto punto entre los vectores VLB y VNR
  if PPNB<0; VNR = -VNR; end;
  
end