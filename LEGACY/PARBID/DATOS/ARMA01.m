% PBARCA archivo de datos de entrada
% -----------------------------------
% datos generales
NELE = 7;    % número de elementos
NNUD = 5;    % número de nudos
NNUE = 2;    % número máximo de nudos por elemento
NGAU = 1;    % número máximo de puntos de Gauss por elemento
NDIM = 2;    % número de dimensiones
NCAT = 2;    % número de categorias de elementos
TIPR = 10;   % código del tipo de problema:
             % 10: armaduras planas
ENNU = 0;    % tipo de evaluación de esfuerzos/deformaciones en el elemento
             % 0: eval en PG, 1: eval en los nudos, 2: eval en centro del elemen
IMPR = 3;    % tipo de impresión de los resultados
             % 0: ninguno, 1: en ventana de comandos, 2: en GiD,
             % 3: en VC, GiD y Tikz LaTeX, 4: en Tikz LaTeX

% tabla de categoría y conectividades de los elementos: ELE()
% incluye: categoría ICAT, primer nudo NUDI, segundo nudo NUDJ, tercer nudo NUDK
% ELE = [ ICAT NUDI NUDJ NUDK ] % IELE
ELE = [ ...
  1 1 2 ;   % 1
  1 2 3 ;   % 2
  1 4 5 ;   % 3
  2 1 4 ;   % 4
  2 4 2 ;   % 5
  2 2 5 ;   % 6
  2 3 5 ];  % 7

% tabla de coordenadas de los nudos: XYZ()
% incluye: coord. x: XNUD, coord. y: YNUD
% XYZ = [ XNUD YNUD ] % INUD
XYZ = [ ...
 0.00 0.00 ;    % 1
 6.00 0.00 ;    % 2
12.00 0.00 ;    % 3
 3.00 4.00 ;    % 4
 9.00 4.00 ];   % 5

% tabla de categorias de los elementos: CAT()
% incluye tipos de material y tipo de elemento
% propiedades del material: módulo de Young :EYOU, relación de Poisson: POIS,
%                           peso específico GAMM.
% propiedades del elemento: espesor: TESP,
%                           tipo: TIPE, num. nudos: NUEL, puntos Gauss: PGAU
% CAT = [ EYOU POIS GAMM AREA TIPE NUEL PGAU ] % ICAT
CAT = [ ...
200E6 0.25 0.00 0.002 101 2 1 ;    % 1
200E6 0.25 0.00 0.001 101 2 1 ];   % 2

% tabla de desplazamientos conocidos: UCO()
% incluye número del nudo INUD, indicador si el desplazamiento es conocido o no,
% y valor del desplazamiento conocido.
% Indicador del desplazamiento en x: DCUX, vale 0:desconocido 1:conocido;
% indicador del desplazamiento en y: DCUY, vale 0:desconocido 1:conocido;
% valor del desplazamiento conocido en x: VAUX,
% valor del desplazamiento conocido en y: VAUY.
% VAUX no será leida si el desplazamiento es desconocido, es decir DCUX=0,
% VAUY no será leida si el desplazamiento es desconocido, es decir DCUY=0.
% UCO = [ INUD DCUX DCUY VAUX VAUY ]
UCO = [ ...
001 1 1 0.0000 0.0000 ; ...
003 0 1 0.0000 0.0000 ; ...
];

% tabla de fuerzas aplicadas en los nudos de la malla. Incluye número del
% nudo INUD, valor de la fuerza en dirección x FUNX y valor de la fuerza
% en dirección y FUNY.
% FUN = [ INUD FUNX FUNY ]
FUN = [ ...
004 100.0 -50.0 ; ...
005   0.0 -50.0 ; ...
];

% tabla de fuerzas uniformes distribuidas que se aplican en las caras
% de los elementos. Incluye número del elemento IELE, número de los nudos
% inicial y final de la cara cargada NUDI y NUDJ, valor de la presión en
% dirección x y en dirección y, PREX y PREY, y indicador del sistema
% coordenado de la carga GLOC: =0: global, =1: local.
% FDI = [ IELE NUDI NUDJ PREX PREY GLOC
FDI = [ ...
000 000 000 0.0 0.0 0 ;...
];

% tabla control de incrementos de carga en el tiempo,
% donde NPAS es numero de incrementos de carga y 
% LAMB es el tamano del incremento
% TIE = [ NINC LAMB ]
TIE = [ ...
10 0.1 ; ...
];
