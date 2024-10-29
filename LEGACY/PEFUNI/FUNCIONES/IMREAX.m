% imprimir resultados de problemas de barras sometidas a fuerza axial
function IMREAX(IMPR,XYZ,ELE,CAT,UCO,FUN,UXY,FXY,REL,RIL,ADAT)
% entrada:  IMPR: opciones de impresión de resultados
%           XYZ: número de nudos de la malla
%           ELE:  tabla de conectividades de los elementos
%           CAT:  tabla de categorias
%           UCO:  tabla de desplazamientos conocidos
%           FUN:  tabla de fuerzas en los nudos
%           UXY:  tabla de desplazamientos en los nudos
%           FXY:  tabla de fuerzas en los nudos
%           REL:  tabla de resultados por elemento y por nudo: defor, esfuer, axial
%           RIL:  tabla de desplazamientos en el interior de elementos cuadráticos
%           ADAT:  nombre del archivo de entrada de datos sin extensión
  
    NNUD = size(XYZ,1); % número de nudos
    [NELE,NEMX] = size(ELE); % número de elementos
    NEMX = NEMX - 1 ; % número máximo de nudos de un elemento

    % presentación de resultados en pantalla
    if (IMPR==1) || (IMPR==8) || (IMPR==9)
      fprintf('\n-------------------------------- \nResultados en los nudos');
      fprintf('\nDesplazamientos en los nudos \n[ INUD DESX ]');
      [(1:NNUD)',UXY]
      fprintf('\nFuerzas en los nudos \n[ INUD FUEX ]');
      [(1:NNUD)',FXY]
      fprintf('\nResultados en los elementos');
      fprintf('\n[ IELE DEFI DEFJ ESFI ESFJ NAXI NAXJ ]');
      [(1:NELE)' REL]
    end % endif
    
    % presentación de resultados en gráficas de Octave
    if (IMPR==2) || (IMPR==8) || (IMPR==9)
    
      % desplazamientos en los nudos y función lineal en elementos
      TEM = [XYZ,UXY];
      TEP = sortrows(TEM,1);
      figure('Name','Desplazamiento');
      if NEMX==2 % malla con elementos de 2 nudos como máximo
        plot (TEP(:,1),TEP(:,2),'or-');
      elseif NEMX==3 % malla con elementos de 3 nudos como máximo
        TER = sortrows(RIL,1); 
        plot (TEP(:,1),TEP(:,2),'or',TER(:,1),TER(:,2),'-r');
      endif
      xlabel ('XPOS'); ylabel('UDES'); grid on;
      % crear archivos con resultados
      %save('-ascii','./DATOS/temp0.mat','TEP');
      
      % resultados en los elementos
      TRES = ['DEFO';'ESFU';'NAXI'];
      for IRES = 1:2:5 % tipo de resultado elemental
        for IELE=1:NELE
          for IPOS=1:2
            TEM(2*IELE+IPOS-2,1) = XYZ(ELE(IELE,1+IPOS),1);
            TEM(2*IELE+IPOS-2,2) = REL(IELE,IRES+IPOS-1);
          end %endfor IPOS
        end %endfor IELE
        ICON = (IRES+1)/2;
        figure('Name',TRES(ICON,1:4));
        plot (TEM(:,1),TEM(:,2),'or-');
        xlabel ('XPOS'); ylabel(TRES(ICON,1:4)); grid on;
        % crear archivos con resultados
        IFIL = num2str(ICON);
        FILE = ['./DATOS/' 'temp' IFIL '.mat'];
        %save('-ascii',FILE,'TEM');
      end % endfor IRES      
      
    end % endif
    
    % dibujar geometría en TikZ LaTeX
    if (IMPR==3) || (IMPR==9)
      fprintf('\nDibujar de geometría en Tikz LaTex \n');
      % -----------------------------------------------------------------------
      % construir archivo gráfico tikz para latex con geometría
      ADAD = strcat('./DATOS/',ADAT);
      TIPN = 3; % numerar nudos y elementos
      IMTIKZ(ADAD,NNUD,NELE,XYZ,ELE,CAT,UCO,FUN,TIPN);
    end %endif
    
    % presentación de resultados promedio en los nudos en pantalla y en gráficas
    if (IMPR==4) || (IMPR==9)
      
      % valores promedio en los nudos de deformación, esfuerzo y fuerza axial
      [PRO] = PRONUD(NNUD,ELE,REL);
    
      % resultados promedio en los nudos en pantalla
      fprintf('\nResultados promedio en los nudos');
      fprintf('\n[ INUD DEFO ESFU NAXI ]');
      [(1:NNUD)',PRO]
      
      % resultados promedio en los nudos en gráficas de Octave
      % Utiliza función lineal en el interior de los elementos
      TRES = ['DEPR';'ESPR';'NAPR'];
      for IRES = 1:3 % tipo de resultado elemental
        TEM = [XYZ,PRO];
        TEP = sortrows(TEM,1);
        figure('Name',TRES(IRES,1:4));
        plot (TEP(:,1),TEP(:,IRES+1),'ob-');
        xlabel ('XPOS'); ylabel(TRES(IRES,1:4)); grid on;
      end % endfor IRES

    end % endif

end

% ----------------------------------------------------------------------------
% construye archivo en la sintaxis de TikZ de LaTeX para
% dibujar la red de elementos finitos en problemas unidimensionales
% de barras sometidas a fuerza axial
function IMTIKZ(ADAD,NNUD,NELE,XYZ,ELE,CAT,UCO,FUN,TIPN)
% entrada:  ADAD: nombre del archivo de datos sin extensión
%           NNUD: número de nudos
%           NELE: número de elementos
%           XYZ:  tabla de coordenadas de los nudos
%           ELE:  tabla de categoría y conectividades de los elementos
%           CAT:  tabla de categorias
%           UCO:  tabla de desplazamientos conocidos
%           FUN:  tabla de fuerzas en los nudos
%           TIPN: opciones de la figura: 0=sin numeración, 1=numeración nudos
%                 2=numeración elementos, 3=numeración nudos y elementos.
              
  TIKZ = strcat(ADAD,'.tex'); % nombre archivo tex con grafico en form tikz
  FIDE = fopen(TIKZ,'w'); % abrir archivo y establecer identificador

  % número máximo de nudos por elemento NUEM
  NCAT = size(CAT,1);
  NUEM = 0;
  for ICAT=1:NCAT
    [NUEL] = PELEME(CAT(ICAT,3));
    if NUEL > NUEM
      NUEM = NUEL;
    end % endif
  end % endfor
  
  % factor de escala del papel y ajuste de escala de las coordenadas
  XMAX=max(XYZ(:,1)); XMIN=min(XYZ(:,1));
  YMAX=0; YMIN=0;
  XDIF=XMAX-XMIN; YDIF=YMAX-YMIN;
  XLET=12; % ancho máximo útil del papel carta en cm
  YLET=24; % altura máxima útil del papel carta en cm
  if XLET>YLET
    FLET= XLET/XDIF;
  else
    FLET= XLET/XDIF;
  end
  % cambio a escala del papel de las coordenadas de los nudos
  XYZ = FLET.*XYZ;
  
  % preambulo y iniciación del ambiente tikz
  fprintf(FIDE,'\\documentclass{article} \n');
  fprintf(FIDE,'\\usepackage{tikz} \n');
  fprintf(FIDE,'\\begin{document} \n');
  fprintf(FIDE,'\\begin{center} \n');
  fprintf(FIDE,'\\begin{tikzpicture} \n');
 
  fprintf(FIDE,'%% estilos de linea y relleno \n');
  fprintf(FIDE,'\\tikzstyle{carga} = [ultra thick,latex-]  \n');
  
  % definición dibujo de apoyo de segundo genero
  fprintf(FIDE,'%% definicion apoyo de segundo genero \n');
  fprintf(FIDE,'%% #1: ubicación del apoyo \n');
  fprintf(FIDE,'%% #2: angulo de rotacion \n ');
  fprintf(FIDE,'\\newcommand{\\apoyoseg}[2]{ \n');
  fprintf(FIDE,'\\coordinate (O) at #1; \n');
	fprintf(FIDE,'\\begin{scope}[rotate around={#2:(O)}] \n');
	fprintf(FIDE, ...
  '\\fill [black!10](O) ++(-0.45,-0.433013) rectangle ++(0.9,-0.2); \n');
	fprintf(FIDE,'\\draw [thick] (O) ++(-0.45,-0.433013) -- ++(0.9,0); \n');
  fprintf(FIDE,'\\draw (O) -- ++(-0.25,-0.433013) -- ++(0.45,0) -- cycle; \n');
	fprintf(FIDE,'\\end{scope} \n } \n');
  % definición dibujo de apoyo de primer genero
  fprintf(FIDE,'%% definicion apoyo de primer genero \n');
  fprintf(FIDE,'%% #1: ubicación del apoyo \n');
  fprintf(FIDE,'%% #2: angulo de rotacion \n ');
  fprintf(FIDE,'\\newcommand{\\apoyopri}[2]{ \n');
	fprintf(FIDE,'\\coordinate (O) at #1; \n');
	fprintf(FIDE,'\\begin{scope}[rotate around={#2:(O)}] \n');
	fprintf(FIDE,...
  '\\fill [black!10](O) ++(-0.45,-0.433013) rectangle ++(0.9,-0.2); \n');
	fprintf(FIDE,'\\draw [thick] (O) ++(-0.45,-0.433013) -- ++(0.9,0); \n');
	fprintf(FIDE,'\\draw (O) ++(0,-0.216506) circle (0.216506); \n');
	fprintf(FIDE,'\\end{scope} \n } \n');
  
  % definición dibujo de carga puntual
  fprintf(FIDE,'%% definicion carga puntual \n');
  fprintf(FIDE,'%% #1: ubicación de la carga \n');
  fprintf(FIDE,'%% #2: rótulo de la carga \n');
  fprintf(FIDE,'%% #3=1: carga positiva, #3=-1: carga negativa \n');
  fprintf(FIDE,'%% #4=1,#5=0: carga en x, #4=0,#5=1: carga en y \n');
  fprintf(FIDE,'%% #6=0: carga entrando al nudo, #6=1: carga saliendo del nudo \n');
  fprintf(FIDE,'%% #7: ubicación del rótulo de la carga \n');
  fprintf(FIDE,'\\newcommand{\\cargapun}[7]{ \n');
	fprintf(FIDE,'\\path #1 ++(#6*#4,#6*#5) coordinate (O); \n');
	fprintf(FIDE,'\\draw [carga] (O) -- ++(-1.0*#3*#4,-1.0*#3*#5) \n');
  fprintf(FIDE,'node [#7] {#2}; \n } \n');
  
  % definición dibujo de cota horizontal
  fprintf(FIDE,'%% cota horizontal \n');
  fprintf(FIDE,'%% #1: coordenada punto inicial () \n');
  fprintf(FIDE,'%% #2: coordenada punto final () \n');
  fprintf(FIDE,'%% #3: rotulo de la cota \n');
  fprintf(FIDE,'%% #4: separación entre puntos y cota \n');
  fprintf(FIDE,'%% #5: separación entre puntos y inicio de marcas \n');
  fprintf(FIDE,'%% #6: separación entre cota y fin de marcas \n');
  fprintf(FIDE,'\\newcommand{\\cotahori}[6]{ \n');
  fprintf(FIDE,'\\path #1 ++(0,#4) coordinate (A); \n');
  fprintf(FIDE,'\\path #2 ++(0,#4) coordinate (B); \n');
  fprintf(FIDE,'\\draw [latex-latex] (A) -- (B) \n');
  fprintf(FIDE,'node [midway,fill=white] {#3}; \n');
  fprintf(FIDE,'\\path #1 ++(0,#5) coordinate (C); \n');
  fprintf(FIDE,'\\path #1 ++(0,#4+#6) coordinate (D); \n');
  fprintf(FIDE,'\\draw (C) -- (D); \n');
  fprintf(FIDE,'\\path #2 ++(0,#5) coordinate (C); \n');
  fprintf(FIDE,'\\path #2 ++(0,#4+#6) coordinate (D); \n');
  fprintf(FIDE,'\\draw (C) -- (D); \n } \n');

  % definición dibujo de cota vertical
  fprintf(FIDE,'%% cota vertical \n');
  fprintf(FIDE,'%% #1: coordenada punto inicial () \n');
  fprintf(FIDE,'%% #2: coordenada punto final () \n');
  fprintf(FIDE,'%% #3: rotulo de la cota \n');
  fprintf(FIDE,'%% #4: separación entre puntos y cota \n');
  fprintf(FIDE,'%% #5: separación entre puntos y inicio de marcas \n');
  fprintf(FIDE,'%% #6: separación entre cota y fin de marcas \n');
  fprintf(FIDE,'\\newcommand{\\cotavert}[6]{ \n');
  fprintf(FIDE,'\\path #1 ++(#4,0) coordinate (A); \n');
  fprintf(FIDE,'\\path #2 ++(#4,0) coordinate (B); \n');
  fprintf(FIDE,'\\draw [latex-latex] (A) -- (B) \n');
  fprintf(FIDE,'node [midway,fill=white] {#3}; \n');
  fprintf(FIDE,'\\path #1 ++(#5,0) coordinate (C); \n');
  fprintf(FIDE,'\\path #1 ++(#4+#6,0) coordinate (D); \n');
  fprintf(FIDE,'\\draw (C) -- (D); \n');
  fprintf(FIDE,'\\path #2 ++(#5,0) coordinate (C); \n');
  fprintf(FIDE,'\\path #2 ++(#4+#6,0) coordinate (D); \n');
  fprintf(FIDE,'\\draw (C) -- (D); \n } \n');
  
  % dibujar malla de elementos
  % problemas unidimensionales
  fprintf(FIDE,'%% dibujar elementos \n');
  fprintf(FIDE,'\\tikzstyle{elem}=[draw=black,thin]; \n');
  fprintf(FIDE,'\\tikzstyle{nudo}=[midway,above]; \n');
  fprintf(FIDE,'\\begin{scope}[elem] \n');
  for IELE = 1:NELE
    fprintf(FIDE,...
    '\\draw (%f,%f)--(%f,%f) node[nudo] {%i}; \n', ...
     XYZ(ELE(IELE,2),1),0, ...
     XYZ(ELE(IELE,3),1),0, IELE);
  end % endfor
  fprintf(FIDE,'\\end{scope} \n');
    
  % dibujar nudos
  if TIPN==1 || TIPN==3
    fprintf(FIDE,'%% dibujar nudos \n');
    fprintf(FIDE,'\\tikzstyle{nudo}=[fill=black,above right]; \n');
    fprintf(FIDE,'\\def \\r{0.05}; \n');
    fprintf(FIDE,'\\begin{scope}[nudo] \n');
    for INUD = 1:NNUD
      fprintf(FIDE, ...
      '\\fill (%f,%f) circle (\\r) node {%i}; \n', ...
       XYZ(INUD,1),0, INUD);
    end %endfor
  end %endif
  fprintf(FIDE,'\\end{scope} \n');
  
  % dibujar apoyos
  fprintf(FIDE,'%% dibujar apoyos \n');
  NUCO = size(UCO,1);
  for IUCO = 1:NUCO
    if UCO(IUCO,2)==1 && UCO(IUCO,3)==1
      % apoyo de segundo género
      fprintf(FIDE,'\\apoyoseg{(%f,%f)}{0} \n', ...
      XYZ(UCO(IUCO,1),1),0);
    elseif UCO(IUCO,2)==0 && UCO(IUCO,3)==1
     % apoyo de primer género, restrigido en y
      fprintf(FIDE,'\\apoyopri{(%f,%f)}{0} \n', ...
      XYZ(UCO(IUCO,1),1),0);    
    elseif UCO(IUCO,2)==1 && UCO(IUCO,3)==0
     % apoyo de primer género, restrigido en x
      fprintf(FIDE,'\\apoyopri{(%f,%f)}{90} \n', ...
      XYZ(UCO(IUCO,1),1),0);    
    end %endif
  end %endfor
  
  % dibujar cargas puntuales
  fprintf(FIDE,'%% dibujar cargas puntuales \n');
  NFUN = size(FUN,1);
  for IFUN = 1:NFUN
    if FUN(IFUN,2)~=0 % carga en x
      fprintf(FIDE,'\\cargapun{(%f,%f)}{%f}{%f}{1}{0}{0}{above} \n',...
      XYZ(FUN(IFUN,1),1), 0, FUN(IFUN,2), sign(FUN(IFUN,2)));
    end %endif
  end %endfor
  
  % dibujar cotas
  fprintf(FIDE,'%% dibujar cotas \n');
  fprintf(FIDE,'\\cotahori{(%f,%f)}{(%f,%f)}{%f}{-1}{-0.5}{-0.2} \n',...
          XMIN*FLET,YMIN*FLET,XMAX*FLET,YMIN*FLET,XMAX-XMIN);
    
  % finalización
  fprintf(FIDE,'\\end{tikzpicture} \n');
  fprintf(FIDE,'\\end{center} \n');
  fprintf(FIDE,'\\end{document} \n');
  
  status = fclose(FIDE);

end