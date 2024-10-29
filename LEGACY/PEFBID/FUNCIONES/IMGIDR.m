% imprimir archivo de los resultados para postproceso en GiD
function IMGIDR(ADAD,NNUD,NELE,NNUE,NGAU,UXY,FXY,SRE,ERE)
% entrada:  ADAD: nombre del archivo de datos sin extensión
%           NNUD: número de nudos
%           NELE: número de elementos
%           NNUE: número máximo de nudos por elemento
%           NGAU: número máximo de puntos de Gauss en un elemento
%           UXY:  tabla de desplazamientos de los nudos
%           FXY:  tabla de desplazamientos de los nudos
%           SRE:  tabla de los esfuerzos en los elementos
%           ERE:  tabla de las deformaciones en los elementos
            
  % tipo de elemento finito bidimensional de primer orden
  if NNUE==3; ELTI = 'Triangle'; end;
  if NNUE==4; ELTI = 'Quadrilateral'; end;
  
  GIDM = strcat(ADAD,'.gid.res'); % nombre archivo GiD post de los resultados
  FIDE = fopen(GIDM,'w'); % abrir archivo y establecer identificador
  
  fprintf(FIDE,'Gid Post Results File 1.0 \n');
  fprintf(FIDE,'### \n');
  fprintf(FIDE,'# PEFICA-Octave postproceso para GiD \n');
  fprintf(FIDE,'# \n');
  fprintf(FIDE,'GaussPoints "GP" Elemtype %s \n',ELTI);
  fprintf(FIDE,'Number of Gauss Points: %i \n',NGAU);
  fprintf(FIDE,'Natural Coordinates: Internal \n');
  fprintf(FIDE,'end gausspoints \n');
  fprintf(FIDE,'# \n');
  
  
  % un solo tiempo y paso de carga
  %  STEP=1;
  
  
  % ciclo de pasos de carga
  % --------------------------
  UXYT=UXY;
  FXYT=FXY;
  SRET=SRE;
  ERET=ERE;
  NSTEP=1; % NUMERO DE PASOS INVENTADO
  more off
  for STEP=1:NSTEP
  % FUNCION INVENTADA
  if NSTEP==1;
    TIME=1;
  else
    TIME=sin(2*pi*STEP/NSTEP);
    warning('paso de carga: %6i',STEP);
  end
  UXY=TIME*UXYT;
  FXY=TIME*FXYT;
  SRE=[SRET(:,1:2),TIME*SRET(:,3:9)];
  ERE=[ERET(:,1:2),TIME*ERET(:,3:8)];
  % --------------------------
  
  
  
  % desplazamientos de los nudos
  fprintf(FIDE,'Result "Displacement" "Load Analysis" %6i Vector OnNodes \n', ...
          STEP);
  fprintf(FIDE,'ComponentNames "UX", "UY" \n');
  fprintf(FIDE,'Values \n');
  TEM = [1:NNUD;UXY'];
  fprintf(FIDE,'%6i %+15.6e %+15.6e \n',TEM)
  fprintf(FIDE,'End Values \n');
  fprintf(FIDE,'# \n');
  
  % fuerzas en los nudos
  fprintf(FIDE,'Result "Forces" "Load Analysis" %6i Vector OnNodes \n',STEP);
  fprintf(FIDE,'ComponentNames "FX", "FY" \n');
  fprintf(FIDE,'Values \n');
  TEM = [1:NNUD;FXY'];
  fprintf(FIDE,'%6i %+15.6e %+15.6e \n',TEM)
  fprintf(FIDE,'End Values \n');
  fprintf(FIDE,'# \n');
  
  % esfuerzos en los elementos
  fprintf(FIDE,'Result "Stress" "Load Analysis" %6i Vector OnGaussPoints "GP" \n',...
          STEP);
  fprintf(FIDE,'ComponentNames "STXX", "STYY", "STXY" \n');
  fprintf(FIDE,'Values \n');
  NRES = size(SRE,1);
  JELE = 0;
  for IRES=1:NRES
    if SRE(IRES,1)~=JELE
      fprintf(FIDE,'%6i %+15.6e %+15.6e %+15.6e \n', SRE(IRES,1),SRE(IRES,3:5)');
    else
      fprintf(FIDE,'       %+15.6e %+15.6e %+15.6e \n', SRE(IRES,3:5)');
    end % endif
    JELE = SRE(IRES,1);
  end %endfor IRES
  fprintf(FIDE,'End Values \n');
  fprintf(FIDE,'# \n');
  
  % esfuerzos principales en los elementos
  fprintf(FIDE,'Result "Principal Stress" "Load Analysis" %6i Vector OnGaussPoints "GP" \n',...
          STEP);
  fprintf(FIDE,'ComponentNames "STP1", "STP2", "STP3" \n');
  fprintf(FIDE,'Values \n');
  NRES = size(SRE,1);
  JELE = 0;
  for IRES=1:NRES
    if SRE(IRES,1)~=JELE
      fprintf(FIDE,'%6i %+15.6e %+15.6e %+15.6e \n', SRE(IRES,1),SRE(IRES,6:8)');
    else
      fprintf(FIDE,'       %+15.6e %+15.6e %+15.6e \n', SRE(IRES,6:8)');
    end % endif
    JELE = SRE(IRES,1);
  end %endfor IRES
  fprintf(FIDE,'End Values \n');
  fprintf(FIDE,'# \n');

  % deformaciones en los elementos
  fprintf(FIDE,'Result "Strain" "Load Analysis" %6i Vector OnGaussPoints "GP" \n',...
          STEP);
  fprintf(FIDE,'ComponentNames "EPXX", "EPYY", "EPXY" \n');
  fprintf(FIDE,'Values \n');
  NRES = size(ERE,1);
  JELE = 0;
  for IRES=1:NRES
    if ERE(IRES,1)~=JELE
      fprintf(FIDE,'%6i %+15.6e %+15.6e %+15.6e \n', ERE(IRES,1),ERE(IRES,3:5)');
    else
      fprintf(FIDE,'       %+15.6e %+15.6e %+15.6e \n', ERE(IRES,3:5)');
    end % endif
    JELE = ERE(IRES,1);
  end %endfor IRES
  fprintf(FIDE,'End Values \n');
  fprintf(FIDE,'# \n');
  
  % deformaciones principales en los elementos
  fprintf(FIDE,'Result "Principal Strain" "Load Analysis" %6i Vector OnGaussPoints "GP" \n',...
          STEP);
  fprintf(FIDE,'ComponentNames "EPP1", "EPP2", "EPP3" \n');
  fprintf(FIDE,'Values \n');
  NRES = size(ERE,1);
  JELE = 0;
  for IRES=1:NRES
    if ERE(IRES,1)~=JELE
      fprintf(FIDE,'%6i %+15.6e %+15.6e %+15.6e \n', ERE(IRES,1),ERE(IRES,6:8)');
    else
      fprintf(FIDE,'       %+15.6e %+15.6e %+15.6e \n', ERE(IRES,6:8)');
    end % endif
    JELE = ERE(IRES,1);
  end %endfor IRES
  fprintf(FIDE,'End Values \n');
  fprintf(FIDE,'# \n');

  % otros resultados en los elementos
  fprintf(FIDE,'Result "Other results" "Load Analysis" %6i Scalar OnGaussPoints "GP" \n',...
          STEP);
  % STVM: esfuerzo de Von Mises
  fprintf(FIDE,'ComponentNames "STVM" \n');
  fprintf(FIDE,'Values \n');
  NRES = size(SRE,1);
  JELE = 0;
  for IRES=1:NRES
    if SRE(IRES,1)~=JELE
      fprintf(FIDE,'%6i %+15.6e \n', SRE(IRES,1),SRE(IRES,9)');
    else
      fprintf(FIDE,'       %+15.6e \n', SRE(IRES,9)');
    end % endif
    JELE = SRE(IRES,1);
  end %endfor IRES
  fprintf(FIDE,'End Values \n');
  fprintf(FIDE,'# \n');

  % --------------------
  end % endfor STEP
  % --------------------
  
  status = fclose(FIDE);

end