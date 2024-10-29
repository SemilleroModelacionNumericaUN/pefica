% imprimir archivo de los resultados para postproceso en GiD
function IMTIKZ(ADAD,NNUD,NELE,NNUE,XYZ,ELE,UCO,FUN,TIPN)
% entrada:  ADAD: nombre del archivo de datos sin extensión
%           NNUD: número de nudos
%           NELE: número de elementos
%           NNUE: número máximo de nudos por elemento
%           XYZ:  tabla de coordenadas de los nudos
%           ELE:  tabla de categoría y conectividades de los elementos
%           UCO:  tabla de desplazamientos conocidos
%           FUN:  tabla de fuerzas en los nudos
%           TIPN: opciones de la figura: 0=sin numeración, 1=numeración nudos
%                 2=numeración elementos, 3=numeración nudos y elementos.

  TIKZ = strcat(ADAD,'.tex'); % nombre archivo tex con grafico en form tikz
  FIDE = fopen(TIKZ,'w'); % abrir archivo y establecer identificador

  % factor de escala del papel y ajuste de escala de las coordenadas
  XMAX=max(XYZ(:,1)); XMIN=min(XYZ(:,1));
  YMAX=max(XYZ(:,2)); YMIN=min(XYZ(:,2));
  XDIF=XMAX-XMIN; YDIF=YMAX-YMIN;
  XLET=12; % ancho máximo útil del papel carta en cm
  YLET=24; % altura máxima útil del papel carta en cm
  if XLET>YLET
    FLET= XLET/XDIF;
  else
    FLET= XLET/XDIF;
  end
  
  % preambulo y iniciación del ambiente tikz
  fprintf(FIDE,'\\documentclass{standalone} \n');
  fprintf(FIDE,'\\usepackage[utf8]{inputenc} \n');
  fprintf(FIDE,'\\usepackage{tikz} \n');
  fprintf(FIDE,'\\begin{document} \n');
  fprintf(FIDE,'\\begin{tikzpicture} \n');
 
  fprintf(FIDE,'%% estilos de linea y relleno \n');
  fprintf(FIDE,'\\tikzstyle{carga} = [ultra thick,latex-]  \n');
  
  % definición dibujo de apoyo de segundo genero
  fprintf(FIDE,'%% definicion apoyo de segundo genero \n');
  fprintf(FIDE,'%% #1: ubicación del apoyo \n');
  fprintf(FIDE,'%% #2: angulo de rotacion \n ');
  fprintf(FIDE,'\\newcommand{\\apoyoseg}[2]{ \n');
  fprintf(FIDE,'\\coordinate (O) at #1; \n');
	fprintf(FIDE,'\\begin{scope}[rotate around={#2:(O)},scale=0.4] \n');
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
	fprintf(FIDE,'\\begin{scope}[rotate around={#2:(O)},scale=0.4] \n');
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
  
  % abrir un entorno general del dibujo para ajustar el cambio a escala
  % del papel a las coordenadas de los nudos
  fprintf(FIDE,'%% -------------------------------------- \n');
  fprintf(FIDE,'\\begin{scope}[scale=%f,font=\\footnotesize] \n',FLET);
  fprintf(FIDE,'%% -------------------------------------- \n');
  
  % dibujar malla de elementos
  
  if NNUE>2 
    % problemas con elementos trianguales y cuadrilaterales bidimensionales
    fprintf(FIDE,'%% dibujar elementos \n');
    fprintf(FIDE,'\\tikzstyle{elem}=[thin,draw=black]; \n');
    fprintf(FIDE,'\\tikzstyle{mat1}=[fill=black!10]; \n');
    fprintf(FIDE,'\\tikzstyle{mat2}=[fill=red!20]; \n');
    fprintf(FIDE,'\\tikzstyle{mat3}=[fill=green!30]; \n');
    fprintf(FIDE,'\\tikzstyle{mat4}=[fill=blue!40]; \n');
    fprintf(FIDE,'\\begin{scope}[elem] \n');
    for IELE = 1:NELE
      if NNUE==3 || (NNUE==4 && ELE(IELE,5)==0)
        % elemento triangular lineal
        fprintf(FIDE, ...
        '\\filldraw [mat%i] (%f,%f)--(%f,%f)--(%f,%f)--cycle; \n', ...
         ELE(IELE,1), ...
         XYZ(ELE(IELE,2),1),XYZ(ELE(IELE,2),2), ...
         XYZ(ELE(IELE,3),1),XYZ(ELE(IELE,3),2), ...
         XYZ(ELE(IELE,4),1),XYZ(ELE(IELE,4),2));
         % centroide
         XCEN=(XYZ(ELE(IELE,2),1)+XYZ(ELE(IELE,3),1)+XYZ(ELE(IELE,4),1))/3;
         YCEN=(XYZ(ELE(IELE,2),2)+XYZ(ELE(IELE,3),2)+XYZ(ELE(IELE,4),2))/3;
      else
        % elemento cuadrilateral bilineal
        fprintf(FIDE, ...
        '\\filldraw[mat%i] (%f,%f)--(%f,%f)--(%f,%f)--(%f,%f)--cycle; \n', ...
         ELE(IELE,1), ...
         XYZ(ELE(IELE,2),1),XYZ(ELE(IELE,2),2), ...
         XYZ(ELE(IELE,3),1),XYZ(ELE(IELE,3),2), ...
         XYZ(ELE(IELE,4),1),XYZ(ELE(IELE,4),2), ...
         XYZ(ELE(IELE,5),1),XYZ(ELE(IELE,5),2));
         % centroide
         XCEN=(XYZ(ELE(IELE,2),1)+XYZ(ELE(IELE,3),1)+XYZ(ELE(IELE,4),1)+...
               XYZ(ELE(IELE,5),1))/4;
         YCEN=(XYZ(ELE(IELE,2),2)+XYZ(ELE(IELE,3),2)+XYZ(ELE(IELE,4),2)+...
               XYZ(ELE(IELE,5),2))/4;
      end %endif
      if TIPN==2 || TIPN==3
        % numeración de los elementos
        fprintf(FIDE,'\\node at (%f,%f) {%i}; \n',XCEN,YCEN,IELE);
      end %endif  
    end % endfor
    fprintf(FIDE,'\\end{scope} \n');
  
  else
    % problemas de barras 2D
    fprintf(FIDE,'%% dibujar elementos \n');
    fprintf(FIDE,'\\tikzstyle{elem}=[draw=black,thin]; \n');
    fprintf(FIDE,'\\tikzstyle{nudo}=[midway,above]; \n');
    fprintf(FIDE,'\\begin{scope}[elem] \n');
    for IELE = 1:NELE
      fprintf(FIDE,...
      '\\draw (%f,%f)--(%f,%f) node[nudo] {%i}; \n', ...
       XYZ(ELE(IELE,2),1),XYZ(ELE(IELE,2),2), ...
       XYZ(ELE(IELE,3),1),XYZ(ELE(IELE,3),2), IELE);
    end % endfor
    fprintf(FIDE,'\\end{scope} \n');
    
  end %endif
  
  % dibujar nudos
  if TIPN==1 || TIPN==3
    fprintf(FIDE,'%% dibujar nudos \n');
    fprintf(FIDE,'\\tikzstyle{nudo}=[fill=black,above right]; \n');
    fprintf(FIDE,'\\def \\r{0.05}; \n');
    fprintf(FIDE,'\\begin{scope}[nudo] \n');
    for INUD = 1:NNUD
      fprintf(FIDE, ...
      '\\fill (%f,%f) circle (\\r) node {%i}; \n', ...
       XYZ(INUD,1),XYZ(INUD,2), INUD);
    end %endfor
    fprintf(FIDE,'\\end{scope} \n');
  end %endif
  
  % dibujar apoyos
  fprintf(FIDE,'%% dibujar apoyos \n');
  [NUCO,CUCO] = size(UCO);
  for IUCO = 1:NUCO
    if UCO(IUCO,2)==1 && UCO(IUCO,3)==1
      % apoyo de segundo género
      fprintf(FIDE,'\\apoyoseg{(%f,%f)}{0} \n',...
      XYZ(UCO(IUCO,1),1),XYZ(UCO(IUCO,1),2));
    elseif UCO(IUCO,2)==0 && UCO(IUCO,3)==1
     % apoyo de primer género, restrigido en y
      fprintf(FIDE,'\\apoyopri{(%f,%f)}{0} \n',...
      XYZ(UCO(IUCO,1),1),XYZ(UCO(IUCO,1),2));    
    elseif UCO(IUCO,2)==1 && UCO(IUCO,3)==0
     % apoyo de primer género, restrigido en x
      fprintf(FIDE,'\\apoyopri{(%f,%f)}{90} \n',...
      XYZ(UCO(IUCO,1),1),XYZ(UCO(IUCO,1),2));    
    end %endif
  end %endfor IUCO
  
  % dibujar cargas puntuales
  fprintf(FIDE,'%% dibujar cargas puntuales \n');
  NFUN = size(FUN,1);
  for IFUN = 1:NFUN
    if FUN(IFUN,2)~=0 % carga en x
      fprintf(FIDE,'\\cargapun{(%f,%f)}{%f}{%f}{1}{0}{0}{above} \n',...
      XYZ(FUN(IFUN,1),1), XYZ(FUN(IFUN,1),2), FUN(IFUN,2), sign(FUN(IFUN,2)));
    end %endif
    if FUN(IFUN,3)~=0 % carga en y
      fprintf(FIDE,'\\cargapun{(%f,%f)}{%f}{%f}{0}{1}{0}{above} \n',...
      XYZ(FUN(IFUN,1),1), XYZ(FUN(IFUN,1),2), FUN(IFUN,3), sign(FUN(IFUN,3)));
    end %endif
  end %endfor
  
  % dibujar cotas
  fprintf(FIDE,'%% dibujar cotas \n');
  fprintf(FIDE,'\\cotahori{(%f,%f)}{(%f,%f)}{%f}{-1}{-0.5}{-0.2} \n',...
          XMIN,YMIN,XMAX,YMIN,XMAX-XMIN);
  fprintf(FIDE,'\\cotavert{(%f,%f)}{(%f,%f)}{%f}{-1}{-0.5}{-0.2} \n',...
          XMIN,YMIN,XMIN,YMAX,YMAX-YMIN);  
    
  
  % cerrar un entorno general del dibujo
  fprintf(FIDE,'%% -------------------------------------- \n');
  fprintf(FIDE,'\\end{scope}');
  fprintf(FIDE,'%% -------------------------------------- \n');
  
  % finalización
  fprintf(FIDE,'\\end{tikzpicture} \n');
  fprintf(FIDE,'\\end{document} \n');
  
  
  status = fclose(FIDE);

end