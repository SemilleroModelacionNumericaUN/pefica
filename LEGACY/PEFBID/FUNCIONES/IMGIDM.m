% imprimir archivo de la malla para postproceso en GiD
function IMGIDM(ADAD,NNUD,NELE,NNUE,XYZ,ELE)
% entrada:  ADAD: nombre del archivo de datos sin extensión
%           NNUD: número de nudos
%           NELE: número de elementos
%           NNUE: número máximo de nudos por elemento
%           XYZ:  tabla de coordenadas de los nudos
%           ELE:  tabla de categoría y conectividades de los elementos
            
  % tipo de elemento finito bidimensional de primer orden
  if NNUE==3; ELTI = 'Triangle'; end;
  if NNUE==4; ELTI = 'Quadrilateral'; end;
  
  GIDM = strcat(ADAD,'.gid.msh'); % nombre archivo GiD post de la malla
  FIDE = fopen(GIDM,'w'); % abrir archivo y establecer identificador
  fprintf(FIDE,'### \n');
  fprintf(FIDE,'# PEFICA-Octave postproceso para GiD \n');
  fprintf(FIDE,'# \n');
  fprintf(FIDE,'MESH dimension %3.0f   Elemtype %s   Nnode %2.0f \n \n', ...
          2,ELTI,NNUE);
  % coordenadas de los nudos
  fprintf(FIDE,'coordinates \n');
  TEM = [1:NNUD;XYZ'];
  fprintf(FIDE,'%6i %+10.4e %+10.4e \n',TEM);
  fprintf(FIDE,'end coordinates \n \n');
  
  % conectividades y categoría de los elementos
  fprintf(FIDE,'elements \n');
  for IELE=1:NELE
    fprintf(FIDE,'%6i ',IELE); % imprimir en archivo IELE
    for INUE=1:NNUE
      % establecer cuarto nudo de triángulo repitiendo el último nudo
      if ELE(IELE,INUE+1)==0; ELE(IELE,INUE+1)=ELE(IELE,INUE); end;
      % imprimir en archivo en el orden NUDI NUDJ NUDK NUDL
      fprintf(FIDE,'%6i ',ELE(IELE,INUE+1));
    end % endfor INUE
    fprintf(FIDE,'%6i ',ELE(IELE,1)); % imprimir en archivo ICAT
    fprintf(FIDE,'\n');
  end % endfor IELE
  fprintf(FIDE,'end elements \n \n');
  status = fclose(FIDE);

end