% presentar en pantalla una matriz para ser editada en latex
function MTXTEX(MTX,FORM)
  % entrada: MTX: matriz
  %          FORM: cadena de caractéres que indica el formato
  %                ejemplo '%8.4e' para formato exponencial
  %                        '%8.4d' para formato decimal
  %                        '%+7.4g' para formato compacto con signo
  FOR1 = strcat(FORM,' \\\\ \n');
  FOR2 = strcat(FORM,' &  ');
  [FMTX,CMTX] = size(MTX);
  fprintf('\n')
  fprintf('\\begin{bmatrix}\n')
  for IMTX=1:FMTX
    for JMTX=1:CMTX
      if JMTX==CMTX
        fprintf(FOR1, MTX(IMTX,JMTX));
      else
        fprintf(FOR2, MTX(IMTX,JMTX));
      end % endif
    end % endfor CMTX
  end % endfor FMTX
  fprintf('\\end{bmatrix}\n')
end