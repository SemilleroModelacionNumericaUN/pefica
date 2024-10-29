% matriz de transformación y longitud de un elemento de armadura plana
%
function [LONE,TRA] = PBTRAN(XYE)
% entradas: XYE() coordenadas del elemento
% salidas:  LONE  longitud del elemento
%           TRA() matriz de transformación
%
  LONX = XYE(2,1) - XYE(1,1);   % proyección en x del elemento
  LONY = XYE(2,2) - XYE(1,2);   % proyección en y del elemento
  LONE = sqrt(LONX^2+LONY^2);   % longitud del elemento 
  COSE = LONX/LONE;           % coseno de theta
  SINE = LONY/LONE;           % seno de theta
  % matriz de transformación para armadura plana
  TRA = [  COSE, SINE,     0,    0  ;
              0,    0,  COSE, SINE  ];
              
end % endfunction