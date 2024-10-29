% PEFICA - PEFUNI archivo de datos de entrada
% -----------------------------------
% problema propuesto del libro
% viga en voladizo con sección transversal constante
% y carga distribuida de variación cuadrática
%
% datos generales
TIPR = 11;   % código del tipo de problema:
             % 10: elementos a fuerza axial, 11: elementos a flexión
IMPR = 8;    % tipo de impresión de los resultados
             % 0: ninguno, 1: en ventana de comandos, 2: en gráficas de octave
             % 3: en TikZ LaTeX,
             % 8: en ventana de comando y en gráfica
             % 9: en todos los anteriores

% Tabla de categorias: CAT().
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
1.00  1.00  111 ];  % 1

% Tabla de conectividades de los elementos: ELE()
% El número de la fila corresponde al número del elemento finito y cada columna 
% contiene: ICAT: categoría , NUDI: id del primer nudo,
%           NUDJ: id del segundo nudo, NUDK: id del tercer nudo si existe (opcional)
% formato:  ELE = [ ICAT NUDI NUDJ ... ] % IELE
ELE = [ ...
1 1 2 ;     %1
1 2 3 ;     %2
1 3 4 ;     %3
1 4 5 ;     %4
1 5 6 ;     %5
1 6 7 ;     %6
1 7 8 ;     %7
1 8 9 ;     %8
1 9 10 ;    %9
1 10 11 ];  %10

% Tabla de coordenadas de los nudos: XYZ()
% El número de la fila corresponde al número del nudo y cada columna 
% incluye:  XNUD: coordenada x del nudo 
% formato:  XYZ = [ XNUD ] % INUD
XYZ = [ ...
0.0 ;  %1
0.1 ;  %2
0.2 ;  %3
0.3 ;  %4
0.4 ;  %5
0.5 ;  %6
0.6 ;  %7
0.7 ;  %8
0.8 ;  %9
0.9 ;  %10
1.0 ];  %11

% Tabla de desplazamientos conocidos: UCO()
% Para problemas de fuerza axial TIPR=10 contiene:
%   INUD: número del nudo,
%   DCUX: indicador si el desplazam en x es conocido o no (1:conoc o 0:descon),
%   VAUX: valor del desplazamiento conocido.  No importa su valor cuando DCUX=0
% Para problemas de flexión TIPR=11 contiene:
%   INUD: número del nudo,
%   DCUY: indicador si el desplazam en y es conocido o no (1:conoc o 0:descon),
%   DCRZ: indicador si la rotación en z es conocida o no (1:conoc o 0:descon),
%   VAUY: valor del desplazamiento en y conocido.  No importa su valor si DCUY=0
%   VARZ: valor de la rotación en z conocido. No importa su valor cuando DCRZ=0
% formato para TIPR=10:  UCO = [ INUD DCUX VAUX ]
% formato para TIPR=11:  UCO = [ INUD DCUY DCRZ VAUY VARZ ]
UCO = [ ...
001 1 1 0.0000 0.0000 ];

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
FUN = [ 0 0.0 0.00 ];

% Tabla de fuerzas distribuidas uniformes aplicadas sobre los elementos.
% Para problemas de fuerza axial TIPR=10 contiene:
%   IELE: número del elemento IELE
%   WELE: valor de la carga distribuida uniforme en dirección x.
% Para problemas de fuerza axial TIPR=11 contiene:
%   IELE: número del elemento IELE
%   WELE: valor de la carga distribuida uniforme en direc y, (positiva arriba)
% Formato:  FDI = [ IELE WELE ]
FDI = [ ...
   1.0000e+00  -2.5000e-03;
   2.0000e+00  -2.2500e-02;
   3.0000e+00  -6.2500e-02;
   4.0000e+00  -1.2250e-01;
   5.0000e+00  -2.0250e-01;
   6.0000e+00  -3.0250e-01;
   7.0000e+00  -4.2250e-01;
   8.0000e+00  -5.6250e-01;
   9.0000e+00  -7.2250e-01;
   1.0000e+01  -9.0250e-01];