% esfuerzos o deformaciones principales a partir de la matriz columna de 
% esfuerzos o deformaciones en el plano
function [MPR,STVM] = TRPRIN(SXY,POIS,TIPR,STDE)
% entradas:
% SXY(): vector de esfuerzos o deformaciones en la base xy
% POIS:  relación de Poisson
% TIPR:  tipo de problema bidimen: 20:plano de esfuerzos, 21:plano de deformacion
% STDE:  identificador del tipo de calculo: 0:cal esfuerzos, 1:cal deformaciones
%
% salidas:
% MPR(): vector de esfuerzos principales
% STVM: esfuerzo equivalente de Von Mises
    
  MPR = zeros(3,1); % dimensionamiento de vectores

  % modificar la deformación angular de notación
  % de ingeniería a en not. científica
  if STDE==1
    SXY(3,1)=0.5*SXY(3,1);
  end
  
  % precalculos
  S1 = SXY(1, 1) + SXY(2, 1);
  S2 = (SXY(1, 1) - SXY(2, 1)) ^ 2;
  S3 = 4 * (SXY(3, 1) ^ 2);
  
  % esfuerzos o deformaciones principales
  MPR(1, 1) = 0.5 * (S1 + sqrt(S2 + S3));
  MPR(3, 1) = 0.5 * (S1 - sqrt(S2 + S3));
  % la 2a def.pr.cond.pl. de deformaciones y el 2o esf.pr. en cond.plana 
  % esfuerzos son iguales a cero
  MPR(2, 1) = 0;
  
  % 2o esfuerzo o deformación principal diferentes de cero
  if TIPR==21 && STDE==0 % 2o esf.pr.cond.pl deformac.
    MPR(2, 1) = POIS*S1;
  end
  if TIPR==20 && STDE==1 % 2a def.pr.cond.pl.esfuerz.
    MPR(2, 1) = -POIS*S1/(1-POIS);
  end
 
  % ordenar esfuerzos o deformaciones principales de mayor a menor
  % es decir sigma_3 < sigma_2 < sigma_1
  MPR = sort(MPR,'descend');

  if STDE==0
    % esfuerzo equivalente de Von Mises
    STVM = (1 / sqrt(2)) * sqrt((MPR(1, 1) - MPR(2, 1)) ^ 2 + ...
           (MPR(1, 1) - MPR(3, 1)) ^ 2 + (MPR(2, 1) - MPR(3, 1)) ^ 2);
  else
    % no aplica para deformaciones
    STVM = 0;
  end % endif

end