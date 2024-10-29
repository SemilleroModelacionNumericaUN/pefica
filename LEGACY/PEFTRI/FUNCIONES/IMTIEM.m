% imprimir en la ventana de comandos un texto que indica el comienzo
% de un grupo de instrucciones y medir el tiempo al final
function TFIN = IMTIEM(TEXT,TINI)
% entrada:  TEXT: texto que se desea imprimir
%           TINI: tiempo inicial del grupo de instrucciones
% salida:   TFIN: tiempo al comienzo del grupo de instrucciones si TINI=0
%                 tiempo al final del grupo de instrucciones si TINI<>0

  if TINI==0
    % imprimir texto del comienzo de un grupo de instrucciones
    % y medir el tiempo inicial
    fprintf(TEXT);
    TFIN = clock(); % tiempo al comienzo de las instrucciones
  else
    % imprimir el tiempo empleado entre el comienzo y el final 
    % de un grupo de instrucciones
    TFIN= etime(clock(),TINI); % tiempo al final de las instrucciones
    fprintf('%s (%6.2f seg.) \n',TEXT,TFIN);
  end % endswitch
  % alternativa de presentación paso a paso de mensajes que solo funciona
  % en octave
  fflush(stdout);
  % presentación paso a paso de mensajes que funciona en matlab 
  %drawnow('expose');
  
end