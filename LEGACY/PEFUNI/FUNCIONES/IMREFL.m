% imprimir resultados de problemas de barras sometidas a flexión
function IMREFL(IMPR,XYZ,ELE,UXY,FXY,REL,RIL,URI)
% entrada:  IMPR: opciones de impresión de resultados
%           XYZ: número de nudos de la malla
%           ELE:  tabla de conectividades de los elementos
%           UXY:  tabla de desplazamientos en los nudos
%           FXY:  tabla de fuerzas en los nudos
%           REL:  tabla de desplazam, rotaciones, cortante, momento
%                 en los nudos de cada elemento
%           RIL:  tabla de desplazamientos en el interior de cada elemento
%           URI:  índice que ubican los nudos de los elementos en RIL()
  
    NNUD = size(XYZ,1); % número de nudos
    NELE = size(ELE,1); % número de elementos

   % presentación de resultados en pantalla
    if (IMPR==1) || (IMPR==8) || (IMPR==9)
      fprintf('\n-------------------------------- \nResultados en los nudos');
      fprintf('\nDesplazamientos en los nudos \n[ INUD DESY ROTZ ]');
      [(1:NNUD)',UXY]
      fprintf('\nFuerzas en los nudos \n[ INUD FUEY MOMZ ]');
      [(1:NNUD)',FXY]
      fprintf('\nResultados en los elementos');
      fprintf('\n[ IELE DEYI ROZI DEYJ ROZJ FUYI MOZI FUYJ MOZJ ]');
      [(1:NELE)' REL]
    end % endif
    
    % presentación de resultados en gráficas de Octave
    if (IMPR==2) || (IMPR==8)  || (IMPR==9)  
      % desplazamientos en los nudos TEP(), y en los elementos RIL()
      TEM = [XYZ,UXY];
      TEP = sortrows(TEM,1);
      figure('Name','Desplazamiento');
      plot (TEP(:,1),TEP(:,2),'or',RIL(:,1),RIL(:,2),'r-');
      xlabel ('XPOS'); ylabel('DESY'); grid on;     
      % fuerza cortante
      figure('Name','Fuerza cortante');
      plot (RIL(:,1),RIL(:,3),'r-',RIL(URI,1),RIL(URI,3),'or');
      xlabel ('XPOS'); ylabel('VCOR'); grid on;
      % momento flector
      figure('Name','Momento flector');
      plot (RIL(:,1),RIL(:,4),'r-',RIL(URI,1),RIL(URI,4),'or');
      xlabel ('XPOS'); ylabel('MOME'); grid on;
    end % endif
    
% PENDIENTE
% dibujar geometría en TikZ LaTeX
%    if (IMPR==3) || (IMPR==9)
%      TINI = IMTIEM('\nDibujar de geometría en Tikz LaTex ',0);
%      % -----------------------------------------------------------------------
%      % construir archivo gráfico tikz para latex con geometría
%      ADAD = strcat('./DATOS/',ADAT);
%      TIPN = 3; % numerar nudos y elementos
%      IMTIKZ(ADAD,NNUD,NELE,XYZ,ELE,CAT,UCO,FUN,TIPN);
%    end %endif
 
end