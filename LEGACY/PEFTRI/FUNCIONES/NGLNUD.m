% tabla o matriz de grados de libertad por nudo
function [MGL] = NGLNUD(UTE,TIPO)
  % entrada:  UTE():  tabla de desplazamientos conocidos extendida
  %           TIPO:   indicador tipo de numeración de los GL conocidos
  %                   =0: los GL conocidos son iguales a cero (0)
  %                   =1: los GL conocidos se numeran después de todos
  %                       los GL desconocidos.
  % salida:   MGL():  tabla de grados de libertad por nudo
  
  [NNUD,NGLN] = size(UTE);  % identificar número de nudos y 2 veces GL por nudo
  NGLN = NGLN/2; % GL por nudo
  MGL = zeros(NNUD,NGLN,'int64'); % definición de tamaño y tipo para MGL()
  
  switch TIPO
    case 0  % indicar con cero(0) los GL conocidos
      DEGL = 0; % contador de GL desconocidos
      for IMGL = 1:NNUD
        for JMGL = 1:NGLN
          if UTE(IMGL, JMGL) == 0
              DEGL = DEGL + 1;
              MGL(IMGL, JMGL) = DEGL;
          else
              MGL(IMGL, JMGL) = 0;
          end % endif
        end % endfor
      end % endfor
    case 1   % numerar al final los GL conocidos
      DEGL = 0; % contador de GL desconocidos
      COGL = -1; % NNUD * NGLN - COGL: contador de GL conocidos
      for IMGL = 1:NNUD
        for JMGL = 1:NGLN
          if UTE(IMGL, JMGL) == 0
              DEGL = DEGL + 1;
              MGL(IMGL, JMGL) = DEGL;
          else
              COGL = COGL + 1;
              MGL(IMGL, JMGL) = NNUD * NGLN - COGL;
          end % endif
        end % endfor
      end % endfor
    end % endswitch


end
