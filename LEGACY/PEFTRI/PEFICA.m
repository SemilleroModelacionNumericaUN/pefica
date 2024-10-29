% -----------------------------------------------------------------------------
% PEFiCA: Programa de elementos finitos a código abierto.
% versión 2.0
%
% Esta versión está en la carpeta PEFTRI, e incluye:
% Análisis elástico lineal para problemas tridimensionales
%
% mediante el método de los elementos finitos. Considera
% deformaciones infinitesimales y utiliza elementos finitos tetraédricos
% lineales. Lee los datos y escribe los resultados en el programa GMSH.
%
% Dorian L. Linero S., Martín Estrada M. & Diego A. Garzón A.
% Universidad Nacional de Colombia
% Facultad de Ingeniería
% Todos los derechos reservados, 2020
%
function PEFICA (ADAT,TLEC)
% ADAT: nombre del archivo de entrada de datos sin extensión
% TLEC: identificador de la opción de lectura de datos. Este es un parámetro
%       que por defecto es igual a 0.
% -----------------------------------------------------------------------------
% presentación inicial en pantalla
clc; % limpiar pantalla
fprintf('----------------------------------------------------------------- \n');
fprintf('       PEFICA 2.0. Universidad Nacional de Colombia 2020          \n');
fprintf('----------------------------------------------------------------- \n');
fprintf('PEFTRI/PEFICA: Análisis tridimensional elástico lineal \n');
fprintf('escriba PEFICA <nombre archivo datos .m o .msh> <opciones lectura>\n');
fprintf('el parametro <opciones lectura> puede ser igual a: \n');
fprintf('=10: lectura datos de .msh de GMSH y escritura resultados en\n');
fprintf('     .pos de GMSH esfuerzos y deformaciones promedio en nudos\n');
fprintf('     para una categoría de material y espesor PRO=0\n');
fprintf('=11: lectura datos de .msh de GMSH y escritura resultad en .pos de\n');
fprintf('     GMSH, esfuerzos y deformaciones en el interior de eleme PRO=1\n');
fprintf('=12: lectura datos de .msh de GMSH y escritura resultados en \n');
fprintf('     .pos de GMSH esfuerzos y deformaciones promedio en nudos \n');
fprintf('     para varias categorías de material y espesor PRO=2.\n');
fprintf('     Adicionalmente se imprime archivo .tbl con las reacciones.\n');
fprintf('=13: lectura datos de .msh de GMSH y escritura resultados en \n');
fprintf('     .pos de GMSH esfuerzos y deformaciones en el interior de \n');
fprintf('     los elementos para varias categorías PRO=3\n');
fprintf('=14: lectura datos de .msh de GMSH y escritura resultados en \n');
fprintf('     .pos de GMSH esf, def y dir princ promedio en nudos \n');
fprintf('     para varias categorías de material y espesor PRO=4\n');
fprintf('=20,21,22,23,24: lectura datos de .geo de GMSH, generación de malla y del\n');
fprintf('     archivo .msh realizada de forma remota por GMSH, y escritura de\n');
fprintf('     resultados en archivo .pos de GMSH, calculando como 10,11,12,13,14\n');
fprintf('=07: lectura datos de archivo .m y escritura resultados en\n');
fprintf('     .pos de GMSH esfuerzos y deformaciones en el interior\n'); 
fprintf('     de eleme PRO=1\n');
fprintf('Si <opciones lectura> se omite el valor por defecto es 10. \n');
fprintf('------------------------------------------------------------------\n');  
% ------------------------------------------------------------------------------  
  % control de ausencia de argumentos
  if exist('ADAT') == 0
    fprintf('PEFICA. La funcion requiere <nombre archivo datos>.\n')
    return
  end
  if exist('TLEC') == 0
    TLEC='10';
    fprintf('PEFICA. La funcion tomará por defecto a <opciones lectura>=10.\n')
  end
  ADAD = strcat('./DATOS/',ADAT);
  TLEN = str2num(TLEC);
  
  % adicionar carpetas y tomar tiempo inicial
  addpath('./FUNCIONES');
  addpath('./DATOS'); 
  TINT = IMTIEM('Inicio de ejecucion del programa \n',0);
  
  % lectura de archivo de entrada de datos
  % -------------------------------------------------------------------------
  if TLEN<10
    % opción de lectura de entrada de datos de archivo .m
    TINI = IMTIEM('Lectura de datos de entrada (.m) ',0);
    run(ADAT);
    SUP = ones(1,NELE); % tabla de id del volumen asociado a cada elemento
    PRO=1;
  else
    % sub opciones del cálculo de los esfuerzos y deformaciones promedio en 
    % nudos o en el interior de los elementos con una o varias categoría
    PRO=TLEN-10;
  
    % opción de creación de la malla en GMSH en un archivo .msh de forma remota 
    if TLEN>=20
      fprintf('Ejecución de líneas de comando de GMSH desde PEFiCA\n');
      [~,OSMS] = system(['gmsh ./DATOS/' ADAT '.geo -3 -format msh2']);
      fprintf(OSMS);
      PRO=TLEN-20;
    end % endif
  
    % opción de lectura de entrada de datos de archivo .msh de GMSH
    LECA = sprintf('Lectura de datos de entrada de archivo %s.msh de GMSH ', ADAT);
    TINI = IMTIEM(LECA,0);
    [NNUD,NELE,NNUE,NGAU,NDIM,NCAT,TIPR,ENNU,IMPR,...
     XYZ,ELE,CAT,UCO,FUN,FDI,SUP] = LEGMSH(ADAD);
        
    % convertir despl conoc de formato B a formato A
    % para este tipo de problema NDIM=NGLN el cual aún no ha sido calculado
    [TEM] = ORVEBA(UCO,TLEN,NDIM,0); UCO=TEM;
    % convertir FUN de formato B a formato A
    [TEM] = ORVEBA(FUN,TLEN,NDIM,1); FUN=TEM;
    
  end %endif
  
  ELE = int64(ELE); % cambio de tipo de datos para las matrices enteras

  if TIPR==30
    PMAT = 3;    % número de propiedades de cada material [ EYOU POIS GAMM ]
    PELE = 4;    % número de propiedades de cada elemento [ DUMM TIPE NUEL PGAU ]
    PCAT = PMAT+PELE;    % número de propiedades en cada categoria
    NCOM=6; % NCOM: número de componentes de esfuerzo o deformación
  else
    error('Tipo incorrecto de problema');
  end % endif problema tridimensional, material isotrópico
  
  TFIN = IMTIEM('',TINI);
  
  TINI = IMTIEM('Grados de libertad de nudos y elementos ',0);
  % -------------------------------------------------------------------------
  % A partir de la tabla de desplazamientos conocidos de algunos nudos UCO()
  % se crea la tabla de GL por nudo MGL(), el subvector de desplazamientos 
  % conocidos UBB() y se obtiene el número de GL por nudo NGLN y el número de
  % GL conocidos NGLC.
  [MGL,UBB,NGLN,NGLC] = NGLUCO(UCO,NNUD);
  NGLT = NNUD*NGLN;  % número de grados de libertad del sólido
  NGLD = NGLT-NGLC;  % número de grados de libertad conocidos
  [INC] = NGLELE(ELE,MGL);
  TFIN = IMTIEM('',TINI);
  % indicador de parámetros de la malla
  fprintf('Malla de %g nudos, %g elementos y %g GLs\n', NNUD,NELE,NGLT);
  % Se crea la tabla de GLs por elemento o matriz de incidencias
  
  TINI = IMTIEM('Matriz de rigidez del solido\n',0);
  % -------------------------------------------------------------------------
  
  % control interno del tipo de matriz de rigidez ensamblada:
  % LSIZ=0: matriz llena que funciona hasta 15000 nudos
  % LSIZ=1: matriz sparse para problemas de más de 15000 nudos
  
  LSIZ=0;
  if NNUD>15000;
    LSIZ=1;
  end % endif

  switch LSIZ
  
    case 0
    % ensamblaje convencional de la matriz de rigidez, el cual tiene una
    % capacidad máxima de 45000 grados de libertad
    %
    fprintf('ensamblaje convensional de la matriz de rigidez llena ');
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
      % fin del ensamblaje
    end % endfor IELE

    case 1
    % ensamblaje de una matriz de rigidez tipo sparse, la cual tiene una
    % capacidad máxima aproximanda de 300,000 grados de libertad y 
    % 2,700,000 elementos tetrahédicos.
    %
    fprintf('ensamblaje de la matriz de rigidez tipo sparse ');
    IKGS = 0;
    KGV = zeros(1,1,'double');
    for IELE = 1:NELE
      % matriz de rigidéz de elemento
      CAE(1:PCAT) = CAT(ELE(IELE,1),1:PCAT); % propiedades de la categ eleme IELE
      NUEL = CAE(1,PMAT+3);  % número de nudos del elemento IELE
      XYE(1:NUEL,1:NDIM) = XYZ(ELE(IELE,2:NUEL+1),1:NDIM); % coor nud de elem IELE
      [KEL] = KELEME(TIPR,XYE,CAE); % matriz de rigidez del elem IELE tipo llena
     
      % ensamblaje de KEL() del elemento IELE en KGS() del sólido
      NKEL = size(KEL,1); % tamaño de la matriz de rigidez del elemento
      for IKEL=1:NKEL
        for JKEL=1:NKEL
          if (INC(IELE, IKEL) ~= 0 & INC(IELE, JKEL) ~= 0)
            IKGS = IKGS + 1;
            KGF(IKGS) = INC(IELE, IKEL);
            KGC(IKGS) = INC(IELE, JKEL);
            KGV(IKGS) = KEL(IKEL, JKEL);
          end % endif
        end % endfor JKEL
      end % endfor IKEL
    end
    % construcción de la matriz sparse de rigidez
    % si dos ubicaciones coinciden la función sparse suma los términos   
    KGS = sparse(KGF,KGC,KGV);

  end % endswitch
  
  % submatrices de rigidez del sólido
  KAA = KGS(1:NGLD,1:NGLD);            % submatriz K_{alpha,alpha}
  KAB = KGS(1:NGLD,NGLD+1:NGLT);       % submatriz K_{alpha,beta}
  KBA = KGS(NGLD+1:NGLT,1:NGLD);       % submatriz K_{beta,alpha}
  KBB = KGS(NGLD+1:NGLT,NGLD+1:NGLT);  % submatriz K_{beta,beta}
  clear KGS; % eliminar matriz de la memoria
  TFIN = IMTIEM('',TINI);
  
  TINI = IMTIEM('Vectores de fuerzas en los nudos del solido ',0);
  
  % Vector de fuerzas de cuerpo en el solido
  % -------------------------------------------------------------------------
  FGC = zeros(NGLT,1); % definición de tamaño del vector de fuer cuerp sólido
  GAMT = sum(CAT(:,3));
  if GAMT~=0; % contror de problemas sin fuerzas de cuerpo GAMM=0
    for IELE = 1:NELE
      % vector de fuerzas equivalentes al peso propio en el elemento
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
    end % endfor IELE
  end % endif

  % Vector de fuerzas de superficie en el solido
  % -------------------------------------------------------------------------
  NFDI = size(FDI,1); % número de cargas distribuidas en elementos
  FGS = zeros(NGLT,1); % definición de tamaño del vec fuerz superf del sólido
  for IFDI = 1:NFDI % ciclo por carga distribuida
    if FDI(IFDI,1)~=0; % control de problemas sin fuerzas de superficie
      IELE = FDI(IFDI,1); % id del elemento cargado
      TIPE = CAT(ELE(IELE,1),5); % tipo de elemento cargado
      [NUEL,NUCA,DUMM] = PBNUEL(TIPE);  % nudos del elemento y de la cara
      XYE(1:NUEL,1:NDIM) = XYZ(ELE(IELE,2:NUEL+1),1:NDIM); % coor nud de elem IELE
      XYC(1:NUCA,1:NDIM) = XYZ(FDI(IFDI,2:NUCA+1),1:NDIM); % coor nud de cara IFDI
      ELA  = ELE(IELE,2:NUEL+1); % id nudos del elemento cargado
      FDE  = FDI(IFDI,:);   % id de los nudos de la cara cargada, valor carga
      [FEL] = FELEMS(TIPE,XYE,XYC,ELA,FDE); % vec fuerza de superf del element
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
  
  % Vector de fuerzas aplicadas direct en los nudos del solido
  % -------------------------------------------------------------------------
  [TEM] = ORTAEX(FUN,NNUD); % tabla de fuerzas puntuales extendida a todos nuds
  [FGN] = ORTAVE(TEM,MGL); % vector de fuerzas en los nudos del sólido
  % solo es valido del GL=1 hasta GL=NGLD, los términos donde GL>NGLD son las
  % reacciones en los apoyos que aún son desconocidas
 
  % Vector de fuerzas totales equival en los nudos del solido
  % -------------------------------------------------------------------------
  % fuer.totales = fuer.eq.cuerpo + fuer.eq.superficie + fuer.aplic.direc.nudos
  FGT = FGC + FGS + FGN;
  FAA = FGT(1:NGLD,1); % subvec.fuer.totales conocidas alpha, entre 1<=GL<=NGLD
  TFIN = IMTIEM('',TINI);
  
  TINI = IMTIEM('Desplazamientos y reacciones en los nudos del solido\n',0);
  % Desplazamientos en los nudos del sólido
  % -------------------------------------------------------------------------
  % solución de un sistema de ecuaciones simultaneas para obtener el
  % subvector de desplazamientos nodales desconocidos u_{alpha}

  % solución para matrices no simétricas, método de Gauss-Jordan (mayor tiempo de ejecución)
  % UAA = (KAA) \ (FAA - KAB * UBB);
  
  % solución para matrices simétricas (menor tiempo de ejecución)
  AUX = FAA - KAB * UBB;
  switch LSIZ
    case 0
      % solución del sistema de ecuaciones simultáneas mediante 
      % el método de Cholesky aplicado a la matriz de rigidez llena
      fprintf('solución sistema método Cholesky ');
      opts.SYM = true;
      UAA = linsolve(KAA,AUX,opts);
    case 1
      % solución del sistema de ecuaciones simultáneas mediante
      % el método iterativo de los gradientes conjugados aplicado
      % a la matriz de rigidez tipo sparse
      fprintf('solución sistema método gradientes conjugados\n');
      UAA = pcg(KAA,AUX,1e-6,1000);
  end % endswitch
  
  UTO = [ UAA ; UBB ]; % vector de desplaz. nodales completo
  [UXY] = ORVETA(UTO,MGL); % tabla de desplaz. nodales en formato UX,UY
  
  % Fuerzas totales en los nudos del solido
  % -------------------------------------------------------------------------
  FBB = KBA * UAA + KBB * UBB; % subvector de fuerzas totales desconoc
  FTO = [ FAA ; FBB ]; % vector de fuerzas totales
  [FXY] = ORVETA(FTO,MGL); % tabla de fuerzas totales nodales en formato FX,FY
  % eliminar matrices de la memoria
  clear KAA; clear KAB; clear KBA; clear KBB; 
  
  % Reacciones en los nudos del solido
  % -------------------------------------------------------------------------
  if TLEN==12
    FGE = FGC + FGS;  % vector de fuerzas equival. de cuerpo y superficie
    FGB = FGE(NGLD+1:NGLT,1); % subvector beta de fuer.equival.de cuerpo y superf
    FNB = FBB - FGB; % subvector de fuerzas desconocidas en los nudos = reacciones
    FNA = FGN(1:NGLD,1); % subvec.fuer.conocidas en los nudos alpha, entre 1<=GL<=NGLD
    FNT = [ FNA ; FNB ]; % vector de fuerzas en los nudos
    [FNX] = ORVETA(FNT,MGL); % tabla de fuerzas nodales (reacciones) en formato FX,FY,FZ
    IMTBXY(ADAD,FNX,'\nFuerzas directamente en los nudos (reacciones)\n',...
          '  nudo          fx          fy          fz\n');
  end % endif
  
  TFIN = IMTIEM('',TINI);
  
  TINI = IMTIEM('Deformaciones y esfuerzos en cada elemento ',0);
  % -------------------------------------------------------------------------    
  if ENNU==0; NEVA=NGAU; end; % evaluada en los puntos de Gauss
  if ENNU==1; NEVA=NNUE; end; % evaluada en los nudos
  if ENNU==2; NEVA=1; end; % evaluada en el centro del elemento
  
  SRE = zeros(NELE*NEVA,NCOM+6); % crear tabla de esfuerzos por elemento en Gmsh
  ERE = zeros(NELE*NEVA,NCOM+5); % crear tabla de deformaci por elemento en Gmsh
  IRES = 0; % índice de la tabla de esfuerzos y deformaciones para Gmsh
  
  % separar procedimiento para mallas de solo tetraedros lineales con el 
  % fin de reducir el tiempo de cálculo
  if NNUE==4
    
    % cuando la la malla solo tiene elementos tetraedros lineales
    
    % definiciones
    NUEL = 4; % número de nudos del elemento
    NGLE = 12; % número de GL por elemento
    TIPE = 301; % código tipo del elemento 
    XYP = 0; % ubicación de los PG (variable dummy)
    for IELE = 1:NELE % ciclo por elemento
      UEL = EXTRAV(UTO,INC,IELE,NGLE); % vector de despl nodales del elemento
      XYE(1:NUEL,1:NDIM) = XYZ(ELE(IELE,2:NUEL+1),1:NDIM); % coor nud de elem IELE
      CAE = CAT(ELE(IELE,1),:); % propiedades de la categ eleme IELE
      [DEL] = DELEME(CAE,TIPR); % matriz constitutiva del material    
      BEL = BELEME(XYE,XYP,TIPE); % matriz B en el punto de Gauss o nudo IGAU
      % vector de deformaciones del elem. IELE en el punto IGAU
      % EPE = [ EXX, EYY, EZZ, GXY, GXZ, GYZ ]
      EPE = BEL * UEL;
      % vector de esfuerzos del elem. IELE en el punto IGAU
      % STE = [ SXX, SYY, SZZ, SXY, SXZ, SYZ ]
      STE = DEL * EPE;
        
      % esfuerzos y deformac principales y esfuerzo de von Mises para 3D
      [SPR,STVM] = TRPRIN(STE,0); % vector esfuerzo principal y esf VM
      [EPR,DUMY] = TRPRIN(EPE,1); % vector de deformac principales
    
      for IEVA = 1:NNUE % ciclo por nudo  
        % preparar tabla de esfuerzos y de deformaciones por elemento
        % con elemento de valor constante en su interior
        IRES = IRES+1; % ubicación del resultado en la tabla SRE() o ERE()
          
        % número del elemento IELE
        SRE(IRES,1) = IELE;
        ERE(IRES,1) = IELE;
        % número del nudo
        SRE(IRES,2) = ELE(IELE,IEVA+1);
        ERE(IRES,2) = ELE(IELE,IEVA+1);

        % componentes de esfuerzo y de deformación
        SRE(IRES,3:8) = STE'; % esfuerzos SXX, SYY, SZZ, SXY, SXZ, SYZ
        ERE(IRES,3:8) = EPE'; % deformaciones EXX, EYY, EZZ, EXY, EXZ, EYZ
        % esfuerzos o deformaciones principales
        SRE(IRES, 9:11) = SPR'; % tabla esf.princ SP1,SP2,SP3
        ERE(IRES, 9:11) = EPR'; % tabla defor.princ EP1,EP2,EP3
        % esfuerzo de von Mises
        SRE(IRES, 12) = STVM;
        
      end % endfor IEVA
      
    end % endfor IELE  
 
  else 
    
    % cuando la malla tiene elementos de diferente tipo
    for IELE = 1:NELE % ciclo por elemento
      NUEL = CAT(ELE(IELE,1),6); % número de nudos del elemento
      NGLE = NUEL*NGLN; % número de GL por elemento
      UEL = EXTRAV(UTO,INC,IELE,NGLE); % vector de despl nodales del elemento
      
      TIPE = CAT(ELE(IELE,1),5); % código tipo del elemento    
      XYE(1:NUEL,1:NDIM) = XYZ(ELE(IELE,2:NUEL+1),1:NDIM); % coor nud de elem IELE
      CAE = CAT(ELE(IELE,1),:); % propiedades de la categ eleme IELE
      [DEL] = DELEME(CAE,TIPR); % matriz constitutiva del material    
      [TEM] = PBPGAU(NEVA, NDIM, ENNU); % ubicación y ponder de puntos de Gauss
      POIS = CAE(2);  % relación de Poisson
      
      for IEVA = 1:NEVA % ciclo por punto de Gauss o por nudo
        XYP = TEM(IEVA,1:2); % ubicación de puntos de Gauss o por nudos
        % fprintf('elemento %g en el punto %g: \n',IELE,IEVA);
        BEL = BELEME(XYE,XYP,TIPE); % matriz B en el punto de Gauss o nudo IGAU
        % vector de deformaciones del elem. IELE en el punto IGAU
        % EPE = [ EXX, EYY, EZZ, GXY, GXZ, GYZ ]
        EPE = BEL * UEL;
        % vector de esfuerzos del elem. IELE en el punto IGAU
        % STE = [ SXX, SYY, SZZ, SXY, SXZ, SYZ ]
        STE = DEL * EPE;
        
        % esfuerzos y deformac principales y esfuerzo de von Mises para 3D
        [SPR,STVM] = TRPRIN(STE,0); % vector esfuerzo principal y esf VM
        [EPR,DUMY] = TRPRIN(EPE,1); % vector de deformac principales
        
        % preparar tabla de esfuerzos y de deformaciones por elemento para GiD
        % con elemento de valor constante en su interior
        IRES = IRES+1; % ubicación del resultado en la tabla SRE() o ERE()
        
        SRE(IRES,1) = IELE; % tabla de esfuerzos, número del elemento IELE
        ERE(IRES,1) = IELE; % tabla de deformaci, número del elemento IELE
        if ENNU==0
          % evaluación en puntos de Gauss
          SRE(IRES,2) = IEVA; % tabla de esfuerzos, número del PG
          ERE(IRES,2) = IEVA; % tabla de deformaci, número del PG
        elseif ENNU==1
          % evaluación en los extremos de cada elemento
          SRE(IRES,2) = ELE(IELE,IEVA+1); % tabla de esfuerzo, número del nudo
          ERE(IRES,2) = ELE(IELE,IEVA+1); % tabla de deformac, número del nudo
        elseif ENNU==2
          % evaluación en el centro
          SRE(IRES,2) = 0; % tabla de esfuerzo, 0 indica el centro
          ERE(IRES,2) = 0; % tabla de deformac, 0 indica el centro       
        end % endif
        
        for ICOM = 1:NCOM % componente de esfuerzo leida
            SRE(IRES, ICOM+2) = STE(ICOM, 1); % tab esfue SXX, SYY, SZZ, SXY, SXZ, SYZ
            ERE(IRES, ICOM+2) = EPE(ICOM, 1); % tab defor EXX, EYY, EZZ, GXY, GXZ, GYZ
        end % endfor ICOM
        for JCOM = 1:3 % esfuerzos o deformaciones principales
            SRE(IRES, JCOM+NCOM+2) = SPR(JCOM, 1); % tabla esf.princ SP1,SP2,SP3
            ERE(IRES, JCOM+NCOM+2) = EPR(JCOM, 1); % tabla defor.princ EP1,EP2,EP3
        end % endfor JCOM
        SRE(IRES, NCOM+6) = STVM; % esfuerzo de von Mises
        
      end % endfor IEVA
    end % endfor IELE
    
  end % endif NNUE
  
  TFIN = IMTIEM('',TINI);

  % Presentación de resultados
  % ------------------------------------------------------------------------- 
  if IMPR==5
    TINI = IMTIEM('Archivos de resultados para GMSH .pos y .pos.opt ',0);
    % -----------------------------------------------------------------------
    % tabla de fuerzas equivalentes + fuerzas directamente en nudos
    % en formato FX,FY,FZ
    [FGX] = ORVETA(FGT,MGL);
    
    ADAD = strcat('./DATOS/',ADAT);
    
    % imprimir GMSH .pos y .pos.opt en formato ASCII v2
    IMGMSH(ADAD,NNUD,NELE,NNUE,NGAU,NCAT,XYZ,ELE,SUP,UXY,FGX,SRE,ERE,PRO,UCO);
    
    % imprimir GMSH .pos y .pos.opt en formato binario
    %IMGMBI(ADAD,NNUD,NELE,NNUE,NGAU,NCAT,XYZ,ELE,SUP,UXY,FGX,SRE,ERE,PRO,UCO);
    
    
    TFIN = IMTIEM('',TINI); % tiempo de ejecución
  end % endif IMPR
  
  % abrir archivo .pos en el entorno de postproceso de GMSH
  if TLEN>=20
    [~,OSMS] = system(['gmsh ./DATOS/' ADAT '.pos']);
    fprintf(OSMS);
  end % endif
  
  % mostrar tiempo final
  TFIN = IMTIEM('Tiempo total de ejecucion del programa ',TINT);
end
