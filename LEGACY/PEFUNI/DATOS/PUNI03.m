% PEFICA - PEFUNI archivo de datos de entrada
% -----------------------------------
% ejemplo malla con elementos unidimensionales cuadráticos
% del capítulo 3 del libro
%
% datos generales
TIPR = 10;   % código del tipo de problema:
             % 10: elementos a fuerza axial, 11: elementos a flexión
IMPR = 8;    % tipo de impresión de los resultados
             % 0: ninguno, 1: en ventana de comandos, 2: en gráficas de octave
             % 3: en TikZ LaTeX, 4: promedio en los nudos en pantalla y gráfico,
             % 8: en ventana de comando y en gráfica
             % 9: en todos los anteriores

% Tabla de categorias de los elementos: CAT().
% El número de la fila corresponde al número de la categoría
% incluye propiedades del material: EYOU: módulo de Young 
% propiedades del elemento: AREA: área de la sec.trans. en el problema TIPR=10
%                         o INER: inercia de sec.trans. en el problema TIPR=11
% tipo elemento: TIPE: 101 elem. fuerza axial unidimensional lineal c0,
%                      102 elem. fuerza axial unidimensional cuadrático c0,
%                    o 111 elem. flexión unidimensional cúbico c1.
% formato para TIPR=10:  CAT = [ EYOU AREA TIPE ] % ICAT 
% formato para TIPR=11:  CAT = [ EYOU INER TIPE ] % ICAT 
CAT = [ ...
200E6 1963.5E-06 101 ;      % 1
200E6 490.87E-06 101 ];     % 2             

             
% Tabla de conectividades de los elementos: ELE()
% El número de la fila corresponde al número del elemento finito y cada columna 
% contiene: ICAT: categoría , NUDI: id del primer nudo,
%           NUDJ: id del segundo nudo, NUDK: id del tercer nudo si existe (opcional)
% formato:  ELE = [ ICAT NUDI NUDJ ... ] % IELE
ELE = [ ...
  1  1  2  ;   % 1
  1  2  3  ;   % 2
  1  3  4  ;   % 3
  1  4  5  ;   % 4
  1  5  6  ;   % 5
  1  6  7  ;   % 6
  1  7  8  ;   % 7
  1  8  9  ;   % 8
  1  9 10  ;   % 9
  1 10 11  ;   % 10
  1 11 12  ;   % 11
  1 12 13  ;   % 12
  1 13 14  ;   % 13
  1 14 15  ;   % 14
  1 15 16  ;   % 15
  1 16 17  ;   % 16
  2 17 18  ;   % 17
  2 18 19  ;   % 18
  2 19 20  ;   % 19
  2 20 21  ;   % 20
  2 21 22  ;   % 21
  2 22 23  ;   % 22
  2 23 24  ;   % 23
  2 24 25  ;   % 24
  2 25 26  ;   % 25
  2 26 27  ;   % 26
  2 27 28  ;   % 27
  2 28 29  ;   % 28
  2 29 30  ;   % 29
  2 30 31  ;   % 30
  2 31 32  ;   % 31
  2 32 33  ];  % 32

% Tabla de coordenadas de los nudos: XYZ()
% El número de la fila corresponde al número del nudo y cada columna 
% incluye:  XNUD: coordenada x del nudo 
% formato:  XYZ = [ XNUD ] % INUD
XYZ = [ ...
 0.00 ;     % 1 
 0.25 ;     % 2
 0.50 ;     % 3
 0.75 ;     % 4
 1.00 ;     % 5
 1.25 ;     % 6
 1.50 ;     % 7
 1.75 ;     % 8
 2.00 ;     % 9
 2.25 ;     % 10
 2.50 ;     % 11
 2.75 ;     % 12
 3.00 ;     % 13
 3.25 ;     % 14
 3.50 ;     % 15
 3.75 ;     % 16
 4.00 ;     % 17
 4.25 ;     % 18
 4.50 ;     % 19
 4.75 ;     % 20
 5.00 ;     % 21
 5.25 ;     % 22
 5.50 ;     % 23
 5.75 ;     % 24
 6.00 ;     % 25
 6.25 ;     % 26
 6.50 ;     % 27
 6.75 ;     % 28
 7.00 ;     % 29
 7.25 ;     % 30
 7.50 ;     % 31
 7.75 ;     % 32
 8.00 ];    % 33

% Tabla de desplazamientos conocidos: UCO()
% Para problemas de fuerza axial TIPR=10 contiene:
%   INUD: número del nudo,
%   DCUX: indicador si el desplazam en x es conocido o no (1:conoc o 0:descon),
%   VAUX: valor del desplazamiento conocido.  No importa su valor cuando DCUX=0
% Para problemas de flexión TIPR=11 contiene:
%   INUD: número del nudo,
%   DCUY: indicador si el desplazam en y es conocido o no (1:conoc o 0:descon),
%   VAUY: valor del desplazamiento en y conocido.  No importa su valor si DCUY=0
%   DCRZ: indicador si la rotación en z es conocida o no (1:conoc o 0:descon),
%   VARZ: valor de la rotación en z conocido. No importa su valor cuando DCRZ=0
% formato para TIPR=10:  UCO = [ INUD DCUX VAUX ]
% formato para TIPR=11:  UCO = [ INUD DCUY VAUY DCRZ VARZ ]
UCO = [ ...
001 1 0.0000 ;
033 1 0.0000 ];

% Tabla de fuerzas aplicadas en los nudos de la malla.
% Para problemas de fuerza axial TIPR=10 contiene:
%   INUD: número del nudo
%   FUNX: valor de la fuerza puntual en dirección x.
% Para problemas de flexión TIPR=11 contiene:
%   INUD: número del nudo
%   FUNY: valor de la fuerza puntual en dirección y
%   FUMZ: valor del momento alrededor del eje z.
% Formato para TIPR=10: FUN = [ INUD FUNX ]
% Formato para TIPR=11: FUN = [ INUD FUNX FUMZ ]
FUN = [ ...
025 50.0 ];

% Tabla de fuerzas distribuidas uniformes aplicadas sobre los elementos.
% Para problemas de fuerza axial TIPR=10 contiene:
%   IELE: número del elemento IELE
%   WELE: valor de la carga distribuida uniforme en dirección x.
% Para problemas de fuerza axial TIPR=11 contiene:
%   IELE: número del elemento IELE
%   WELE: valor de la carga distribuida uniforme en dirección y.
% Formato:  FDI = [ IELE WELE ]
FDI = [ ...
001 10.0 ;
002 10.0 ;
003 10.0 ;
004 10.0 ;
005 10.0 ;
006 10.0 ;
007 10.0 ;
008 10.0 ;
009 10.0 ;
010 10.0 ;
011 10.0 ;
012 10.0 ;
013 10.0 ;
014 10.0 ;
015 10.0 ;
016 10.0 ];
