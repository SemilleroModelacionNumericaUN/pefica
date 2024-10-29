% imprimir archivo de los resultados para postproceso en GMSH
function IMGMSH(ADAD,NNUD,NELE,NNUE,NGAU,NCAT,XYZ,ELE,SUP,UXY,FXY,SRE,ERE,PRO)
% entrada:  ADAD: nombre del archivo de datos sin extensión
%           NNUD: número de nudos
%           NELE: número de elementos
%           NNUE: número máximo de nudos por elemento
%           NGAU: número máximo de puntos de Gauss en un elemento
%           NCAT: número de categorías (materiales y espesores)
%           XYZ:  tabla de coordenadas de los nudos
%           ELE:  tabla de conectividades de los elementos
%           SUP:  tabla de id de superficie asociada al elemento finito 
%           UXY:  tabla de desplazamientos de los nudos
%           FXY:  tabla de fuerzas en los nudos
%           SRE:  tabla de los esfuerzos en los elementos
%           ERE:  tabla de las deformaciones en los elementos
%           PRO:  1: dibuja esf y def en el interior de los elementos
%                 0: dibuja esf y def promedio en los nudos
  
  % crear archivo de opciones de presentación de resultados .pos.opt
  % ------------------------------------------------------------
  GMSH = strcat(ADAD,'.pos.opt'); % nombre archivo GMSH de datos
  FIDE = fopen(GMSH,'w'); % abrir archivo .pos.opt
  
  % mostrar solo la primera vista view[0] desplazamiento nodal
  % y establecer intervalos definidos y la malla sobre el resultado
  % número de vistas - 1
  NVIE=14; % para PRO=0 o PRO=1
  if PRO==2; NVIE=13*NCAT+1; end % para PRO=2
  fprintf(FIDE,'View[0].Visible = 1; \n'); % vista visible
  fprintf(FIDE,'View[0].IntervalsType = 3; \n'); % vista intervalos definidos
  fprintf(FIDE,'View[0].ShowElement = 1; \n'); % mostrar malla sobre resultado
  
  for IVIE=1:NVIE  
    fprintf(FIDE,'View[%d].Visible = 0; \n',IVIE); % vistas no visibles
    fprintf(FIDE,'View[%d].IntervalsType = 3; \n',IVIE); % vistas intervalos definidos
    fprintf(FIDE,'View[%d].ShowElement = 1; \n',IVIE); % mostrar malla sobre resultado
  end % endfor IVIE
  
  % mostrar deformada con factor de exageración en la view[0]
  fprintf(FIDE,'View[0].DisplacementFactor = 100; \n'); % factor de exageración
  fprintf(FIDE,'View[0].VectorType = 5; \n'); % tipo de representación con deformada
  
  % mostrar vectores de las fuerzas en los nudos (view[1])
  fprintf(FIDE,'View[1].VectorType = 2; \n'); % tipo de representación con flecha plana
  fprintf(FIDE,'View[1].GlyphLocation = 2; \n'); % ubicación de flecha sobre nudo
  fprintf(FIDE,'View[1].CenterGlyphs = 2; \n'); % alineación de flecha a derecha
  fprintf(FIDE,'View[1].LineWidth = 2; \n'); % ancho de línea
  fprintf(FIDE,'View[1].ArrowSizeMax = 120; \n'); % tamaño de flecha 120
  fprintf(FIDE,'View[1].IntervalsType = 3; \n'); % contorno de áreas llenas
  fprintf(FIDE,'View[1].NbIso = 8; \n'); % 8 rangos de colores
  
  status = fclose(FIDE); % cierre de archivo .pos.opt
  % ------------------------------------------------------------

  % crear archivo de resultados .pos
  % ------------------------------------------------------------
  % id del tipo de elemento en GMSH
  if NNUE==3; TELE = 2; end; % triangular de 3 nudos
  if NNUE==4; TELE = 3; end; % cuadrilateral de 4 nudos
  
  % formatos de componentes de esfuerzo y deformación
  ETIQ=['XX';'YY';'XY';'P1';'P2';'P3';'VM';'ZZ';'XZ';'YZ'];
  
  GMSH = strcat(ADAD,'.pos'); % nombre archivo GMSH post de los resultados
  FIDE = fopen(GMSH,'w'); % abrir archivo y establecer identificador
  
  % versión del GMSH y tamaño de variables reales
  fprintf(FIDE,'$MeshFormat \n');
  fprintf(FIDE,'2.0 0 8 \n');
  fprintf(FIDE,'$EndMeshFormat\n');
  
  % coordenadas de los nudos
  fprintf(FIDE,'$Nodes \n %6i \n',NNUD);
  ZER = zeros(1,NNUD);
  TEM = [double(1:NNUD);XYZ';ZER];
  fprintf(FIDE,'%6i %+10.4e %+10.4e %+10.4e \n',TEM);
  fprintf(FIDE,'$EndNodes \n');
  
  % conectividades de los elementos
  fprintf(FIDE,'$Elements \n %6i \n',NELE);
  for IELE=1:NELE
    % imprimir IELE,TELE,ICAT
    fprintf(FIDE,'%6i %2i 2 %2i %2i',IELE,TELE,ELE(IELE,1),SUP(1,IELE));
    for INUE=1:NNUE
      % establecer cuarto nudo de triángulo repitiendo el último nudo
      if ELE(IELE,INUE+1)==0; ELE(IELE,INUE+1)=ELE(IELE,INUE); end;
      % imprimir en archivo en el orden NUDI NUDJ NUDK NUDL
      fprintf(FIDE,'%6i ',ELE(IELE,INUE+1));
    end % endfor INUE
    fprintf(FIDE,'\n');
  end % endfor IELE
  fprintf(FIDE,'$EndElements \n');
  
  % un solo tiempo y paso de carga
  % TIME=0.1;
  % STEP=0;
  
  % ciclo de pasos de carga
  % --------------------------
  UXYT=UXY;
  FXYT=FXY;
  SRET=SRE;
  ERET=ERE;
  NSTEP=1; % NUMERO DE PASOS INVENTADO
  more off
  for STEP=0:NSTEP-1
  % FUNCION INVENTADA
  if NSTEP==1;
    TIME=1;
  else
    TIME=sin(2*pi*(STEP+1)/NSTEP);
    warning('paso de carga: %6i',STEP);
  end
  UXY=TIME*UXYT;
  FXY=TIME*FXYT;
  SRE=[SRET(:,1:2),TIME*SRET(:,3:9)];
  ERE=[ERET(:,1:2),TIME*ERET(:,3:8)];
  % --------------------------
  
  % desplazamientos de los nudos
  fprintf(FIDE,'$NodeData \n 1 \n "Desplaz. nod." \n 1 \n');
  fprintf(FIDE,' %+10.4e \n 3 \n %6i \n 3 \n %6i \n',TIME,STEP,NNUD);
  TEM = [double(1:NNUD);UXY';ZER];
  fprintf(FIDE,'%6i %+15.6e %+15.6e %+15.6e \n',TEM)
  fprintf(FIDE,'$EndNodeData \n');
  
  % fuerzas de los nudos
  fprintf(FIDE,'$NodeData \n 1 \n "Fuerzas nod." \n 1 \n');
  fprintf(FIDE,' %+10.4e \n 3 \n %6i \n 3 \n %6i \n',TIME,STEP,NNUD);
  TEM = [double(1:NNUD);FXY';ZER];
  fprintf(FIDE,'%6i %+15.6e %+15.6e %+15.6e \n',TEM)
  fprintf(FIDE,'$EndNodeData \n');
  
  % esfuerzos y deformaciones en el interior de los elementos
  if PRO==1
    
    % formatos para resultados en triangulos de 3 nudos y cuadrilateros de 4
    if NNUE==3; FORME='%6i %6i %+15.6e %+15.6e %+15.6e \n'; end
    if NNUE==4; FORME='%6i %6i %+15.6e %+15.6e %+15.6e %+15.6e \n'; end
    
    % esfuerzos en el interior de los elementos
    NCOM=7; % ETIQ=['XX';'YY';'XY';'P1';'P2';'P3';'VM']
    for ICOM=1:NCOM
      fprintf(FIDE,'$ElementNodeData \n 1 \n "Esfuerzo S%s" \n 1 \n',...
              ETIQ(ICOM,1:2));
      fprintf(FIDE,' %+10.4e \n 3 \n %6i \n 1 \n %6i \n',TIME,STEP,NELE);
      for IELE=1:NELE
        fprintf(FIDE,FORME,...
                IELE, NNUE,SRE(((IELE-1)*NNUE+1):(IELE*NNUE),ICOM+2)');
      end %endfor IELE
      fprintf(FIDE,'$EndElementNodeData \n');
    end %endfor ICOM

    % deformaciones en el interior de los elementos
    NCOM=6; % ETIQ=['XX';'YY';'XY';'P1';'P2';'P3']
    for ICOM=1:NCOM
      fprintf(FIDE,'$ElementNodeData \n 1 \n "Deform. E%s" \n 1 \n',...
              ETIQ(ICOM,1:2));
      fprintf(FIDE,' %+10.4e \n 3 \n %6i \n 1 \n %6i \n',TIME,STEP,NELE);
      for IELE=1:NELE
        fprintf(FIDE,FORME,...
                IELE, NNUE,ERE(((IELE-1)*NNUE+1):(IELE*NNUE),ICOM+2)');
      end %endfor IELE
      fprintf(FIDE,'$EndElementNodeData \n');
     end %endfor ICOM
  
  end % endif PRO==1
  
  % esfuerzos y deformaciones promedio en los nudos para una categoría
  if PRO==0
  
    % esfuerzos promedio en los nudos  
    NCOM=7; % ETIQ=['XX';'YY';'XY';'P1';'P2';'P3';'VM']
    [RNU] = ORSONO(ELE,SRE,NNUD,NCOM); % calcular promedio en nudos
 
    for ICOM=1:NCOM
      fprintf(FIDE,'$NodeData \n 1 \n "Esfuerzo prom. S%s" \n 1 \n',...
              ETIQ(ICOM,1:2));
      fprintf(FIDE,' %+10.4e \n 3 \n %6i \n 1 \n %6i \n',TIME,STEP,NNUD);
      TEM = [double(1:NNUD);RNU(double(1:NNUD),ICOM)'];
      fprintf(FIDE,'%6i %+15.6e \n',TEM);
      fprintf(FIDE,'$EndNodeData \n');
    end %endfor ICOM
    
    % deformaciones promedio en los nudos  
    NCOM=6; % ETIQ=['XX';'YY';'XY';'P1';'P2';'P3';'VM']
    [RNU] = ORSONO(ELE,ERE,NNUD,NCOM); % calcular promedio en nudos 
    for ICOM=1:NCOM
      fprintf(FIDE,'$NodeData \n 1 \n "Deform. prom. E%s" \n 1 \n',...
              ETIQ(ICOM,1:2));
      fprintf(FIDE,' %+10.4e \n 3 \n %6i \n 1 \n %6i \n',TIME,STEP,NNUD);
      TEM = [double(1:NNUD);RNU(double(1:NNUD),ICOM)'];
      fprintf(FIDE,'%6i %+15.6e \n',TEM);
      fprintf(FIDE,'$EndNodeData \n');
    end %endfor ICOM
  
  end %endif PRO==0

  % esfuerzos y deformaciones promedio en los nudos para varias categorías
  if PRO==2
  
    for ICAT=1:NCAT
      TEM=zeros('double');
      % esfuerzos promedio en los nudos  
      NCOM=7; % ETIQ=['XX';'YY';'XY';'P1';'P2';'P3';'VM']
      [NUD,NUCA] = ORSOCA(ELE,SRE,NNUD,NCOM,ICAT); % calcular promedio en nudos 
      for ICOM=1:NCOM
        fprintf(FIDE,'$NodeData \n 1 \n "Esfuerzo prom. cat. %2i S%s" \n 1 \n',...
                ICAT, ETIQ(ICOM,1:2));
        fprintf(FIDE,' %+10.4e \n 3 \n %6i \n 1 \n %6i \n',TIME,STEP,NUCA);
        TEM = [NUD(1:NUCA,1),NUD(1:NUCA,ICOM+1)]';
        fprintf(FIDE,'%6i %+15.6e \n',TEM);
        fprintf(FIDE,'$EndNodeData \n');
      end %endfor ICOM
      
      % deformaciones promedio en los nudos  
      NCOM=6; % ETIQ=['XX';'YY';'XY';'P1';'P2';'P3';'VM']
      [NUD,NUCA] = ORSOCA(ELE,ERE,NNUD,NCOM,ICAT); % calcular promedio en nudos 
      for ICOM=1:NCOM
        fprintf(FIDE,'$NodeData \n 1 \n "Deform. prom. cat. %2i E%s" \n 1 \n',...
                ICAT,ETIQ(ICOM,1:2));
        fprintf(FIDE,' %+10.4e \n 3 \n %6i \n 1 \n %6i \n',TIME,STEP,NUCA);
        TEM = [NUD(1:NUCA,1),NUD(1:NUCA,ICOM+1)]';
        fprintf(FIDE,'%6i %+15.6e \n',TEM);
        fprintf(FIDE,'$EndNodeData \n');
      end %endfor ICOM

    end %endfor ICAT
    
  end % endif PRO==2
  
  % --------------------
  end % endfor STEP
  % --------------------
  
  status = fclose(FIDE); % cierre de archivo .pos
 

end