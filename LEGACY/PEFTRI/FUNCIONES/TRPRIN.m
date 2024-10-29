% esfuerzos o deformaciones principales y esfuerzo de von Mises,
% para problemas tridimensionales
function [PVA,STVM] = TRPRIN(SEV,STDE)
% entradas:
% SEV(): vector de esfuerzos o deformaciones
%        = [ SXX, SYY, SZZ, SXY, SXZ, SYZ ] para esfuerzos
%        = [ EXX, EYY, EZZ, GXY, GXZ, GYZ ] para deformaciones
% STDE:  identificador del tipo de calculo: 0:cal esfuerzos, 1:cal deformaciones
%
% salidas:
% PVA(): vector de esfuerzos principales
% STVM:  esfuerzo equivalente de Von Mises

  % modificar las deformaciones angulares de notación
  % de ingeniería a en not. científica
  if STDE==1
    SEV(4:6)=0.5.*SEV(4:6);
  end
  
  % organizar componentes de esfuerzo o deformación en matriz cuadrada
  SEM = [ SEV(1) SEV(4) SEV(5);
          SEV(4) SEV(2) SEV(6);
          SEV(5) SEV(6) SEV(3)];
  
  % esfuerzos o deformaciones principales
  TEM = eig(SEM);
  PVA = sort(TEM,'descend');
  
  if STDE==0
    % esfuerzo equivalente de Von Mises
    STVM = (1 / sqrt(2)) * sqrt( (PVA(1) - PVA(2))^ 2 + ...
           (PVA(1) - PVA(3))^2 + (PVA(2) - PVA(3))^2 );
  else
    % no aplica para deformaciones
    STVM = 0;
  end % endif

end