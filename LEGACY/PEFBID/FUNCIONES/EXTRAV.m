% Extraer un vector VEL() para el elemento IELE a partir de un vector del 
% sólido VGS() según la numeración de los GL dada en la tabla de incidencias
% INC()
function VEL = EXTRAV(VGL,INC,IELE,NGLE)
% Entradas: VGL():  vector del sólido (por ejemplo desplazamientos nodales)
%           INC():  tabla de incidencias
%           IELE:   identificador del elemento
%           NGLE:   número de grados de libertad asociados al elemento
%                   si NGLE=0, su valor se modifica al núm de columnas de INC()
% Salidas:  VEL():  vector del elemento IELE

  NGLT = size(VGL,1); % número de grados de libertad de la malla
  [NELE,NGLM] = size(INC);  % número de elementos y de GL máximo por elemento

  % control de error
  if (IELE > NELE) | (IELE <= 0)
    error('EXTRAV. %g es un número incorrecto del elemento',IELE);
  end % endif
  if NGLE > NGLM
    error('EXTRAV. %g es un número incorrecto grados de libertad por elemento', ...
           NGLE);
  end % endif
    
  if NGLE == 0; NGLE = NGLM; end % número de GL por elemento utilizado
  
  % procedimiento
  VEL = zeros(NGLE,1);
  for IGLE = 1:NGLE
    if INC(IELE, IGLE) ~= 0
      if INC(IELE, IGLE) <= NGLT
        VEL(IGLE, 1) = VGL(INC(IELE, IGLE), 1);
      end % endif
    end % endif
  end % endfor
    
end
