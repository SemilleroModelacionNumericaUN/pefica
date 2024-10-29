% identifica el número de nudos de un elemento finito y de sus caras,
% y el número de puntos de Gauss recomendado a partir de su tipología
function [NUEL,NUCA,PGAU] = PBNUEL(TIPE)
% entradas:   TIPE:   id del tipo de elemento finito
% salidas:    NUEL:   número de nudos del elemento finito
%             NUCA:   número de nudos de una de las caras del elemento finito
%             PGAU:   número de puntos de Gauss 
  switch TIPE
  case 201  % triangular lineal
    NUEL = 3; NUCA = 2; PGAU = 1;
  case 202  % rectangular bilineal
    NUEL = 3; NUCA = 2; PGAU = 4;
  case 301  % tetraédrico lineal
    NUEL = 4; NUCA = 3; PGAU = 1;
  case 302  % hexaédrico bilineal
    NUEL = 8; NUCA = 4; PGAU = 8;
  otherwise
    error('PBNUEL. Tipo de elemento finito no identificado.');
  end % endswitch
  
end