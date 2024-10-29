% identifica el lado de un elemento triangular lineal o cuadrilateral 
% bilineal y su longitud a partir de la tabla de conectividades, la 
% tabla de coordenadas de los nudos y los nudos que lo conforman.
function [NLA,LLAD,VLA] = PBLADO(XYZ,ELE,FDE)
% entradas:   XYZ():  tabla de coordenadas de los nudos
%             ELE():  tabla de conectividades
%             FDE():  características del lado =[ IELE NUDI  NUDJ ]
% salidas:    NLA():  vector identificador del lado
%                     =[1 1 0]: lado 1 si NNUE=3 o =[1 1 0 0]: lado 1 si NNUE=4 
%                     =[0 1 1]: lado 2 si NNUE=3 o =[0 1 1 0]: lado 2 si NNUE=4 
%                     =[1 0 1]: lado 3 si NNUE=3 o =[1 0 1 0]: lado 3 si NNUE=4 
%                     =[1 0 0 1]: lado 1 si NNUE=4 (núm máx de nudos por elem.) 
%             LLAD:   longitud del lado.
%             VLA():  vector unitario direccional del lado
  
  % características del lado
  IELE = FDE(1);  % identificador del elemento
  NUDI = FDE(2);  % identificador del nudo inicial del lado
  NUDJ = FDE(3);  % identificador del nudo final del lado

  % longitud del lado
  LLAD = (XYZ(NUDJ,1)-XYZ(NUDI,1))^2 + (XYZ(NUDJ,2)-XYZ(NUDI,2))^2;
  LLAD = sqrt(LLAD);
  
  % vector unitario direccional del lado
  VLA = [ (XYZ(NUDJ,1)-XYZ(NUDI,1))/LLAD; (XYZ(NUDJ,2)-XYZ(NUDI,2))/LLAD ];

  % identificador del lado
  NNUE = size(ELE,1)-1;  % número máximo de nudos por elemento en la malla
  NLA = zeros(1,NNUE); % vector identificador del lado
  for INUE = 1:NNUE;
    if ELE(IELE,INUE+1)==NUDI; NLA(INUE)=1; end
    if ELE(IELE,INUE+1)==NUDJ; NLA(INUE)=1; end
  end % endfor
  
end