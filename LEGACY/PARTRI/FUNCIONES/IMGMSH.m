% imprimir archivo de los resultados para postproceso en GMSH
function IMGMSH(ADAD,NNUD,NELE,NNUE,NGAU,NCAT,XYZ,ELE,SUP,UXY,FXY,SRE)
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
%           SRE:  tabla de los def, esf, fuerza en los elementos
  
  % crear archivo de opciones de presentación de resultados .pos.opt
  % ------------------------------------------------------------
  GMSH = strcat(ADAD,'.pos.opt'); % nombre archivo GMSH de datos
  FIDE = fopen(GMSH,'w'); % abrir archivo .pos.opt
  
  % mostrar solo la primera vista view[0] desplazamiento nodal
  % número de vistas - 1
  NVIE=4; % para PRO=0 o PRO=1
  fprintf(FIDE,'View[0].Visible = 1; \n'); % vista visible
  for IVIE=1:NVIE  
    fprintf(FIDE,'View[%d].Visible = 0; \n',IVIE); % vistas no visibles
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
  if NNUE==2; TELE = 1; end; % barra de 2 nudos
  
  % formatos de deformación, esfuerzo y fuerza axial
  ETIQ=['Deformación';'Esfuerzo   ';'Fuerza axil'];
  
  GMSH = strcat(ADAD,'.pos'); % nombre archivo GMSH post de los resultados
  FIDE = fopen(GMSH,'w'); % abrir archivo y establecer identificador
  
  % versión del GMSH y tamaño de variables reales
  fprintf(FIDE,'$MeshFormat \n');
  fprintf(FIDE,'2.0 0 8 \n');
  fprintf(FIDE,'$EndMeshFormat\n');
  
  % coordenadas de los nudos
  fprintf(FIDE,'$Nodes \n %6i \n',NNUD);
  ZER = zeros(1,NNUD);
  TEM = [double(1:NNUD);XYZ'];
  fprintf(FIDE,'%6i %+10.4e %+10.4e %+10.4e \n',TEM);
  fprintf(FIDE,'$EndNodes \n');
  
  % conectividades de los elementos
  fprintf(FIDE,'$Elements \n %6i \n',NELE);
  for IELE=1:NELE
    % imprimir IELE,TELE,ICAT
    fprintf(FIDE,'%6i %2i 2 %2i %2i',IELE,TELE,ELE(IELE,1),SUP(1,IELE));
    for INUE=1:NNUE
      % imprimir en archivo en el orden NUDI NUDJ
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
  SRE=[SRET(:,1),TIME*SRET(:,2:4)];
  % --------------------------
  
  % desplazamientos de los nudos
  fprintf(FIDE,'$NodeData \n 1 \n "Desplaz nod" \n 1 \n');
  fprintf(FIDE,' %+10.4e \n 3 \n %6i \n 3 \n %6i \n',TIME,STEP,NNUD);
  TEM = [double(1:NNUD);UXY'];
  fprintf(FIDE,'%6i %+15.6e %+15.6e %+15.6e \n',TEM)
  fprintf(FIDE,'$EndNodeData \n');
  
  % fuerzas de los nudos
  fprintf(FIDE,'$NodeData \n 1 \n "Fuerzas nod" \n 1 \n');
  fprintf(FIDE,' %+10.4e \n 3 \n %6i \n 3 \n %6i \n',TIME,STEP,NNUD);
  TEM = [double(1:NNUD);FXY'];
  fprintf(FIDE,'%6i %+15.6e %+15.6e %+15.6e \n',TEM)
  fprintf(FIDE,'$EndNodeData \n');
  
    
   % formatos para resultados en barras de 2 nudos
   if NNUE==2; FORME='%6i %6i %+15.6e %+15.6e \n'; end
   
   % deform, esfuerzo y fuerza axial en el interior de los elementos
   NCOM=3; % ETIQ=['deformxx';'esfuerxx';'fuaxialN']
   for ICOM=1:NCOM
     fprintf(FIDE,'$ElementNodeData \n 1 \n "%s" \n 1 \n',...
             ETIQ(ICOM,1:12));
     fprintf(FIDE,' %+10.4e \n 3 \n %6i \n 1 \n %6i \n',TIME,STEP,NELE);
     for IELE=1:NELE
       fprintf(FIDE,FORME,...
               IELE, NNUE,SRE(IELE,ICOM+1),SRE(IELE,ICOM+1)');
     end %endfor IELE
     fprintf(FIDE,'$EndElementNodeData \n');
   end %endfor ICOM
  
  
  % --------------------
  end % endfor STEP
  % --------------------
  
  status = fclose(FIDE); % cierre de archivo .pos
 

end