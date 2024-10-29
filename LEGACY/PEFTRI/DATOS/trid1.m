% PEFiCA archivo de datos de entrada
% -----------------------------------
% datos generales
NELE = 5;    % número de elementos
NNUD = 8;    % número de nudos
NNUE = 4;    % número máximo de nudos por elemento
NGAU = 1;    % número máximo de puntos de Gauss por elemento
NDIM = 3;    % número de dimensiones
NCAT = 1;    % número de categorias de elementos
TIPR = 30;   % código del tipo de problema:
             % 30: tridimensional
ENNU = 1;    % tipo de evaluación de esfuerzos/deformaciones en el elemento
             % 0: eval en PG, 1: eval en los nudos, 2: eval en centro del elemen
IMPR = 5;    % tipo de impresión de los resultados
             % 5: en GMSH

% tabla de categoría y conectividades de los elementos: ELE()
% incluye: categoría ICAT, primer nudo NUDI, segundo nudo NUDJ, tercer nudo NUDK
% ELE = [ ICAT NUDI NUDJ NUDK NUDL] % IELE
ELE = [ ...
1 1 3 5 2 ; % 1
1 2 3 8 4 ; % 2
1 2 8 5 6 ; % 3
1 3 5 8 7 ; % 4
1 3 2 8 5 ];% 5

% tabla de coordenadas de los nudos: XYZ()
% incluye: coord. x: XNUD, coord. y: YNUD
% XYZ = [ XNUD YNUD ZNUD] % INUD
XYZ = [ ...
0.0 0.0 0.0 ;   % 1
0.4 0.0 0.0 ;   % 2
0.0 0.3 0.0 ;   % 3
0.4 0.3 0.0 ;   % 4
0.0 0.0 0.3 ;   % 5
0.4 0.0 0.3 ;   % 6
0.0 0.3 0.3 ;   % 7
0.4 0.3 0.3 ];  % 8

% tabla de categorias de los elementos: CAT()
% incluye tipos de material y tipo de elemento
% propiedades del material: módulo de Young :EYOU, relación de Poisson: POIS,
%                           peso específico GAMM.
%                           tipo: TIPE, num. nudos: NUEL, puntos Gauss: PGAU
 % [ EYOU POIS GAMM DUMM TIPE NUEL PGAU ] % ICAT
CAT = [ ...
20E6 0.30 0.00 0 301 4 1 ];   % 1

% tabla de desplazamientos conocidos: UCO()
% incluye número del nudo INUD, indicador si el desplazamiento es conocido o no,
% y valor del desplazamiento conocido.
% Indicador del desplazamiento en x: DCUX, vale 0:desconocido 1:conocido;
% indicador del desplazamiento en y: DCUY, vale 0:desconocido 1:conocido;
% indicador del desplazamiento en z: DCUZ, vale 0:desconocido 1:conocido;
% valor del desplazamiento conocido en x: VAUX,
% valor del desplazamiento conocido en y: VAUY,
% valor del desplazamiento conocido en z: VAUZ,
% VAUX no será leida si el desplazamiento es desconocido, es decir DCUX=0,
% VAUY no será leida si el desplazamiento es desconocido, es decir DCUY=0,
% VAUZ no será leida si el desplazamiento es desconocido, es decir DCUZ=0.
% UCO = [ INUD DCUX DCUY DCUZ VAUX VAUY VAUZ ]
% FORMATO A
UCO = [ ...
001 1 1 1 0.0000 0.0000 0.0000 ; ...
003 1 1 1 0.0000 0.0000 0.0000 ; ...
005 1 1 1 0.0000 0.0000 0.0000 ; ...
007 1 1 1 0.0000 0.0000 0.0000 ; ...
];


% tabla de fuerzas aplicadas en los nudos de la malla. Incluye número del
% nudo INUD, valor de la fuerza en dirección x FUNX y valor de la fuerza
% en dirección y FUNY.
% FUN = [ INUD FUNX FUNY FUNZ ]
FUN = [ ...
008 1000 0.0 0.0 ;...
];

% tabla de fuerzas uniformes distribuidas que se aplican en las caras
% de los elementos. Incluye número del elemento RELE, número de los nudos
% inicial y final de la cara cargada NUDI, NUDJ y NUDK, valor de la presión en
% dirección x, en dirección y y en dirección z, PREX, PREY, PREZ y 
% GLOC indicador del sistema coordenado de la carga.
% FDI = [ RELE NUDI NUDJ NUDK PREX PREY PREZ 0 ]: presión unif en sist global
% FDI = [ RELE NUDI NUDJ NUDK    0 PREN    0 1 ]: presión unif normal a la cara
% FDI = [ RELE NUDI NUDJ NUDK GAWA HEGA    0 2 ]: presión hidráulica
%FDI=zeros(1,8);
FDI = [ ...
002 002 004 008 20000.0 0.0 0.0 0 ;...
003 002 006 008 20000.0 0.0 0.0 0 ];


