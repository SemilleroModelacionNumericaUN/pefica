% Características del tipo de elemento finito
function [NUEL] = PELEME(TIPE)
  % Entrada:
  % TIPE:  código del tipo del elemento
  %       
  % Salida:
  % NUEL:  número de nudos del elemento

  switch TIPE
    case 101 % elemento de fuerza axial unidimensional lineal de continuidad c0
      NUEL = 2;
    case 102 % elemento de fuerza axial undimensional cuadrático de cont c0
      NUEL = 3;
    case 111 % elemento de flexión undimensional cúbico de continuidad c1
      NUEL = 2;
    otherwise
      error(['PELEME. El identificador %g no corresponde a un tipo de ' ...
            'elemento finito de la libreria'],TIPE);
  end
 
end
