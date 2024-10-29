% área y volumen de un elemento finito bidimensional y tridimensional respec.
function ARVO = PBAVEL(XYE,TIPE,COER)
  % entrada: XYE():   coordenadas de los nudos del elemento
  %          TIPE:    tipo de elemento
  %          COER:    (opcional) control de error: 0:error, 1:no error
  % salida:  ARVO:    área o volumen del elemento finito
  
  if ~exist('COER');COER=0; end % endif
  
  switch TIPE
    case 201 % área de un elemento 2D triangular lineal
      ARVO = PBAVTR(XYE);
    case 202 % área de un elemento 2D cuadrilateral bilineal
      ARVO = PBAVCU(XYE);
    case 301 % volumen de un elemento 3D tetraédrico lineal
      ARVO = PBAVTE(XYE);
    case 302 % volumen de un elemento 3D hexaédrico bilineal
      % pendiente
    otherwise
      % pendiente
  end

  % control de errores  
  if ARVO <= 0.0 && COER==0
    error('PBAVEL: area o volumen cero o negativo del elemento.');
  end  

end

% ------------------------------------------------------------------------
% área de un elemento finito triangular
function AREA = PBAVTR(XYE)
  % entrada: XYE():   coordenadas de los nudos del elemento
  % salida:  ARVO:    área del elemento finito
  AREA =  XYE(1,1) * XYE(2,2) + XYE(2,1) * XYE(3,2) + XYE(3,1) * XYE(1,2) ...
        - XYE(1,2) * XYE(2,1) - XYE(2,2) * XYE(3,1) - XYE(3,2) * XYE(1,1) ;
  AREA = AREA/2;
end

% ------------------------------------------------------------------------
% área de un elemento finito cuadrilateral
function AREA = PBAVCU(XYE)
  % entrada: XYE():   coordenadas de los nudos del elemento
  % salida:  ARVO:    área del elemento finito
  AREA =  XYE(1,1) * XYE(2,2) + XYE(2,1) * XYE(3,2) ...
        + XYE(3,1) * XYE(4,2) + XYE(4,1) * XYE(1,2) ...
        - XYE(1,2) * XYE(2,1) - XYE(2,2) * XYE(3,1) ...
        - XYE(3,2) * XYE(4,1) - XYE(4,2) * XYE(1,1);
  AREA = AREA/2;
end

% ------------------------------------------------------------------------
% volumen de un elemento finito tetraédrico
function VOLU = PBAVTE(XYE)
  % entrada: XYE():   coordenadas de los nudos del elemento
  % salida:  VOLU:    volumen del elemento finito
  MAT = [ones(4,1), XYE];
  VOLU = det(MAT)/6;
 
end

