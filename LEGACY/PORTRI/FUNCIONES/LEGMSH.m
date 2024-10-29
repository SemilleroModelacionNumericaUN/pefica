% leer archivo de datos .msh en GMSH
%---------------------------------------------------------------------
function [NNUD,NELE,NNUE,NDIM,NCAT,TIPR,IMPR,...
                XYZ,ELE,CAT,UCO,FUN,FDI,SUP] = LEGMSH(ADAD)
% notas importantes acerca de la generación de la malla en GMSH
% 1. Inicialmente establezca el tamaño característico del elemento finito muy
%    grande, con el fin de asegurar que cuando se genere la malla cada línea sea
%    solo un elemento finito tipo barra. Para esto, haga clic en el menú lateral 
%    Geometry>Elementary entities>Add>Parameter, despues defina el nombre de un
%    parámetro como "lc" y definale un valor sustancialmente superior a la 
%    longitud máxima de una barra (por ejemplo 100 si la unidad de longitud
%    es el metro).
% 2. A continación se crean los puntos, haciendo clic en el menú lateral 
%    Geometry>Elementary entities>Add>Point, definiendo sus coordenadas y
%    estableciendo la variable "lc" como el tamaño característico de los
%    futuros elementos finitos en la vecindad de ese punto en la casilla llamada
%    "Prescribed mesh size at point".
%
% 3. Después se crean las líneas, haciendo clic en el menú lateral 
%    Geometry>Elementary entities>Add>Line y escogiendo sus puntos extremos.
%
% 4. Las condiciones de borde dadas por los desplazamientos y rotaciones
%    conocidos se definen como entidades físicas asociadas a puntos. Tales
%    entidades crean haciendo clic en el menú lateral 
%    Geometry>Physical group>Add>Point, seleccionando el o los puntos con la
%    misma condición de borde y en la casilla Name escribiendo con la siguiente
%    sintaxis:
%    DISP UX=<valor despl en x> UY=<valor despl en y> UZ=<valor despl en z>
%         RX=<valor rotac en x> RY=<valor rotac en y> RZ=<valor rotac en z> 
%    Solo se escriben aquellas componentes de valor conocido.
%
% 5. Las condiciones de borde dadas por fuerzas y momentos puntuales conocidos
%    se definen como entidades físicas asociadas a puntos. Tales entidades 
%    crean haciendo clic en el menú lateral Geometry>Physical group>Add>Point, 
%    seleccionando el o los puntos con la misma condición de borde y en la 
%    casilla Name escribiendo con la siguiente sintaxis:
%    LOAD FX=<valor fuerza en x> FY=<valor fuerza en y> FZ=<valor fuerza en z>
%         MX=<valor moment en x> MY=<valor moment en y> MZ=<valor moment en z>
%
% 6. Las categorías determinan el material, las constantes reales y 
%    las cargas distribuidas de cada elemento. Dichas categorías se 
%    definen como entidades físicas asociadas a líneas, haciendo clic en el 
%    menú lateral Geometry>Physical group>Add>Line, seleccionando la o las 
%    líneas con la misma categoría y en la casilla Name escribiendo con la 
%    siguiente sintaxis:
%    CATE EYOU=<módulo de Young> POIS=<relación de Poisson> 
%         GAMM=<peso específico> AREA=<área de la sección transversal (st)>
%         INEY=<inercia de la st con respecto al eje y local>
%         INEZ=<inercia de la st con respecto al eje z local>
%         JTOR=<constante torsional de la st>
%         ALSH=<factor de forma asociado a las deformaciones por cortante>
%         WYLO=<carga distribuida uniforme en dirección z-local>
%         WZLO=<carga distribuida uniforme en dirección y-local>
%         TIPR=<tipo de problema>
%    La carga WYLO es positiva en el sentido positivo del eje y-local. 
%    Si ALSH=0 entonces se desprecian las deformaciones por cortante. Si el tipo
%    de problema se omite, el parámetro <tipr>=11 que corresponde a barras 3D.
%    
% 7. Para secciones transversales particulares como rectangular maciza y tubular,
%    circular maciza y tubular, y perfil I, se pueden introducir las dimensiones
%    y el programa calcula internamente sus propiedades geométricas. Las secciones
%    tubulares se consideran de pared delgada. Para utilizar esta simplificación
%    en la casilla Name de la entidad física respectiva se debe escribir lo
%    siguiente,
%    - si la sección es rectangular maciza:
%      CATE EYOU=<módulo de Young> POIS=<relación de Poisson> 
%           GAMM=<peso específico> RECY=<dimensión en dirección y-local>
%           RECZ=<dimensión en dirección z-local>
%    - si la sección es rectangular tubular:
%      CATE EYOU=<módulo de Young> POIS=<relación de Poisson> 
%           GAMM=<peso específico> RECY=<dimensión en dirección y-local>
%           RECZ=<dimensión en dirección z-local> RECT=<espesor de pared>
%    - si la sección es circular maciza:
%      CATE EYOU=<módulo de Young> POIS=<relación de Poisson> 
%           GAMM=<peso específico> CIRD=<diámetro>
%    - si la sección es circular tubular:
%      CATE EYOU=<módulo de Young> POIS=<relación de Poisson> 
%           GAMM=<peso específico> CIRD=<diámetro> CIRT=<espesor de pared>
%    - si la sección tipo perfil I:
%      CATE EYOU=<módulo de Young> POIS=<relación de Poisson> 
%           GAMM=<peso específico> PIBZ=<ancho de aleta en dirección y-local> 
%           PIHY=<altura de la sección en dirección z-local>
%           PITW=<espesor del alma> PITF=<espesor de aleta>
%    
% 8. Después de construida la geometría y de establecidas las entidades físicas
%    en GMSH, se debe generar la malla desde el menú lateral Geometry>Mesh>1D 
%    o con la tecla <1>.
%
% 9. El archivo se la malla se debe guardar desde el menú File>Export>Save as... 
%    desplegar y escoger tipo de archivo: Mesh - Gmsh MSH (*.msh), despues en 
%    la ventana MSH Option, escoger en format: Version 2 ASCII. Finalmente
%    escribir el nombre del archivo con extensión .msh.
%
% 10. GMSH genera elementos finitos tipo punto (código 15) sobre las condiciones
%    de borde tipo desplazamiento y cargas puntuales. Estos elementos finitos
%    preliminares son eliminados en esta subrutina. Por lo tanto, la numeración 
%    de los elementos finitos definitivos se modificará de forma secuencial 
%    empezando en 1.
%
% 11.Esta subrutina modifica la numeración de las entidades físicas asociadas 
%    a las propiedades de material, constantes reales y cargas distribuidas 
%    sobre los elementos finitos de línea de forma secuencial
%    empezando en 1.
%---------------------------------------------------------------------
%               
% entrada: ADAD: nombre del archivo de datos sin extensión
%
% salida   NNUD: número de nudos
%          NELE: número de elementos
%          NNUE: número máximo de nudos por elemento
%          NDIM: número de dimensiones del problema
%          NCAT: número de categorias de los elementos
%          TIPR: código de tipo de problema: 11: barras 3D
%          IMPR: tipo de impresión de los resultados
%
%          XYZ: tabla de coordenadas de los nudos
%               [ XNUD YNUD ZNUD]
%          ELE: tabla de categoría y conectividades de los elementos
%               [ ICAT NUDI NUDJ NAUX ]
%          CAT: tabla de categorias de los elementos
%               [ EYOU POIS AREA INEY INEZ JTOR ALPH WYLO WZLO ]
%          UCO: tabla de desplazamientos conocidos
%               [ INUD DCUX DCUY VAUX VAUY ]: formato A (GiD) o
%               [ INUD IDES VALD ]: formato B (GMSH)
%          FUN: tabla de fuerzas aplicadas en los nudos de la malla
%               [ INUD FUNX FUNY FUNZ ]
%          FDI: tabla de fuerzas uniformes distribuidas que se aplican 
%               en las caras de los elementos.
%               [ IELE NUDI NUDJ PREX PREY GLOC ]
%          SUP: tabla auxilar de identificador de la línea asociada
%               al elemento finito (barra)  
  
  % valores por defecto de los parámetros generales para GMSH
  NDIM = 3;    % dimensiones del problema
  IMPR = 5;    % tipo de impresión de los resultados =5: en GMSH.
  TIPR = 11;   % tipo de problema: 11: barras tridimensionales
  NNUE = 2;    % número de nudos por elemento
  ERRF = 0;    % control de error en el contenido del archivo .msh
  
  % lectura del archivo .msh
  GMSH = strcat(ADAD,'.msh'); % nombre archivo GMSH de datos
  FLID = fopen(GMSH); % abrir archivo .msh
  
  if FLID==-1
    fprintf('\n');
    error('PEFICA. El archivo %s.msh no existe',ADAD);
  end
  
  % leer línea de datos en el archivo
  TLINE = fgetl(FLID);
  while ischar(TLINE)
    % bloque de formato
    if (strcmp(TLINE,'$MeshFormat')==1)
      ERRF = 1; % si existe esta línea en el archivo .msh
      TLINE = fgetl(FLID);
      VERSI=str2num(TLINE);
      if (VERSI(1,1)>2.2)
        fprintf('\n');
        error('Version mayor a 2.2 del archivo .msh de GMHS');
      end
    end % endif
    
    % bloque de entidades físicas
    if (strcmp(TLINE,'$PhysicalNames')==1)
      TLINE = fgetl(FLID); % leer siguiente línea
      NFIS=str2num(TLINE);
      NFIS=int16(NFIS);   % número de entidades físicas
      % inicialización
      ICOBO=0; ICATE=0;
      FCOBO=zeros(1,14); FCATE=zeros(1,14);
      for IFIS=1:NFIS
        TLINE = fgetl(FLID); % leer siguiente línea
        TFIS=strsplit(TLINE); % divide línea en palabras
        NCOM=size(TFIS,2); % retorna número de palabras
        NCOM=NCOM-3; % número de componentes en la línea
        TEMP=char(TFIS{3}); % palabra clave etiqueta ent física
        
        % entidad física tipo desplazamiento o rotación conocida
        if (strcmp(TEMP(1:5),'"DISP')==1)
          ICOBO=ICOBO+1; % contador de entidades físicas de condic de borde
          FCOBO(ICOBO,1)=str2num(TFIS{2}); % id entidad física
          FCOBO(ICOBO,2)=10;  % tipo de condición de borde
                              % 10=tipo desplazamiento
          for ICOM=1:NCOM
            TEMR=strsplit(TFIS{3+ICOM},{'=','"'});
            % desplazamiento conocido en x
            if (strcmp(TEMR{1},'UX')==1)
              FCOBO(ICOBO,3)=1; % indicador desplazamiento en x
              FCOBO(ICOBO,4)=str2num(TEMR{2}); % valor despl en x
            end % endif
            % desplazamiento conocido en y
            if (strcmp(TEMR{1},'UY')==1)
              FCOBO(ICOBO,5)=2; % indicador desplazamiento en y
              FCOBO(ICOBO,6)=str2num(TEMR{2}); % valor despl en y
            end % endif
            % desplazamiento conocido en z
            if (strcmp(TEMR{1},'UZ')==1)
              FCOBO(ICOBO,7)=3; % indicador desplazamiento en z
              FCOBO(ICOBO,8)=str2num(TEMR{2}); % valor despl en z
            end % endif
            % rotación conocida en x
            if (strcmp(TEMR{1},'RX')==1)
              FCOBO(ICOBO,9)=4; % indicador rotación en x
              FCOBO(ICOBO,10)=str2num(TEMR{2}); % valor rotación en x
            end % endif
            % rotación conocida en y
            if (strcmp(TEMR{1},'RY')==1)
              FCOBO(ICOBO,11)=5; % indicador rotación en y
              FCOBO(ICOBO,12)=str2num(TEMR{2}); % valor rotación en y
            end % endif
            % rotación conocida en z
            if (strcmp(TEMR{1},'RZ')==1)
              FCOBO(ICOBO,13)=6; % indicador rotación en z
              FCOBO(ICOBO,14)=str2num(TEMR{2}); % valor rotación en z
            end % endif
          end %endfor
          
        end %endif
        
        % entidad física tipo carga y momento puntual
        if (strcmp(TEMP(1:5),'"LOAD')==1)
          ICOBO=ICOBO+1; % contador de entidades físicas de condic de borde
          FCOBO(ICOBO,1)=str2num(TFIS{2}); % id entidad física
          FCOBO(ICOBO,2)=20;  % tipo de condición de borde
                              % 20=tipo carga puntual
          for ICOM=1:NCOM
            TEMR=strsplit(TFIS{3+ICOM},{'=','"'});
            % carga conocida en x
            if (strcmp(TEMR{1},'FX')==1)
              FCOBO(ICOBO,3)=1; % indicador carga en x
              FCOBO(ICOBO,4)=str2num(TEMR{2}); % valor carga en x
            end % endif
            % carga conocida en y
            if (strcmp(TEMR{1},'FY')==1)
              FCOBO(ICOBO,5)=2; % indicador carga en y
              FCOBO(ICOBO,6)=str2num(TEMR{2}); % valor carga en y
            end % endif
            % carga conocida en z
            if (strcmp(TEMR{1},'FZ')==1)
              FCOBO(ICOBO,7)=3; % indicador carga en z
              FCOBO(ICOBO,8)=str2num(TEMR{2}); % valor carga en z
            end % endif
            % momento conocido en x
            if (strcmp(TEMR{1},'MX')==1)
              FCOBO(ICOBO,9)=4; % indicador momento conocido en x
              FCOBO(ICOBO,10)=str2num(TEMR{2}); % valor momento conocido en x
            end % endif
            % momento conocido en y
            if (strcmp(TEMR{1},'MY')==1)
              FCOBO(ICOBO,11)=5; % indicador momento conocido en y
              FCOBO(ICOBO,12)=str2num(TEMR{2}); % valor momento conocido en y
            end % endif
            % momento conocido en z
            if (strcmp(TEMR{1},'MZ')==1)
              FCOBO(ICOBO,13)=6; % indicador momento conocido en z
              FCOBO(ICOBO,14)=str2num(TEMR{2}); % valor momento conocido en z
            end % endif
          end %endfor
          
        end %endif
        
       % entidad física tipo categoría (material, constantes reales y carga dis)
        % inicialización de parámetros de secciónes particulares
        RECY=0; RECZ=0; RECT=0; ALSL=0; % sec transv rectagular
        CIRD=0; CIRT=0; ALSL=0; % seccción circular
        PIBZ=0; PIHY=0; PITW=0; PITF=0; % sección tipo perfil I
        if (strcmp(TEMP(1:5),'"CATE')==1)
          ICATE=ICATE+1; % contador de entidades físicas de tipos de categorias
          FCATE(ICATE,1)=str2num(TFIS{2}); % id entidad física
          for ICOM=1:NCOM
            TEMR=strsplit(TFIS{3+ICOM},{'=','"'});
            % módulo de Young
            if (strcmp(TEMR{1},'EYOU')==1)
              FCATE(ICATE,2)=str2num(TEMR{2}); % valor
            end % endif
            % relación de Poisson
            if (strcmp(TEMR{1},'POIS')==1)
              FCATE(ICATE,3)=str2num(TEMR{2}); % valor
            end % endif
            % peso específico
            if (strcmp(TEMR{1},'GAMM')==1)
              FCATE(ICATE,4)=str2num(TEMR{2}); % valor
            end % endif
            % area de la sección transversal
            if (strcmp(TEMR{1},'AREA')==1)
              FCATE(ICATE,5)=str2num(TEMR{2}); % valor
            end % endif
            % inercia en y-local
            if (strcmp(TEMR{1},'INEY')==1)
              FCATE(ICATE,6)=str2num(TEMR{2}); % valor
            end % endif
            % inercia en z-local
            if (strcmp(TEMR{1},'INEZ')==1)
              FCATE(ICATE,7)=str2num(TEMR{2}); % valor
            end % endif
            % constante torsional
            if (strcmp(TEMR{1},'JTOR')==1)
              FCATE(ICATE,8)=str2num(TEMR{2}); % valor
            end % endif
            % factor de forma asociado a las deformaciones por cortante
            if (strcmp(TEMR{1},'ALSH')==1)
              FCATE(ICATE,9)=str2num(TEMR{2}); % valor
              % ind que se desprecian las deformaciones por cortante para sec rect
              if str2num(TEMR{2})==0; ALSL = -1; end
            end % endif
           
            % parámetros especiales para sección transversal rectangular
            % maciza y tubular de pared delgada
            % dimensión en dirección y-local de sec tranv rectangular 
            if (strcmp(TEMR{1},'RECY')==1)
              RECY=str2num(TEMR{2}); % valor
            end % endif
            % dimensión en dirección z-local de sec tranv rectangular 
            if (strcmp(TEMR{1},'RECZ')==1)
              RECZ=str2num(TEMR{2}); % valor
            end % endif
            % espesor de la pared de una sec tranv rectangular tubular
            if (strcmp(TEMR{1},'RECT')==1)
              RECT=str2num(TEMR{2}); % valor
            end % endif
           
            % parámetros especiales para sección transversal circular
            % diámetro de la sección circular 
            if (strcmp(TEMR{1},'CIRD')==1)
              CIRD=str2num(TEMR{2}); % valor
            end % endif
            % espesor de la pared de la sección circular tubular
            if (strcmp(TEMR{1},'CIRT')==1)
              CIRT=str2num(TEMR{2}); % valor
            end % endif
            
            % parámetros especiales para sección transversal tipo perfil I
            % ancho de aleta en dirección z-local
            if (strcmp(TEMR{1},'PIBZ')==1)
              PIBZ=str2num(TEMR{2}); % valor
            end % endif
            % altura de la sección en dirección y-local
            if (strcmp(TEMR{1},'PIHY')==1)
              PIHY=str2num(TEMR{2}); % valor
            end % endif
            % espesor del alma
            if (strcmp(TEMR{1},'PITW')==1)
              PITW=str2num(TEMR{2}); % valor
            end % endif
            % espesor de aleta 
            if (strcmp(TEMR{1},'PITF')==1)
              PITF=str2num(TEMR{2}); % valor
            end % endif
            
            % carga distribuida uniforme en y-local
            % positiva en el sentido positivo del eje
            if (strcmp(TEMR{1},'WYLO')==1)
              FCATE(ICATE,10)=str2num(TEMR{2}); % valor
            end % endif
            % carga distribuida uniforme en z-local
            % positiva en el sentido positivo del eje
            if (strcmp(TEMR{1},'WZLO')==1)
              FCATE(ICATE,11)=str2num(TEMR{2}); % valor
            end % endif
            
            % vector auxilar para definir ejes locales del elemento
            % componente x
            if (strcmp(TEMR{1},'VELX')==1)
              FCATE(ICATE,12)=str2num(TEMR{2}); % valor
            end % endif
            % componente y
            if (strcmp(TEMR{1},'VELY')==1)
              FCATE(ICATE,13)=str2num(TEMR{2}); % valor
            end % endif
            % componente z
            if (strcmp(TEMR{1},'VELZ')==1)
              FCATE(ICATE,14)=str2num(TEMR{2}); % valor
            end % endif
            
            % tipo de problema: 11=barras 3D
            if (strcmp(TEMR{1},'TIPR')==1)
              TIPR=str2num(TEMR{2}); % valor
              % se guarda en un escalar por que es
              % un parámetro general del problema
            end % endif
          end %endfor
          
          % cálculo de las propiedades geométricas de una sección transversal 
          % rectangular a partir de su base y altura
          
          if (RECY~=0)&&(RECZ~=0)
      
            if RECT==0
            
              % sección transversal rectangular maciza
              % area e inencias a flexión
              FCATE(ICATE,5) = RECY*RECZ; % área
              FCATE(ICATE,6) = RECY*RECZ^3/12; % inercia con respecto a y-local
              FCATE(ICATE,7) = RECZ*RECY^3/12; % inercia con respecto a z-local
              % constante torsional
              if RECY>RECZ
                RMIN = RECZ; RMAX = RECY;
              else
                RMIN = RECY; RMAX = RECZ;
              end % endif
              FCATE(ICATE,8) = RMAX*RMIN^3*((1/3)-...
              0.21*(RMIN/RMAX)*(1-(RMIN^4/(12*RMAX^4))));
              % factor de forma asociado a las deformaciones por cortante
              if ALSL == -1
                FCATE(ICATE,9) = 0;
              else
                FCATE(ICATE,9) = 1.2;
              end % endif
              
            else
            
              % sección transversal rectangular tubular
              % area
              FCATE(ICATE,5) = RECY*RECZ - (RECY-2*RECT)*(RECZ-2*RECT);
              % inercia con respecto a y-local
              FCATE(ICATE,6) = (RECY*RECZ^3 - (RECY-2*RECT)*(RECZ-2*RECT)^3)/12; 
              % inercia con respecto a z-local
              FCATE(ICATE,7) = (RECZ*RECY^3 - (RECZ-2*RECT)*(RECY-2*RECT)^3)/12;
              % constante torsional
              if RECY>RECZ
                RMIN = RECZ; RMAX = RECY;
              else
                RMIN = RECY; RMAX = RECZ;
              end % endif
              FCATE(ICATE,8) = (2*RMIN^2*RMAX^2)/((RMIN/RECT)+(RMAX/RECT));
              % factor de forma asociado a las deformaciones por cortante
              if ALSL == -1
                FCATE(ICATE,9) = 0;
              else
                FCATE(ICATE,9) = 1.0; % REVISAR !!!!!
              end % endif
              
            end %endif
          
          end %endif
          
          % cálculo de las propiedades geométricas de una sección transversal 
          % circular a partir de su diámetro
          
          if CIRD~=0
          
            if CIRT==0
              
              % sección transversal circular maciza
              % area e inencias a flexión
              FCATE(ICATE,5) = 0.25*pi*CIRD^2; % área
              FCATE(ICATE,6) = (pi*CIRD^4)/64; % inercia con respecto a y-local
              FCATE(ICATE,7) = (pi*CIRD^4)/64; % inercia con respecto a z-local
              % constante torsional
              FCATE(ICATE,8) = (pi*CIRD^4)/32;
              % factor de forma asociado a las deformaciones por cortante
              if ALSL == -1
                FCATE(ICATE,9) = 0;
              else
                FCATE(ICATE,9) = 10/9;
              end % endif
              
            else
              
              % sección transversal circular tubular
              % area e inencias a flexión
              FCATE(ICATE,5) = 0.25*pi*CIRD^2 - 0.25*pi*(CIRD-2*CIRT)^2; % área
              FCATE(ICATE,6) = ((pi*CIRD^4)-(pi*(CIRD-2*CIRT)^4))/64; % inercia con respecto a y-local
              FCATE(ICATE,7) = ((pi*CIRD^4)-(pi*(CIRD-2*CIRT)^4))/64; % inercia con respecto a Z-local
              % constante torsional
              FCATE(ICATE,8) = ((pi*CIRD^4)-(pi*(CIRD-2*CIRT)^4))/32;
              % factor de forma asociado a las deformaciones por cortante
              if ALSL == -1
                FCATE(ICATE,9) = 0;
              else
                FCATE(ICATE,9) = 1.0; % REVISAR !!!!
              end % endif
              
            end % endif
              
          end %endif
          
          
          % cálculo de las propiedades geométricas de una sección transversal 
          % tipo perfil I a partir de sus dimensiones
          % PIBZ=<ancho de aleta en dirección z-local> 
          % PIHY=<altura de la sección en dirección y-local>
          % PITW=<espesor del alma> PITF=<espesor de aleta>
          
          if (PIBZ~=0)&&(PIHY~=0)&&(PITW~=0)&&(PITF~=0)
              % area
              FCATE(ICATE,5) = PIBZ*PIHY - (PIHY-2*PITF)*(PIBZ-PITW);
              % inercia con respecto a y-local 
              FCATE(ICATE,6) = (2*PITF*PIBZ^3 + ...
                                (PIHY-2*PITF)*PITW^3)/12; 
              % inercia con respecto a z-local
              FCATE(ICATE,7) = (PIBZ*PIHY^3 - (PIBZ-PITW)*(PIHY-2*PITF)^3)/12;
              
              % constante torsional
              FCATE(ICATE,8) = (2*PIBZ*PITF^3 + PIHY*PITW^3)/3;
              % factor de forma asociado a las deformaciones por cortante
              if ALSL == -1
                FCATE(ICATE,9) = 0;
              else
                FCATE(ICATE,9) = 1.0; % REVISAR !!!!
              end % endif
          
          end % endif
          
          % control de errores
          if (FCATE(ICATE,2)==0)||(FCATE(ICATE,5)==0)
            fprintf('\n');
            error('EYOU o AREA de una categoria igual a cero');
          end %endif

        end %endif 
        
        % entidad física incorrecta
        if((strcmp(TEMP(1:5),'"DISP')==0) && ...
           (strcmp(TEMP(1:5),'"LOAD')==0) && ...
           (strcmp(TEMP(1:5),'"CATE')==0))
           fprintf(TEMP(1:5));
           error ('Nombre incorrecto de entidad fisica');
        end %endif
        
      end % endfor IFIS
      
      NCOBO=ICOBO; % número de entidades físicas de condic de borde
      NCAT=ICATE; % número de entidades físicas de tipos de categoría
      
    end % endif fin de bloque de entidades físicas
    
    % bloque de nudos
    if (strcmp(TLINE,'$Nodes')==1)
      ERRF = 1; % si existe esta línea en el archivo .msh
      TLINE = fgetl(FLID); % leer siguiente línea
      NNUD=int16(str2num(TLINE));% número de nudos
      XYZ=zeros(NNUD,NDIM,'single');
      for INUD=1:NNUD
        TLINE = fgetl(FLID); % leer siguiente línea
        TEMP=str2num(TLINE); % dividir por variables
        XYZ(INUD,1)=TEMP(2); % coordenada x
        XYZ(INUD,2)=TEMP(3); % coordenada y
        XYZ(INUD,3)=TEMP(4); % coordenada z
      end %endfor INUD
    end % endif fin de bloque de nudos
    
    % bloque de elementos y 
    % condiciones de borde en puntos y líneas
    if (strcmp(TLINE,'$Elements')==1)
      ERRF = 1; % si existe esta línea en el archivo .msh
      % inicializar
      ICOPL=0; IELTR=0;  CORL=0; ISUP=0;
      COPL=zeros(1,3); % condiciones de borde en puntos
      ELTR=zeros(1,3); % elementos en líneas tipo barra
  
      TLINE = fgetl(FLID); % leer siguiente línea
      NELT=int16(str2num(TLINE));% núm elem + cond borde
      
      for IELT=1:NELT
        
        TLINE = fgetl(FLID); % leer siguiente línea
        TEMP=str2num(TLINE); % dividir por variables
        
        % entidades físicas tipo condición de borde en puntos
        if TEMP(2)==15
          ICOPL=ICOPL+1; % contador de cond de borde en puntos
          COPL(ICOPL,:)=[TEMP(4),TEMP(6), 0];
        end %endif

        % entidad física en línea con
        % elementos barras de pórtico
        if TEMP(2)==1
          IELTR=IELTR+1; % contador de elementos barra de pórtico
          % escribir en la tabla de categorías
          % tipo de elemento: TIPE, nudos por elem: NUEL, p.Gauss: PGAU
          % TIPE=104: pórtico 3D,
          for ICATE=1:NCAT
            if FCATE(ICATE,1)==TEMP(4)
              FCATE(ICATE,15:17)=[104,2,1];
              RCATE=ICATE; % indice de la categoria asociado a la ent física
            end %endif
          end % endfor ICATE
          % escribir en la tabla de conectividades
          % [id categoría ; id nudos i,j]
          ELTR(IELTR,:)=[RCATE,TEMP(6:7)];
        end %endif
        
        % tabla auxilar de identificador de la línea asociada
        % al elemento finito (barra)
        if TEMP(2)==1
          ISUP=ISUP+1;
          SUP(ISUP)=TEMP(5);
        end %endif

      end %endfor IELT
      
      NCOPL=ICOPL; % número de condiciones de borde
      NELE=IELTR; % número de elementos finitos
      
    end % endif bloque de elem y nudos y lados con cond borde  

    TLINE = fgetl(FLID);% leer siguiente línea
  end % endwhile fin de lectura
  fclose(FLID); % cierre de archivo
  % error en el contenido del archivo .msh
  if ERRF == 0
    fprintf('\n');
    error('El archivo .msh no contiene las palabras claves de GMSH.');
  end %endif 
  
  
  % preparar tabla de categorias de los elementos
  % [ EYOU POIS GAMM AREA INEY INEZ JTOR ALSH WYLO WZLO TIPE NUEL PGAU ]
  CAT=zeros(NCAT,16);
  CAT(:,1:16)=FCATE(:,2:17);
  
  % preparar tabla de conectividades de los elementos ELE
  ELE=ELTR;
  
  % preparar tablas de condiciones de borde para el proceso UCO, FUN, FDI
  % inicializar
  IUCO=0; IUCP=0; IFUN=0; IFDI=0;
  FUN=zeros(1,3); FDI=zeros(1,6); UCO=zeros(1,3);
  
  for ICOPL=1:NCOPL
    for ICOBO=1:NCOBO
      if COPL(ICOPL,1)==FCOBO(ICOBO,1);
        
        if COPL(ICOPL,3)==0
          NTEM=1; % condición de borde en punto de un nudo
        else
          NTEM=2; % condición de borde en línea formada por dos nudos
        end %endif
        
        % preparar tabla de condiciones de borde tipo desplazamiento
        % UCO = [ INUD IDES VALD ]: formato B
        if FCOBO(ICOBO,2)==10       
          % condición de borde en punto o en línea formada por dos nudos
          for ITEM=1:NTEM
            % primer desplazamiento conocido indicado una misma entidad física
            if FCOBO(ICOBO,3)>0
              IUCO=IUCO+1; % cont cond bord tipo de desplaz
              UCO(IUCO,1)=COPL(ICOPL,ITEM+1); % id nudo        
              UCO(IUCO,2:3)=FCOBO(ICOBO,3:4); % id desplazam, valor despl
            end % endif
            % segundo desplazamiento conocido indicado una misma entidad física
            if FCOBO(ICOBO,5)>0
              IUCO=IUCO+1; % cont cond bord tipo de desplaz
              UCO(IUCO,1)=COPL(ICOPL,ITEM+1); % id nudo        
              UCO(IUCO,2:3)=FCOBO(ICOBO,5:6); % id desplazam, valor despl
            end % endif
            % tercer desplazamiento conocido indicado una misma entidad física
            if FCOBO(ICOBO,7)>0
              IUCO=IUCO+1; % cont cond bord tipo de desplaz
              UCO(IUCO,1)=COPL(ICOPL,ITEM+1); % id nudo        
              UCO(IUCO,2:3)=FCOBO(ICOBO,7:8); % id desplazam, valor despl
            end % endif
            % cuarto desplazamiento conocido indicado una misma entidad física
            if FCOBO(ICOBO,9)>0
              IUCO=IUCO+1; % cont cond bord tipo de desplaz
              UCO(IUCO,1)=COPL(ICOPL,ITEM+1); % id nudo        
              UCO(IUCO,2:3)=FCOBO(ICOBO,9:10); % id desplazam, valor despl
            end % endif
            % quinto desplazamiento conocido indicado una misma entidad física
            if FCOBO(ICOBO,11)>0
              IUCO=IUCO+1; % cont cond bord tipo de desplaz
              UCO(IUCO,1)=COPL(ICOPL,ITEM+1); % id nudo        
              UCO(IUCO,2:3)=FCOBO(ICOBO,11:12); % id desplazam, valor despl
            end % endif
            % sexto desplazamiento conocido indicado una misma entidad física
            if FCOBO(ICOBO,13)>0
              IUCO=IUCO+1; % cont cond bord tipo de desplaz
              UCO(IUCO,1)=COPL(ICOPL,ITEM+1); % id nudo        
              UCO(IUCO,2:3)=FCOBO(ICOBO,13:14); % id desplazam, valor despl
            end % endif
          end % endfor
        end %endif
        
        % condiciones de borde tipo fuerza puntual
        % FUN = [ INUD IFUE VALF ]: formato B
        if FCOBO(ICOBO,2)==20
          for ITEM=1:NTEM
            % fuerza puntual aplicada en dirección x
            if FCOBO(ICOBO,4)~=0
              IFUN=IFUN+1; % contador de cond bord tipo fuerza puntual por nudos
              FUN(IFUN,1)=COPL(ICOPL,ITEM+1); % id nudo
              FUN(IFUN,2:3)=FCOBO(ICOBO,3:4); % id fuerza, valor fuerza
            end % endif
            % fuerza puntual aplicada en dirección y
            if FCOBO(ICOBO,6)~=0
              IFUN=IFUN+1; % contador de cond bord tipo fuerza puntual por nudos
              FUN(IFUN,1)=COPL(ICOPL,ITEM+1); % id nudo
              FUN(IFUN,2:3)=FCOBO(ICOBO,5:6); % id fuerza, valor fuerza
            end % endif
            % fuerza puntual aplicada en dirección z
            if FCOBO(ICOBO,8)~=0
              IFUN=IFUN+1; % contador de cond bord tipo fuerza puntual por nudos
              FUN(IFUN,1)=COPL(ICOPL,ITEM+1); % id nudo
              FUN(IFUN,2:3)=FCOBO(ICOBO,7:8); % id fuerza, valor fuerza
            end % endif
            % momento puntual aplicado en dirección x
            if FCOBO(ICOBO,10)~=0
              IFUN=IFUN+1; % contador de cond bord tipo momento puntual por nudos
              FUN(IFUN,1)=COPL(ICOPL,ITEM+1); % id nudo
              FUN(IFUN,2:3)=FCOBO(ICOBO,9:10); % id momento, valor momento
            end % endif
            % momento puntual aplicado en dirección y
            if FCOBO(ICOBO,12)~=0
              IFUN=IFUN+1; % contador de cond bord tipo momento puntual por nudos
              FUN(IFUN,1)=COPL(ICOPL,ITEM+1); % id nudo
              FUN(IFUN,2:3)=FCOBO(ICOBO,11:12); % id momento, valor momento
            end % endif
            % momento puntual aplicado en dirección z
            if FCOBO(ICOBO,14)~=0
              IFUN=IFUN+1; % contador de cond bord tipo momento puntual por nudos
              FUN(IFUN,1)=COPL(ICOPL,ITEM+1); % id nudo
              FUN(IFUN,2:3)=FCOBO(ICOBO,13:14); % id momento, valor momento
            end % endif
          end % endfor        
        end %endif
        
      end %endif
    end %endfor ICOBO
  end %endfor ICOPL
  
  % eliminar condiciones de borde de desplazamientos imp exactamente iguales
  TEM=unique(UCO,'rows');
  UCO=TEM;
  
  % ajustar tabla de fuerzas nodales vacia
  if FUN==0; FUN=[0 NDIM 0]; end
  
end % fin de la función
