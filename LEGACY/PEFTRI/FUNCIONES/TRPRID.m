% esfuerzos o deformaciones principales y esfuerzo de von Mises,
% direcciones principales
% para problemas tridimensionales
function [PVA,PDI,STVM] = TRPRID(SEV,STDE)
% entradas:
% SEV(): vector de esfuerzos o deformaciones
%        = [ SXX, SYY, SZZ, SXY, SXZ, SYZ ] para esfuerzos
%        = [ EXX, EYY, EZZ, GXY, GXZ, GYZ ] para deformaciones
% STDE:  identificador del tipo de calculo: 0:cal esfuerzos, 1:cal deformaciones
%
% salidas:
% PVA(): vector de esfuerzos principales
% PDI(): matriz de direcciones principales. Las filas 1, 2 y 3 tienen las 
%      componentes del vector unitario de la dirección principal 1, 2 y 3, resp. 
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
  [PDI,PVA] = eig(SEM);
  % organizar valores y vectores propios
  TEM = [diag(PVA), PDI'];
  TEP = sortrows(TEM,-1); % para Octave
  %TEP = sortrows(TEM,1,'descend'); % para Matlab
  PVA = TEP(:,1);
  PDI = TEP(:,2:4);
  % normalizar vectores propios
  for IDPR=1:3
    NPDI = norm(PDI(IDPR,:));
    PDI(IDPR,:) = (1/NPDI).*PDI(IDPR,:);
  end % endfor
  
  if STDE==0
    % esfuerzo equivalente de Von Mises
    STVM = (1 / sqrt(2)) * sqrt( (PVA(1) - PVA(2))^ 2 + ...
           (PVA(1) - PVA(3))^2 + (PVA(2) - PVA(3))^2 );
  else
    % no aplica para deformaciones
    STVM = 0;
  end % endif

end