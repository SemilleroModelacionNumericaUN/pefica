% Su primera tarea es crear tabla o matriz de grados de libertad por nudo
% a partir de la tabla de desplazamientos conocidos de algunos nudos.
% Su segunda tarea es crear el subvector de desplazamientos conocidos.
% 
function [MGL,UBB,NGLN,NGLC] = NGLUCO(UTC,NNUD)
  % entrada:  UTC():  tabla de desplazamientos conocidos en algunos nudos
  %           NNUD:   número de nudos de la malla
  % salida:   MGL():  tabla de grados de libertad por nudo
  %           UBB():  subvector de desplazamientos conocidos
  %           NGLN:   número de GL por nudo
  %           NGLC:   número de GL conocidos
  
  [FUTC,CUTC] = size(UTC);  % identificar número de nudos y 2 veces GL por nudo
  NGLN = (CUTC-1)/2; % número de GL por nudo
  NGLT = NNUD*NGLN; % número total de GL
  MGL = zeros(NNUD,NGLN,'int32'); % definición de tamaño y tipo para MGL()
  TEM = zeros(NGLT,1); % definir vector valor despl conoc y desconoc como 0
  
  % primera tarea: crear tabla con numeración de GL conocidos y 
  % crear de desplazamientos conocidos
  COGL = -1; % NNUD * NGLN - COGL: contador de GL conocidos
  for IUTC = 1:FUTC % ciclo por lista de nudos con desplazam conocido
    for JGLN = 1:NGLN % ciclo por GLs por nudo
      if UTC(IUTC,JGLN+1)==1 % desplazamiento conocido
        INUD = UTC(IUTC,1); % identificador del nudo
        if MGL(INUD, JGLN) == 0
          COGL = COGL + 1; % descuenta GL conocidos
          % crear tabla con numeración de GL conocidos
          MGL(INUD, JGLN) = NNUD * NGLN - COGL; % número del GL del desp conoc
          % crear subvector de desplazamientos conocidos
          TEM(MGL(INUD, JGLN),1) = UTC(IUTC,JGLN+NGLN+1); % valor despl conocido
        else
          printf('\n');
          TEXT = ...
          strcat('NGLNUA: condicion de borde impuesta dos veces al grado de',...
                 ' libertad %io del nudo %g.',...
                 '\n         Solo se considera la primera condición de ',...
                 'borde presentada en la tabla.');  
          warning(TEXT,JGLN,INUD);
        end % endif
      end % endif
    end % endfor JGLN
  end % endfor IUTC
  NGLC = COGL + 1; % número de GL conocidos
  NGLD = NGLT - NGLC; % número de GL desconocidos
  UBB = TEM(NGLD+1:NGLT,1); % crear subvector desplazamientos conocidos

  % segunda tarea: numeración de GL desconocidos
  DEGL = 0; % contador de GL desconocidos
  for INUD = 1:NNUD % ciclo por nudo
    for JGLN = 1:NGLN % ciclo por GL
      if MGL(INUD,JGLN) == 0
        DEGL = DEGL + 1; % contador del GL desconocidos
        MGL(INUD,JGLN) = DEGL;
      end % endif
    end % endfor IGLN
  end % endfor INUD
  
%  % segunda tarea: subvector de desplazamientos conocidos
%  UBB = zeros(NGLC,1);  % definición de tamaño del subvector de despl conoc
%  COGL = -1;
%  for IUTC = 1:FUTC % ciclo por lista de nudos con desplazam conocido
%    for JGLN = 1:NGLN % ciclo por GLs por nudo
%      if UTC(IUTC,JGLN+1)==1 % desplazamiento conocido
%        COGL = COGL + 1; % descuenta GL conocidos
%        UBB(NGLC-COGL, 1) = UTC(IUTC,JGLN+NGLN+1); % valor del despl conocido
%      end % endif
%    end % endfor JGLN
%  end % endfor IUTC

end