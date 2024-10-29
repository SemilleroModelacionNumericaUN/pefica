% esfuerzos y direcciónes principales a partir del vector de esfuerzos 
% en el plano
function [MPR,TPR,STVM] = TRPRIN(SXY,POIS,TPBI,STDE)
% entradas:
% SXY(): vector de esfuerzos o deformaciones en la base xy
% POIS:  relación de Poisson
% TPBI:  tipo de problema bidimen: 20:plano de esfuerzos, 21:plano de deformacion
% STDE:  identificador del tipo de calculo: 0:cal esfuerzos, 1:cal deformaciones
%
% salidas:
% MPR(): vector de esfuerzos principales
% TPR(): vector de direcciones principales (pendiente)
%       TPR(1,1): ángulo en grados conformado entre la dirección principal 1 y el eje x.
%       TPR(2,1): ángulo en grados conformado entre la dirección principal 2 y el eje x.
%       TPR(3,1): ángulo en grados conformado entre la dirección principal 3 y el eje x.
% STVM: esfuerzo equivalente de Von Mises
    
  MPR = zeros(3,1); TPR = zeros(3,1); % dimensionamiento de vectores    
  
  % precalculos
  S1 = SXY(1, 1) + SXY(2, 1);
  S2 = (SXY(1, 1) - SXY(2, 1)) ^ 2;
  S3 = 4 * (SXY(3, 1) ^ 2);
  % esfuerzos o deformaciones principales
  MPR(1, 1) = 0.5 * (S1 + sqrt(S2 + S3));
  MPR(3, 1) = 0.5 * (S1 - sqrt(S2 + S3));
  
  % 2o esfuerzo o deformación principal diferentes de cero
  if TPBI==1 && STDE==0; MPR(2, 1) = POIS*S1; end % 2o esf.pr.cond.pl deformac.
  if TPBI==0 && STDE==1; MPR(2, 1) = -POIS*(1-POIS)*S1; end % 2a def.pr.cond.pl.esfuerz.
  % la 2a def.pr.cond.pl. de deformaciones y el 2o esf.pr. en cond.plana 
  % esfuerzos son iguales a cero : MPR(2, 1) = 0 
 
% ordenar esfuerzos principales de mayor a menor
  for IMPR = 2:3
    if MPR(IMPR, 1) > MPR(IMPR - 1, 1)
      TEMP = MPR(IMPR - 1, 1);
      MPR(IMPR - 1, 1) = MPR(IMPR, 1);
      MPR(IMPR, 1) = TEMP;
    end % endif
  end % endfor
%  
%  'direcciones principales (pendiente de corregir)
%  For i = 1 To 2
%      If SXY(3, 1) = 0 Then
%          If (SXY(1, 1) - MPR(i, 1)) = 0 Then
%              TPR(i, 1) = 0
%          Else
%              TPR(i, 1) = 90
%          End If
%      Else
%      
%          TPR(i, 1) = Atn(-(SXY(1, 1) - MPR(i, 1)) / SXY(3, 1))
%          TPR(i, 1) = PBREDO(TPR(i, 1) * 180 / Pi, 8)
%      End If
%  Next i

  if STDE==0
    % esfuerzo equivalente de Von Mises
    STVM = (1 / sqrt(2)) * sqrt((MPR(1, 1) - MPR(2, 1)) ^ 2 + ...
           (MPR(1, 1) - MPR(3, 1)) ^ 2 + (MPR(2, 1) - MPR(3, 1)) ^ 2);
  else
    % no aplica para deformaciones
    STVM = 0;
  end % endif

end