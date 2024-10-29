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
200E6 1963.5E-06 102 ;      % 1
200E6 490.87E-06 102 ];     % 2             

             
% Tabla de conectividades de los elementos: ELE()
% El número de la fila corresponde al número del elemento finito y cada columna 
% contiene: ICAT: categoría , NUDI: id del primer nudo,
%           NUDJ: id del segundo nudo, NUDK: id del tercer nudo si existe (opcional)
% formato:  ELE = [ ICAT NUDI NUDJ ... ] % IELE
ELE = [ ...
  1  1  3  2;   % 1
  1  3  5  4;   % 2
  2  5  7  6;   % 3
  2  7  9  8;   % 4
  2  9 11 10;   % 5
  2 11 13 12];  % 6
% Tabla de coordenadas de los nudos: XYZ()
% El número de la fila corresponde al número del nudo y cada columna 
% incluye:  XNUD: coordenada x del nudo 
% formato:  XYZ = [ XNUD ] % INUD
XYZ = [ ...
 0.00 ;     % 1 
 1.00 ;     % 2
 2.00 ;     % 3
 3.00 ;     % 4
 4.00 ;     % 5
 4.50 ;     % 6
 5.00 ;     % 7
 5.50 ;     % 8
 6.00 ;     % 9
 6.50 ;     % 10
 7.00 ;     % 11
 7.50 ;     % 12
 8.00 ];    % 13
 
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
013 1 0.0000 ];

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
009 50.0 ];

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
002 10.0 ];
