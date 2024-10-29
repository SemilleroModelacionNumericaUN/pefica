% matriz de transformación y longitud de un elemento de armadura
% tridimensional
%
function [LONE,TRA] = PBTRAN(XYE)
% entradas: XYE() coordenadas del elemento
% salidas:  LONE  longitud del elemento
%           TRA() matriz de transformación
%
  
  % proyecciones de la barra
  for ICOM=1:3
    VEN(ICOM) = XYE(2,ICOM) - XYE(1,ICOM);
  end %endfor
  LONE = norm(VEN); % longitud de la barra
  
  % vector unitario direccional
  VEN = (1/LONE).*VEN;
   
  
  % matriz de transformación para armadura 3D
  MZE = zeros(1,3);
  TRA = [ VEN, MZE ;
          MZE, VEN ];
              
end % endfunction