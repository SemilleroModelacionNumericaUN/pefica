% -------------------------------------------------------------------------
% PEFiCA: Programa de elementos finitos a código abierto. versión 2.0
%
% Esta versión está en la carpeta PARBID, e incluye:
% Análisis elástico lineal para armaduras planas. Puede leer datos y escribir 
% resultados del programa GMSH.
% -------------------------------------------------------------------------
% Dorian L. Linero S., Martín Estrada M. & Diego A. Garzón A.
% Universidad Nacional de Colombia
% Facultad de Ingeniería
% Todos los derechos reservados, 2020

function PEFICA (ADAT,TLEC)
% ADAT: nombre del archivo de entrada de datos sin extensión
% TLEC: identificador de la opción de lectura de datos. Este es un parámetro
%       que por defecto es igual a 0.
% ------------------------------------------------------------------------------
% presentación inicial en pantalla
clc; % limpiar pantalla
fprintf('----------------------------------------------------------------- \n');
fprintf('       PEFICA 2.0. Universidad Nacional de Colombia 2020          \n');
fprintf('----------------------------------------------------------------- \n');
fprintf('PARBID/PEFICA: Analisis elastico lineal de armaduras planas \n');
fprintf('escriba PEFICA <nombre archivo datos .m o .msh> <opciones lectura>\n');
fprintf('el parametro <opciones lectura> puede ser igual a: \n');
fprintf('=0 : lectura de datos en archivo .m y escritura resultados en\n');
fprintf('     en ventana de comandos\n');
fprintf('=1:  lectura de datos en archivo .m y escritura resultados\n');
fprintf('     en archivo .pos de GMSH\n');
fprintf('=9:  lectura de datos en archivo .m y escritura malla en TikZ\n');
fprintf('=10: lectura de datos en archivo .msh de GMSH y escritura resultados\n');
fprintf('     en archivo .pos de GMSH\n');
fprintf('=19: lectura de datos en archivo .msh de GMSH y escritura malla en TikZ\n');
fprintf('=20: lectura de datos en archivo .geo de GMSH, creación automática de\n'); 
fprintf('     malla en archivo .msh y escritura resultados en archivo .pos de GMSH\n'); 
fprintf('Si <opciones lectura> se omite adquiere un valor de 0. \n');
fprintf('------------------------------------------------------------------\n');  
% ------------------------------------------------------------------------------  
  % control de ausencia de argumentos
  if exist('ADAT') == 0
    fprintf('PEFICA. La funcion requiere <nombre archivo datos>.\n')
    return
  end
  if exist('TLEC') == 0
    TLEC='0'
    warning('PEFICA. La funcion tomará por defecto a <opciones lectura>=0.')
  end
  ADAD = strcat('./DATOS/',ADAT);
  TLEN = str2num(TLEC);
  
  % adicionar carpetas y tomar tiempo inicial
  addpath('./FUNCIONES');
  addpath('./DATOS'); 
  fprintf('Inicio de ejecucion del programa \n');
  TINT = clock();
  
  % lectura de archivo de entrada de datos
  % -------------------------------------------------------------------------
  if TLEN<10
    % opción de lectura de entrada de datos de archivo .m (de GiD o escrito direc)
    TINI = IMTIEM('Lectura de datos de entrada de archivo .m ',0);
    run(ADAT);
  else
    % opción de creación de la malla en GMSH en un archivo .msh de forma remota 
    if TLEN==20
      fprintf('Ejecución de líneas de comando de GMSH desde PEFiCA\n');
      [~,OSMS] = system(['gmsh ./DATOS/' ADAT '.geo -1 -format msh2']);
      fprintf(OSMS);
    end % endif
  
    % opción de lectura de entrada de datos de archivo .msh de GMSH
    TINI = IMTIEM('Lectura de datos de entrada de archivo .msh de GMSH ',0);
    [NNUD,NELE,NNUE,NGAU,NDIM,NCAT,TIPR,ENNU,IMPR,...
     XYZ,ELE,CAT,UCO,FUN,FDI,SUP] = LEGMSH(ADAD);     
    % convertir despl conoc de formato B a formato A
    % para este tipo de problema NDIM=NGLN el cual aún no ha sido calculado
    [TEM] = ORVEBA(UCO,TLEN,NDIM,0); UCO=TEM;
    % convertir FUN de formato B a formato A
    [TEM] = ORVEBA(FUN,TLEN,NDIM,1); FUN=TEM; 
  end %endif
  
  ELE = int32(ELE); % cambio de tipo de datos para las matrices enteras
  % parámetros adicionales para el tipo de problema
  if TIPR==10
    % armadura plana
    PMAT = 3; % número de propiedades de cada material [ EYOU POIS GAMM ]
    PELE = 4; % número de propiedades de cada elemento [ AREA TIPE NUEL PGAU ]
    PCAT = PMAT+PELE;    % número de propiedades en cada categoria
    NCOM = 1; % NCOM: número de componentes de esfuerzo o deformación
  else
    % no es un problema de armadura plana
    error('PEFICA. Este no es un problema de armadura plana.')
  end %endswitch
  TFIN = IMTIEM('',TINI);
  
  TINI = IMTIEM('Grados de libertad de nudos y elementos',0);
  % -------------------------------------------------------------------------
  % A partir de la tabla de desplazamientos conocidos de algunos nudos UCO()
  % se crea la tabla de GL por nudo MGL(), el subvector de desplazamientos 
  % conocidos UBB() y se obtiene el número de GL por nudo NGLN y el número de
  % GL conocidos NGLC.
  [MGL,UBB,NGLN,NGLC] = NGLUCO(UCO,NNUD);
  NGLT = NNUD*NGLN;  % número de grados de libertad del sólido
  NGLD = NGLT-NGLC;  % número de grados de libertad conocidos
  % Se crea la tabla de GLs por elemento o matriz de incidencias
  [INC] = NGLELE(ELE,MGL);
  TFIN = IMTIEM('',TINI);
  
  TINI = IMTIEM('Matriz de rigidez del solido',0);
  % -------------------------------------------------------------------------
  KGS = zeros(NGLT,NGLT); % definición de tamaño de la matriz de rigidez sólido
  for IELE = 1:NELE
    % matriz de rigidéz de elemento
    CAE(1:PCAT) = CAT(ELE(IELE,1),1:PCAT); % propiedades de la categ eleme IELE
    NUEL = CAE(1,PMAT+3);  % número de nudos del elemento IELE
    XYE(1:NUEL,1:NDIM) = XYZ(ELE(IELE,2:NUEL+1),1:NDIM); % coor nud de elem IELE
    [KEL] = KELEME(TIPR,XYE,CAE); % matriz de rigidez del elem IELE
    % ensamblaje de KEL() del elemento IELE en KGS() del sólido
    NKEL = size(KEL,1); % tamaño de la matriz de rigidez del elemento
    for IKEL=1:NKEL
      for JKEL=1:NKEL
        if ( INC(IELE, IKEL) ~= 0 & INC(IELE, JKEL) ~= 0)
          KGS(INC(IELE, IKEL), INC(IELE, JKEL)) = ...
          KGS(INC(IELE, IKEL), INC(IELE, JKEL)) + KEL(IKEL, JKEL);
        end % endif
      end % endfor JKEL
    end % endfor IKEL
  end % endfor fin del ensamblaje
  
  % submatrices de rigidez del sólido
  KAA = KGS(1:NGLD,1:NGLD);            % submatriz K_{alpha,alpha}
  KAB = KGS(1:NGLD,NGLD+1:NGLT);       % submatriz K_{alpha,beta}
  KBA = KGS(NGLD+1:NGLT,1:NGLD);       % submatriz K_{beta,alpha}
  KBB = KGS(NGLD+1:NGLT,NGLD+1:NGLT);  % submatriz K_{beta,beta}
  TFIN = IMTIEM('',TINI);
  
  TINI = IMTIEM('Vector de fuerzas de cuerpo en el solido',0);
  % -------------------------------------------------------------------------
  FGC = zeros(NGLT,1); % definición de tamaño del vector de fuer cuerp sólido
  GAMT = sum(CAT(:,3));
  if GAMT~=0; % contror de problemas sin fuerzas de cuerpo GAMM=0
    for IELE = 1:NELE
      % matriz de rigidéz de elemento
      CAE(1:PCAT) = CAT(ELE(IELE,1),1:PCAT); % propiedades de la categ eleme IELE
      NUEL = CAE(1,PMAT+3);  % número de nudos del elemento IELE
      XYE(1:NUEL,1:NDIM) = XYZ(ELE(IELE,2:NUEL+1),1:NDIM); % coor nud de elem IELE
      [FEL] = FELEMC(XYE,CAE); % vector de fuerzas de cuerpo del elemento
      % ensamblaje de FEL() del elemento IELE en FGC() del sólido
      NFEL = size(FEL,1); % tamaño de vector del elemento
      for IFEL=1:NFEL
        if INC(IELE, IFEL) ~= 0
          FGC(INC(IELE, IFEL), 1) = FGC(INC(IELE, IFEL), 1) + FEL(IFEL,1);
        end % endif
      end % endfor IFEL
      % fin ensamblaje
    end % endfor
  end % endif
  TFIN = IMTIEM('',TINI);

  TINI = IMTIEM('Vector de fuerzas de superficie en el solido',0);
  % -------------------------------------------------------------------------
  NFDI = size(FDI,1); % número de cargas distribuidas en elementos
  FGS = zeros(NGLT,1); % definición de tamaño del vec fuerz superf del sólido
  for IFDI = 1:NFDI % ciclo por carga distribuida
    if FDI(IFDI,1)~=0; % control de problemas sin fuerzas de superficie
      FDE = FDI(IFDI,:); % caracteristicas del lado
      ICAT = ELE(FDI(IFDI,1),1); % identific de la categ del elemento cargado
      CAE = CAT(ICAT,:); % propiedades de la categ eleme IELE
      [NLA,LLAD,VLA] = PBLADO(XYZ,ELE,FDE); % número de lado y longitud
      [FEL] = FELEMS(CAE,LLAD,NLA,VLA,FDE); % vec fuerza de superf del element
      IELE=FDI(IFDI,1);
      % ensamblaje de FEL() del elemento IELE en FGS() del sólido
      NFEL = size(FEL,1); % tamaño de vector del elemento
      for IFEL=1:NFEL
        if INC(IELE, IFEL) ~= 0
          FGS(INC(IELE, IFEL), 1) = FGS(INC(IELE, IFEL), 1) + FEL(IFEL,1);
        end % endif
      end % endfor IFEL
      % fin ensamblaje
     end % endif 
  end % endfor
  TFIN = IMTIEM('',TINI);
  
  TINI = IMTIEM('Vector de fuerzas aplicadas direct en los nudos del solido',0);
  % -------------------------------------------------------------------------
  [TEM] = ORTAEX(FUN,NNUD); % tabla de fuerzas puntuales extendida a todos nuds 
  [FGN] = ORTAVE(TEM,MGL); % vector de fuerzas en los nudos del sólido
  
  % solo es valido del GL=1 hasta GL=NGLD, los términos donde GL>NGLD son las
  % reacciones en los apoyos que aún son desconocidas
  TFIN = IMTIEM('',TINI);
  
  TINI = IMTIEM('Vector de fuerzas totales equival en los nudos del solido',0);
  % -------------------------------------------------------------------------
  % fuer.totales = fuer.eq.cuerpo + fuer.eq.superficie + fuer.aplic.direc.nudos
  
  FGT = FGC + FGS + FGN;
  FAA = FGT(1:NGLD,1); % subvec.fuer.totales conocidas alpha, entre 1<=GL<=NGLD
  TFIN = IMTIEM('',TINI);
  
  TINI = IMTIEM('Desplazamientos en los nudos del solido',0);
  % -------------------------------------------------------------------------
  % solución de un sistema de ecuaciones simultaneas para obtener el
  % subvector de desplazamientos nodales desconocidos u_{alpha}
  UAA = (KAA) \ (FAA - KAB * UBB);
  UTO = [ UAA ; UBB ]; % vector de desplaz. nodales completo
  [UXY] = ORVETA(UTO,MGL); % tabla de desplaz. nodales en formato UX,UY
  TFIN = IMTIEM('',TINI);
  
  TINI = IMTIEM('Reacciones en los nudos del solido',0);
  % -------------------------------------------------------------------------
  FGE = FGC + FGS;  % vector de fuerzas equival. de cuerpo y superficie
  FGB = FGE(NGLD+1:NGLT,1); % subvector beta de fuer.equival.de cuerpo y superf
  FBB = KBA * UAA + KBB * UBB - FGB; % subvector de fuerzas desconoc = reacciones
  FTO = [ FAA ; FBB ]; % vector de fuerzas totales
  [FXY] = ORVETA(FTO,MGL); % tabla de fuerzas nodales en formato FX,FY
  TFIN = IMTIEM('',TINI);

  % presentar desplazamientos
  if TLEN==0
   format long % formato largo de impresión en pantalla
   fprintf('Desplazamientos en los nudos\n');
   fprintf('                 NUD                  UX                 UY\n');
   TEMP = [double(1:NNUD)',UXY]
   format short % recuperar formato corto de impresión en pantalla
  end %endif

  % calcular y presentar fuerzas internas  
  TINI = IMTIEM('Fuerza interna en cada elemento',0);
  SRE = zeros(NELE,5); % crear tabla de resultados por elemento en GiD 
  ERE = zeros(NELE,5); % se define y no se utiliza 
  for IELE = 1:NELE % ciclo por elemento
    
    EYOU = CAT(ELE(IELE,1),1); % módulo de Young del elemento
    AREA = CAT(ELE(IELE,1),4); % área de secc trans del elemento 
    TIPE = CAT(ELE(IELE,1),5); % código tipo del elemento 
    NUEL = CAT(ELE(IELE,1),6); % número de nudos del elemento
    NGLE = NUEL*NGLN; % número de GL por elemento
    
    XYE(1:NUEL,1:NDIM) = XYZ(ELE(IELE,2:NUEL+1),1:NDIM); % coor nud de elem IELE
    XYP = zeros(1,2); % ubicación de puntos de Gauss o por nudos (no se usa)
    
    [LONE,TRA] = PBTRAN(XYE);   % longitud y matriz de transformación del elem
    UEG = EXTRAV(UTO,INC,IELE,NGLE); % vec despl nodales del elem en sis global
    UEL = TRA * UEG; % vec despl nodales del elem en sis local
    BEL = BELEME(XYE,XYP,TIPE);
    EPEL = BEL * UEL;    % deformación en el elem
    STEL = EYOU * EPEL;   % esfuerzo en el elem 
    NFEL = STEL * AREA;   % fuerza axial en el elem
    
    % tabla de resultados
    SRE(IELE,1) = IELE;      % número del elemento IELE
    SRE(IELE,2) = EPEL;      % deformación del elemento IELE
    SRE(IELE,3) = STEL;      % esfuerzo del elemento IELE
    SRE(IELE,4) = NFEL;      % fuerza axial interna del elemento IELE
  
  end % endfor
  TFIN = IMTIEM('',TINI); % tiempo de ejecución
  
  % presentar resultados en los elementos
  if TLEN==0
    format long % formato largo de impresión en pantalla
    fprintf('Resultados en los elementos\n');
    fprintf('                 ELE               EPEL                STEL                NFEL\n');
    SRE
    format short % recuperar formato corto de impresión en pantalla
  end % endif
  
  % impresión de archivos de postproceso para GMSH
  if TLEN==1 || TLEN==10 || TLEN==20
    TINI = IMTIEM('Presentacion de resultados en GMSH ',0);
    % -----------------------------------------------------------------------
    if TLEN==1; SUP=ELE(:,1)'; end;
    IMGMSH(ADAD,NNUD,NELE,NNUE,NGAU,NCAT,XYZ,ELE,SUP,UXY,FXY,SRE);
    TFIN = IMTIEM('',TINI); % tiempo de ejecución

  end % endif
  
  % abrir archivo .pos en el entorno de postproceso de GMSH
  if TLEN==20
    [~,OSMS] = system(['gmsh ./DATOS/' ADAT '.pos']);
    fprintf(OSMS);
  end % endif
  
  
  % presentar resultados en GiD
  if TLEN==2
    TINI = IMTIEM('Presentacion de resultados en GiD ',0);
    % -----------------------------------------------------------------------
    ADAD = strcat('./DATOS/',ADAT);
    IMGIDM(ADAD,NNUD,NELE,NNUE,XYZ,ELE); % imprimir archivo de GiD .msh
    IMGIDR(ADAD,NNUD,NELE,NNUE,NGAU,UXY,SRE,ERE); % imprimir arc de GiD .res     
    TFIN = IMTIEM('',TINI); % tiempo de ejecución
  end % endif
  
  % presentar geometría en TikZ
  if TLEN==9 || TLEN==19
     TINI = IMTIEM('Dibujar de geometría en Tikz LaTex ',0);
   % -----------------------------------------------------------------------
    % construir archivo gráfico tikz para latex con geometría
    ADAD = strcat('./DATOS/',ADAT);
    TIPN = 3; % numerar nudos y elementos
    IMTIKZ(ADAD,NNUD,NELE,NNUE,XYZ,ELE,UCO,FUN,TIPN);
    TFIN = IMTIEM('',TINI); % tiempo de ejecución
  end % endif IMPR

  
  % mostrar tiempo final
  TFIN = IMTIEM('Tiempo total de ejecucion del programa                      ',TINT);
end
