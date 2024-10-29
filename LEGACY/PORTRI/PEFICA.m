% -------------------------------------------------------------------------
% PEFiCA: Programa de elementos finitos a código abierto. versión 2.0
%
% Esta versión está en la carpeta PORTRI, e incluye:
% Análisis elástico lineal para pórticos espaciales. Puede leer datos y escribir 
% resultados del programa GMSH.
% -------------------------------------------------------------------------
% Dorian L. Linero S.
% Universidad Nacional de Colombia
% Facultad de Ingeniería
% Todos los derechos reservados, febrero 2021

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
fprintf('PORTRI/PEFICA: Analisis elastico lineal de pórticos tridimension. \n');
fprintf('escriba PEFICA <nombre archivo datos .m o .msh> <opciones lectura>\n');
fprintf('el parametro <opciones lectura> puede ser igual a: \n');
fprintf('=0 : lectura de datos en archivo .m y escritura resultados en\n');
fprintf('     en ventana de comandos\n');
fprintf('=1:  lectura de datos en archivo .m y escritura resultados\n');
fprintf('     en archivo .pos de GMSH\n');
fprintf('=9:  lectura de datos en archivo .m y escritura malla en TikZ\n');
fprintf('=10: lectura de datos en archivo .msh de GMSH y escritura resultados\n');
fprintf('     en archivo .pos de GMSH\n');
fprintf('=11: lectura de datos en archivo .msh de GMSH y escritura resultados\n');
fprintf('     en archivo .pos de GMSH y en la ventana de comandos\n');
fprintf('=20: lectura de datos en archivo .geo de GMSH, creación automática de\n'); 
fprintf('     malla en archivo .msh y escritura resultados en archivo .pos de GMSH\n');
fprintf('=19: lectura de datos en archivo .msh de GMSH y escritura malla en TikZ\n'); 
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
    fprintf('\n');
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
    [NNUD,NELE,NNUE,NDIM,NCAT,TIPR,IMPR,...
     XYZ,ELE,CAT,UCO,FUN,FDI,SUP] = LEGMSH(ADAD); 
    
    % convertir despl conoc de formato B a formato A
    NGLN=2*NDIM; % grados de libertad por nudo
    [TEM] = ORVEBA(UCO,TLEN,NGLN,0); UCO=TEM;
    % convertir FUN de formato B a formato A
    [TEM] = ORVEBA(FUN,TLEN,NGLN,1); FUN=TEM; 
  end %endif
  
  ELE = int32(ELE); % cambio de tipo de datos para las matrices enteras
  % parámetros adicionales para el tipo de problema
  if TIPR==11 % barras 3D
    % pórtico tridimensional
    PMAT = 3; % número de propiedades de cada material [ EYOU POIS GAMM ]
    PELE = 10+3; % número de propiedades y carga distribuida de cada elemento 
              % [ AREA INEY INEZ JTOR ALSH WYLO WZLO VELX VELY VELZ ] : 10
              % tipo de elemento, número de nudos y número de PG
              % [ TIPE NUEL PGAU ] : 3
    PCAT = PMAT+PELE;    % número de propiedades en cada categoria
  else
    % no es un problema de barras 3D
    fprintf('\n');
    error('PEFICA. Este no es un problema de barras 3D.')
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
    % matriz de rigidéz de elemento en sistema coordenado global
    CAE(1:PCAT) = CAT(ELE(IELE,1),1:PCAT); % propiedades de la categ eleme IELE
    NUEL = CAE(1,PCAT-1);  % número de nudos del elemento IELE
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
  
%  TINI = IMTIEM('Vector de fuerzas de cuerpo en el solido',0);
  % -------------------------------------------------------------------------
  
  
  % PENDIENTE
  FGC = zeros(NGLT,1); % definición de tamaño del vector de fuer cuerp sólido
