% imprimir archivo de los resultados para postproceso en GMSH
function IMGMSH(ADAD,NNUD,NELE,NNUE,NCAT,XYZ,ELE,AXL,UXY,FXY,SRE)
% entrada:  ADAD: nombre del archivo de datos sin extensión
%           NNUD: número de nudos
%           NELE: número de elementos
%           NNUE: número máximo de nudos por elemento
%           NCAT: número de categorías (materiales y espesores)
%           XYZ:  tabla de coordenadas de los nudos
%           ELE:  tabla de conectividades de los elementos
%           AXL:  tabla de vectores unitarios de los elementos
%           UXY:  tabla de desplazamientos de los nudos
%           FXY:  tabla de fuerzas en los nudos
%           SRE:  tabla de las fuerzas internas en los elementos
  
  % crear archivo de opciones de presentación de resultados .pos.opt
  % ------------------------------------------------------------
  GMSH = strcat(ADAD,'.pos.opt'); % nombre archivo GMSH de datos
  FIDE = fopen(GMSH,'w'); % abrir archivo .pos.opt
  
  % generales
  % tamaño fuente valores de la escala de valores: 10pts
  fprintf(FIDE,'General.GraphicsFontSize = 12; \n'); 
  % tamaño fuente de título de la vista: 14pts
  fprintf(FIDE,'General.GraphicsFontSizeTitle = 14; \n');
  % disposición vertical de la escala de valores
  fprintf(FIDE,'PostProcessing.HorizontalScales = 0; \n');

  % mostrar solo la primera vista view[0] desplazamiento nodal
  % número de vistas - 1
  NVIE=11; % para PRO=0 o PRO=1
  for IVIE=0:NVIE  
    fprintf(FIDE,'View[%d].Visible = 0; \n',IVIE); % vistas no visibles
  end % endfor IVIE
  
  % vistas visibles
  fprintf(FIDE,'View[0].Visible = 1; \n');
  fprintf(FIDE,'View[1].Visible = 1; \n');
  fprintf(FIDE,'View[2].Visible = 1; \n');
  fprintf(FIDE,'View[3].Visible = 1; \n');
  
  % vectores unitarios eje x-local (view[1]), y-local (view[2]), z-local (view[3])
  % etiqueta de color rojo, verde, azul
  ETIQ = [ '{255, 0, 0, 255}'; '{0, 255, 0, 255}' ; '{0, 0, 255, 255}' ];
  for IVIE=1:3
    fprintf(FIDE,'View[%d].VectorType = 4; \n',IVIE); % tipo de representación con flecha 3D
    fprintf(FIDE,'View[%d].GlyphLocation = 2; \n',IVIE); % ubicación de flecha sobre nudo
    fprintf(FIDE,'View[%d].CenterGlyphs = 0; \n',IVIE); % alineación de flecha a izquierda
    fprintf(FIDE,'View[%d].LineWidth = 1; \n',IVIE); % ancho de línea
    fprintf(FIDE,'View[%d].ArrowSizeMax = 50; \n',IVIE); % tamaño de flecha 120
    fprintf(FIDE,'View[%d].IntervalsType = 3; \n',IVIE); % contorno de áreas llenas
    fprintf(FIDE,'View[%d].NbIso = 1; \n',IVIE); % 8 rangos de colores
    fprintf(FIDE,'View[%d].ShowElement = 1; \n',IVIE); % mostrar elementos
    fprintf(FIDE,'View[%d].ColorTable = {\n',IVIE); % mapa de colores fijo en rojo
    for ILIN=1:62
      fprintf(FIDE,'%s, %s, %s, %s,\n',ETIQ(IVIE,1:16), ...
              ETIQ(IVIE,1:16),ETIQ(IVIE,1:16),ETIQ(IVIE,1:16));
    end % endfor ILIN
    fprintf(FIDE,'%s, %s, %s\n };\n',ETIQ(IVIE,1:16),...
            ETIQ(IVIE,1:16),ETIQ(IVIE,1:16));
  end % endfor IVIE
  

  
  % mostrar deformada con factor de exageración en la view[0]
  fprintf(FIDE,'View[0].IntervalsType = 3; \n'); % contorno de áreas llenas
  fprintf(FIDE,'View[0].NbIso = 8; \n'); % 8 rangos de colores
  fprintf(FIDE,'View[0].DisplacementFactor = 100; \n'); % factor de exageración
  fprintf(FIDE,'View[0].VectorType = 5; \n'); % tipo de representación con deformada
  fprintf(FIDE,'View[0].LineWidth = 2; \n'); % ancho de línea
  fprintf(FIDE,'View[0].LineType = 1; \n'); % tipo de línea: cilíndro 3D
  
  % parámetros de las vistas de las fuerzas internas en los elementos
  % view[4] a view[9]
  for IVIE=4:9
    fprintf(FIDE,'View[%d].IntervalsType = 3; \n',IVIE); % contorno de áreas llenas
    fprintf(FIDE,'View[%d].NbIso = 10; \n',IVIE); % 10 rangos de colores  
    fprintf(FIDE,'View[%d].LineType = 1; \n',IVIE); % tipo de línea: cilíndro 3D
    fprintf(FIDE,'View[%d].LineWidth = 2; \n',IVIE); % espesor de línea: 10
    fprintf(FIDE,'View[%d].GlyphLocation = 2; \n',IVIE); % ubicación de flecha sobre nudo
  end % endfor IVIE
  
  
  % mostrar vectores de las fuerzas (view[10]) y de momentos (view[11]) en los nudos
  for IVIE=10:11
    fprintf(FIDE,'View[%d].GlyphLocation = 2; \n',IVIE); % ubicación de flecha sobre nudo
    fprintf(FIDE,'View[%d].CenterGlyphs = 2; \n',IVIE); % alineación de flecha a derecha
    fprintf(FIDE,'View[%d].LineWidth = 1; \n',IVIE); % ancho de línea
    fprintf(FIDE,'View[%d].ArrowSizeMax = 120; \n',IVIE); % tamaño de flecha 120
    fprintf(FIDE,'View[%d].IntervalsType = 3; \n',IVIE); % contorno de áreas llenas
    fprintf(FIDE,'View[%d].NbIso = 8; \n',IVIE); % 8 rangos de colores
    fprintf(FIDE,'View[%d].ShowElement = 1; \n',IVIE); % mostrar elementos
  end % endfor IVIE
  fprintf(FIDE,'View[10].VectorType = 4; \n',IVIE); % tipo de representación con flecha 3D
  fprintf(FIDE,'View[11].VectorType = 3; \n',IVIE); % tipo de representación con pirámide

  
  status = fclose(FIDE); % cierre de archivo .pos.opt
  % ------------------------------------------------------------

  % crear archivo de resultados .pos
  % ------------------------------------------------------------
  % id del tipo de elemento en GMSH
  if NNUE==2; TELE = 1; end; % barra de 2 nudos
  
  GMSH = strcat(ADAD,'.pos'); % nombre archivo GMSH post de los resultados
  FIDE = fopen(GMSH,'w'); % abrir archivo y establecer identificador
  
  % versión del GMSH y tamaño de variables reales
  fprintf(FIDE,'$MeshFormat \n');
  fprintf(FIDE,'2.0 0 8 \n');
  fprintf(FIDE,'$EndMeshFormat\n');
  
  % coordenadas de los nudos
  NNUD = size(XYZ,1);
  fprintf(FIDE,'$Nodes \n %6i \n',NNUD);
  ZER = zeros(1,NNUD);
  TEM = [double(1:NNUD);XYZ'];
  fprintf(FIDE,'%6i %+10.4e %+10.4e %+10.4e \n',TEM);
  fprintf(FIDE,'$EndNodes \n');
  
  % conectividades de los elementos
  NELE = size(ELE,1);
  fprintf(FIDE,'$Elements \n %6i \n',NELE);
  for IELE=1:NELE
    % imprimir IELE,TELE,ICAT
    fprintf(FIDE,'%6i %2i 2 %2i %2i',IELE,TELE,ELE(IELE,1),1);
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
  %SRE=[SRET(:,1),TIME*SRET(:,2:4)];
  % --------------------------
  
  % desplazamientos de los nudos
  fprintf(FIDE,'$NodeData \n 1 \n "Desplaz nod" \n 1 \n');
  fprintf(FIDE,' %+10.4e \n 3 \n %6i \n 3 \n %6i \n',TIME,STEP,NNUD);
  TEM = [double(1:NNUD);UXY'];
  fprintf(FIDE,'%6i %+15.6e %+15.6e %+15.6e \n',TEM);
  fprintf(FIDE,'$EndNodeData \n');
  
  % eje local x en el nudo central de cada elemento
  fprintf(FIDE,'$NodeData \n 1 \n "Eje local x" \n 1 \n');
  fprintf(FIDE,' %+10.4e \n 3 \n %6i \n 3 \n %6i \n',TIME,STEP,NNUD);
  TEM = [double(1:NNUD);AXL(:,1:3)' ];
  fprintf(FIDE,'%6i %+15.6e %+15.6e %+15.6e \n',TEM);
  fprintf(FIDE,'$EndNodeData \n');
  
  % eje local y en el nudo central de cada elemento
  fprintf(FIDE,'$NodeData \n 1 \n "Eje local y" \n 1 \n');
  fprintf(FIDE,' %+10.4e \n 3 \n %6i \n 3 \n %6i \n',TIME,STEP,NNUD);
  TEM = [double(1:NNUD);AXL(:,4:6)' ];
  fprintf(FIDE,'%6i %+15.6e %+15.6e %+15.6e \n',TEM);
  fprintf(FIDE,'$EndNodeData \n');
  
  % eje local z en el nudo central de cada elemento
  fprintf(FIDE,'$NodeData \n 1 \n "Eje local z" \n 1 \n');
  fprintf(FIDE,' %+10.4e \n 3 \n %6i \n 3 \n %6i \n',TIME,STEP,NNUD);
  TEM = [double(1:NNUD);AXL(:,7:9)' ];
  fprintf(FIDE,'%6i %+15.6e %+15.6e %+15.6e \n',TEM);
  fprintf(FIDE,'$EndNodeData \n');
  
  
   % formatos para resultados en barras de 2 nudos
   if NNUE==2; FORME='%6i %6i %+15.6e %+15.6e \n'; end
   
   % deform, esfuerzo y fuerza axial en el interior de los elementos
   NCOM=6;
   ETIQ=['Axial en x-local   ';'Cortante en y-local';'Cortante en z-local'; ...
         'Torsion en x-local ';'Momento en y-local ';'Momento en z-local ';];
   for ICOM=1:NCOM
     fprintf(FIDE,'$ElementNodeData \n 1 \n "%s" \n 1 \n',...
             ETIQ(ICOM,1:19));
     fprintf(FIDE,' %+10.4e \n 3 \n %6i \n 1 \n %6i \n',TIME,STEP,NELE);
     for IELE=1:NELE
       fprintf(FIDE,FORME,...
               IELE, NNUE,SRE(IELE,ICOM),SRE(IELE,ICOM+6));
     end %endfor IELE
     fprintf(FIDE,'$EndElementNodeData \n');
   end %endfor ICOM
  
  % fuerzas y momentos de los nudos
  NNUR = size(FXY,1);
  MZE = zeros(NNUD-NNUR,3);
  % fuerzas en los nudos
  fprintf(FIDE,'$NodeData \n 1 \n "Fuerzas en nudos" \n 1 \n');
  fprintf(FIDE,' %+10.4e \n 3 \n %6i \n 3 \n %6i \n',TIME,STEP,NNUD);
  FXT = [ FXY(:,1:3) ; MZE ];
  TEM = [double(1:NNUD);FXT'];
  fprintf(FIDE,'%6i %+15.6e %+15.6e %+15.6e \n',TEM);
  fprintf(FIDE,'$EndNodeData \n');
  % momentos en los nudos
  fprintf(FIDE,'$NodeData \n 1 \n "Momentos en nudos" \n 1 \n');
  fprintf(FIDE,' %+10.4e \n 3 \n %6i \n 3 \n %6i \n',TIME,STEP,NNUD);
  FXT = [ FXY(:,4:6) ; MZE ];
  TEM = [double(1:NNUD);FXT'];
  fprintf(FIDE,'%6i %+15.6e %+15.6e %+15.6e \n',TEM);
  fprintf(FIDE,'$EndNodeData \n');
  
  
  
  
  % --------------------
  end % endfor STEP
  % --------------------
  
  status = fclose(FIDE); % cierre de archivo .pos
 

end