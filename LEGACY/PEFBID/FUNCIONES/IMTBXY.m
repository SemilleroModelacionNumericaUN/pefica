% imprimir tabla de resultados ordenada por componentes x,y
% en la ventana de comandos, excluyendo los ceros
function IMTBXY(MXY,TIT1,TIT2)
   % entrada:  MXY:  matriz de resultados
   %           TIT1: formato del título de la tabla
   %           TIT2: formato del rótulo de las columnas de la tabla 
  
  [NMXY,CMXY] = size(MXY);
  if CMXY==2; TIT3 = '%6i %+10.4e %+10.4e \n'; end;
  if CMXY==3; TIT3 = '%6i %+10.4e %+10.4e %+10.4e \n'; end;
  fprintf(TIT1);
  fprintf(TIT2);
  for IMXY=1:NMXY
    SUMA = sum(abs(MXY(IMXY,:)));
    if SUMA ~= 0
      fprintf(TIT3,IMXY,MXY(IMXY,:));
    end % endif
  end % endfor

end