%  GAMT = sum(CAT(:,3));
%  
%  GAMT=0; % ELIMINAR CUANDO SE ACTUALICE
%  
%  if GAMT~=0; % contror de problemas sin fuerzas de cuerpo GAMM=0
%    for IELE = 1:NELE
%      % matriz de rigidéz de elemento
%      GAMM = CAT(ELE(IELE,1),3); % peso específico del elemento IELE
%      AREA = CAT(ELE(IELE,1),4); % área de la secc transv del elemento IELE
%      WZGA = GAMM*AREA; % carga distribuida uniforme debida al peso propio
%      XYE(1:NUEL,1:NDIM) = XYZ(ELE(IELE,2:NUEL+1),1:NDIM); % coor nud de elem IELE
%      [FEL] = FELEMS(XYE,WZGA) % vector de fuerzas equiv a carga distrib
%      % ensamblaje de FEL() del elemento IELE en FGC() del sólido
%      NFEL = size(FEL,1); % tamaño de vector del elemento
%      for IFEL=1:NFEL
%        if INC(IELE, IFEL) ~= 0
%          FGC(INC(IELE, IFEL), 1) = FGC(INC(IELE, IFEL), 1) + FEL(IFEL,1);
%        end % endif
%      end % endfor IFEL
%      % fin ensamblaje
%    end % endif  IELE
%  end % endif
%  TFIN = IMTIEM('',TINI);

  TINI = IMTIEM('Vector de fuerzas equival a cargas distrib en los elementos',0);
  % -------------------------------------------------------------------------
  FGS=zeros(NGLT,1); % inicialización del vector de fuerzas eq a cargas distr de la estructura 
  for IELE = 1:NELE
    WYLO = CAT(ELE(IELE,1),9); % carga distribuida en el elemento en y-local
    WZLO = CAT(ELE(IELE,1),10); % carga distribuida en el elemento en y-local
    if WYLO~=0||WZLO~=0
      XYE(1:NUEL,1:NDIM) = XYZ(ELE(IELE,2:NUEL+1),1:NDIM); % coor nud de elem IELE
      [FEL] = FELEMS(XYE,WYLO,WZLO); % vector de fuerzas equiv a carga distrib
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
  [FXY] = ORVETA(FTO,MGL); % tabla de fuerzas nodales en formato FX,FY,FZ,MX,MY,MZ
  TFIN = IMTIEM('',TINI);
    
  % presentar desplazamientos y fuerzas en los nudos
  if TLEN==0 || TLEN==11
   % desplazamientos
   fprintf('-------------------------------------------------------------------------------\n');
   fprintf('Desplazamientos en los nudos en sistema coordenado global\n');
   fprintf('   NUD          UX          UY          UZ          RX          RY          RZ\n');
   TEM = [double(1:NNUD);UXY'];
   fprintf('%6i %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e\n',TEM);
   
   % fuerzas
   fprintf('-------------------------------------------------------------------------------\n');
   fprintf('Fuerzas en los nudos en sistema coordenado global\n');
   fprintf('   NUD          FX          FY          FZ          MX          MY          MZ\n');
   TEM = [double(1:NNUD);FXY'];
   fprintf('%6i %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e\n',TEM);
   
  end %endif

  % calcular y guardar fuerzas internas en los extremos de cada elemento 
  TINI = IMTIEM('Fuerza interna en cada elemento',0);
  SRE = zeros(NELE,12); % crear tabla de resultados por elemento
  for IELE = 1:NELE % ciclo por elemento
  
    CAE(1:PCAT) = CAT(ELE(IELE,1),1:PCAT); % propiedades de la categ eleme IELE
    TIPE = CAE(1,PCAT-2);  % tipo de elemento IELE
    NUEL = CAE(1,PCAT-1);  % número de nudos del elemento IELE
    WYLO = CAE(1,9); % carga distribuida en el elemento en y-local
    WZLO = CAE(1,10); % carga distribuida en el elemento en z-local
    VEL = CAE(1,11:13); % vector auxiliar para determinar el plano xy-local
    %
    NGLE = NUEL*NDIM*2; % número de grados de libertad por elemento IELE
    XYE(1:NUEL,1:NDIM) = XYZ(ELE(IELE,2:NUEL+1),1:NDIM); % coor nud de elem IELE
    KEL = KELEME(TIPR,XYE,CAE); % matriz de rigidez del elem IELE sis global
    FEL = FELEMS(XYE,WYLO,WZLO); % vector de fuerzas equiv a carga distrib sis global 
    UEG = EXTRAV(UTO,INC,IELE,NGLE); % vec despl nodales del elem en sis global
    FIG = KEL * UEG - FEL; % vec fuerzas internas del elem en sis global
    [LONE,TRA] = PBTRAN(XYE,TIPE,VEL);   % longitud y matriz de transformación del elem
    FIL = TRA * FIG; % vec fuerzas internas del elem en sis local
    SRE(IELE,:) = FIL; % tabla de fuerzas internas de los elementos en sis local
  
  end % endfor
  TFIN = IMTIEM('',TINI); % tiempo de ejecución
  
  % presentar resultados en los elementos
  if TLEN==0 || TLEN==11
   fprintf('-------------------------------------------------------------------------------\n');
   fprintf('Resultados en los extremos de los elementos en sistema coord local\n');
   fprintf('    ELE   NUD        FLX        FLY        FLZ        MLX        MLY        MLZ\n');
   for IELE=1:NELE
    TEM = [IELE ELE(IELE,2) SRE(IELE,1:6)];
    fprintf('%6i %6i %+10.3e %+10.3e %+10.3e %+10.3e %+10.3e %+10.3e\n',TEM);
    TEM = [IELE ELE(IELE,3) SRE(IELE,7:12)];
    fprintf('%6i %6i %+10.3e %+10.3e %+10.3e %+10.3e %+10.3e %+10.3e\n',TEM);
   end % endfor
  end % endif
  
  % impresión de archivos de postproceso para GMSH
  if TLEN==1 || TLEN==10 || TLEN==11 || TLEN==20
    TINI = IMTIEM('Presentacion de resultados en GMSH ',0);
    % -----------------------------------------------------------------------
    if TLEN==1; SUP=ELE(:,1)'; end;
    
    % transformación de la malla donde cada barra se divide en NTRA tramos
    NTRA=10;  % número de tramos en que se divide cada barra
    for IELE=1:NELE
      CAE(1:PCAT) = CAT(ELE(IELE,1),1:PCAT); % propiedades de la categ eleme IELE
      TIPE = CAE(1,PCAT-2);  % tipo de elemento IELE
      NUEL = CAE(1,PCAT-1);  % número de nudos del elemento IELE
      VEL = CAE(1,11:13); % vector auxiliar para determinar el plano xy-local
      XYE(1:NUEL,1:NDIM) = XYZ(ELE(IELE,2:NUEL+1),1:NDIM); % coor nud de elem IELE
      [LONE,TRA] = PBTRAN(XYE,TIPE,VEL);   % longitud y matriz de transformación del elem
      % coords de los nudos nuevos en los tramos de cada barra
      for ITRA=1:(NTRA-1)
        NUDT = NNUD+(IELE-1)*(NTRA-1)+ITRA;
        XYZ(NUDT,:) = XYZ(ELE(IELE,2),:) + (LONE*ITRA/NTRA).*TRA(1,1:3);
      end % ednfor ITRA
      
      % conectividades de los nuevos elementos en los tramos de cada barra
      for ITRA=1:NTRA
        IELT = (IELE-1)*NTRA+ITRA;
        NUDT = NNUD+(IELE-1)*(NTRA-1)+ITRA;
        if ITRA==1
          ELT(IELT,:) = [ELE(IELE,1) ELE(IELE,2) NUDT];
        elseif ITRA==NTRA
          ELT(IELT,:) = [ELE(IELE,1) NUDT-1 ELE(IELE,3)];
        else
          ELT(IELT,:) = [ELE(IELE,1) NUDT-1 NUDT];
        end % endif
        
      end % endfor
    end % endfor IELE
    NNUT = size(XYZ,1); % número total de nudos
    NELT = size(ELT,1); % número total de elementos
    AXL = zeros(NNUT,9); % tabla de vectores unitarios de ejes locales
    
    % cálculo de los desplazamientos en los nudos internos a partir de las
    % funciones de forma del elemento
    UXT = UXY(:,1:3); % tabla de desplazamientos UX, UY, UZ
    for IELE=1:NELE
      CAE(1:PCAT) = CAT(ELE(IELE,1),1:PCAT); % propiedades de la categ eleme IELE
      TIPE = CAE(1,PCAT-2);  % tipo de elemento IELE
      NUEL = CAE(1,PCAT-1);  % número de nudos del elemento IELE
      VEL = CAE(1,11:13); % vector auxiliar para determinar el plano xy-local
      NGLE = NUEL*NDIM*2; % número de grados de libertad por elemento IELE
      XYE(1:NUEL,1:NDIM) = XYZ(ELE(IELE,2:NUEL+1),1:NDIM); % coor nud de elem IELE
      % vector de desplazamientos nodales de un elemento de pórtico espacial
      UEG = EXTRAV(UTO,INC,IELE,NGLE); % vec despl nodales del elem en sis global
      [LONE,TRA] = PBTRAN(XYE,TIPE,VEL);   % longitud y matriz de transformación del elem
      UEL = TRA * UEG; % vec desplaz nodales del elem en sis local
      
      % tabla de vectores unitarios de los ejes locales de los elementos
      NUDC = NNUD+(IELE-1)*(NTRA-1)+round(NTRA/2); % nudo en el centro de cada elemento
      AXL(NUDC,1:3) = TRA(1,1:3); % vector dirección x-local
      AXL(NUDC,4:6) = TRA(2,1:3); % vector dirección y-local
      AXL(NUDC,7:9) = TRA(3,1:3); % vector dirección z-local
      
      % desplazamientos en el interior de cada elemento
      % ----------------------------------------------------------------------
      for ITRA=1:(NTRA-1)
        RTRA = ITRA/NTRA;
        % matriz de funciones de forma de un elemento de pórtico espacial
        % desplazamiento axial de orden lineal C0,
        % deflexión en el plano xy de orden cúbico de continuidad C1.
        % deflexión en el plano xz de orden cúbico de continuidad C1. 
        NXY=zeros(3,12);
        NXY(1,1) = 1-RTRA;
        NXY(1,7) = RTRA;
        NXY(2,2) = 1 - 3*RTRA^2 + 2*RTRA^3;
        NXY(2,6) = LONE*(RTRA - 2*RTRA^2 + RTRA^3);
        NXY(2,8) = 3*RTRA^2 - 2*RTRA^3;
        NXY(2,12) = LONE*( -RTRA^2 + RTRA^3);
        NXY(3,3) = 1-3*RTRA^2+2*RTRA^3;
        NXY(3,5) = LONE*(RTRA-2*RTRA^2+RTRA^3);
        NXY(3,9) = 3*RTRA^2-2*RTRA^3;
        NXY(3,11) = LONE*(-RTRA^2+RTRA^3);
        % desplazamiento en sis local ULO = [ UXL UYL UZL ] y global UGL
        ULO = NXY * UEL;
        UGL = TRA(1:3,1:3)' * ULO;
        NUDT = NNUD+(IELE-1)*(NTRA-1)+ITRA;
        % tabla de desplazamientos UX, UY, UZ en todos los nudos
        UXT(NUDT,:) = UGL';
      end % endfor ITRA
    end % endfor IELE
    
    
    
    % fuerzas internas en cada tramo de todos los elementos
    % ----------------------------------------------------------------
    SRT = zeros(NELT,12);
    for IELE=1:NELE
      TIPE = CAE(1,PCAT-2);  % tipo de elemento IELE
      WYLO = CAE(1,9); % carga distribuida en el elemento en y-local
      WZLO = CAE(1,10); % carga distribuida en el elemento en z-local
      VEL = CAE(1,11:13); % vector auxiliar para determinar el plano xy-local
      FYLI = SRE(IELE,2); % fuerza en dirección y-local en el extremo inicial
      MZLI = SRE(IELE,6); % momento en dirección z-local en el extremo inicial
      FZLI = SRE(IELE,3); % fuerza en dirección z-local en el extremo inicial
      MYLI = SRE(IELE,5); % momento en dirección y-local en el extremo inicial
      FXLI = SRE(IELE,1); % fuerza en dirección x-local en el extremo inicial
      MXLI = SRE(IELE,4); % momento en dirección x-local en el extremo inicial
      XYE(1:NUEL,1:NDIM) = XYZ(ELE(IELE,2:NUEL+1),1:NDIM); % coor nud de elem IELE
      [LONE,TRA] = PBTRAN(XYE,TIPE,VEL);   % longitud y matriz de transformación del elem
      for ITRA = 1:NTRA
        IELT = (IELE-1)*NTRA+ITRA;
        for IEXT = 1:2
          RTRA = (ITRA-2+IEXT)/NTRA;
          XPOS = RTRA*LONE; % posición en el interior de la barra
          
          % flexión en el plano xy-local
          VYIN = FYLI + WYLO*XPOS; % fuerza cortante en y-local
          MZIN = - MZLI + FYLI*XPOS + 0.5*WYLO*XPOS^2; % momento flector en z-local
          % tabla de fuerzas internas en los tramos
          SRT(IELT,6*(IEXT-1)+2)=VYIN;
          SRT(IELT,6*(IEXT-1)+6)=MZIN;
          
          % flexión en el plano xz-local
          VZIN = FZLI + WZLO*XPOS; % fuerza cortante en z-local
          MYIN = MYLI + FZLI*XPOS + 0.5*WZLO*XPOS^2; % momento flector en y-local
          % tabla de fuerzas internas en los tramos
          SRT(IELT,6*(IEXT-1)+3)=VZIN;
          SRT(IELT,6*(IEXT-1)+5)=MYIN;
          
          % fuerza axial
          NXIN = -FXLI;
          SRT(IELT,6*(IEXT-1)+1)=NXIN;
          SRT(IELT,6*(IEXT-1)+1)=NXIN;
          
          % torsión
          TXIN = -MXLI;
          SRT(IELT,6*(IEXT-1)+4)=TXIN;
          SRT(IELT,6*(IEXT-1)+4)=TXIN;
          
        end % endfor IEXT
      end % endfor ITRA
    end % endfor IELE
    
    IMGMSH(ADAD,NNUD,NELE,NNUE,NCAT,XYZ,ELT,AXL,UXT,FXY,SRT);
    TFIN = IMTIEM('',TINI); % tiempo de ejecución
    
    % abrir archivo .pos en el entorno de postproceso de GMSH
    if TLEN==20
      [~,OSMS] = system(['gmsh ./DATOS/' ADAT '.pos']);
      fprintf(OSMS);
    end % endif
   
  end % endif
  
  % presentar geometría en TikZ
  if TLEN==9 || TLEN==19
     TINI = IMTIEM('Dibujar de geometría en Tikz LaTex ',0);
   % -----------------------------------------------------------------------
    % construir archivo gráfico tikz para latex con geometría
    ADAD = strcat('./DATOS/',ADAT);
    TIPN = 3; % 0=sin numeración, 1=numeración nudos
%               2=numeración elementos, 3=numeración nudos y elementos.
    IMTIKZ(ADAD,NNUD,NELE,NNUE,XYZ,ELE,CAT,UCO,FUN,TIPN);
    TFIN = IMTIEM('',TINI); % tiempo de ejecución
  end % endif IMPR

  
  % mostrar tiempo final
  TFIN = IMTIEM('Tiempo total de ejecucion del programa                      ',TINT);
end
