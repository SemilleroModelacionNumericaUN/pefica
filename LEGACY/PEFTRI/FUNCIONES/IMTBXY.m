% imprimir tabla de resultados ordenada por componentes x,y,z
% en el archivo .tbl, excluyendo los ceros
function IMTBXY(ADAD,MXY,TIT1,TIT2)
   % entrada:   ADAD: nombre del archivo
   %            MXY:  matriz de resultados
   %            TIT1: formato del título de la tabla
   %            TIT2: formato del rótulo de las columnas de la tabla 
  
  TBRE = strcat(ADAD,'.tbl'); % nombre archivo GMSH post de los resultados
  FIDE = fopen(TBRE,'w'); % abrir archivo y establecer identificador
  
  [NMXY,CMXY] = size(MXY);
  if CMXY==2; TIT3 = '%6i %+10.4e %+10.4e \n'; end;
  if CMXY==3; TIT3 = '%6i %+10.4e %+10.4e %+10.4e \n'; end;
  fprintf(FIDE,TIT1);
  fprintf(FIDE,TIT2);
  for IMXY=1:NMXY
    SUMA = sum(abs(MXY(IMXY,:)));
    if SUMA ~= 0
      fprintf(FIDE,TIT3,IMXY,MXY(IMXY,:));
    end % endif
  end % endfor
  
  status = fclose(FIDE); % cierre de archivo .tbl

end