% PRBOID archivo de datos de entrada:
% ------------------------------------------------------------------------- 
% DEFINICIÓN DE LECTURA DE DATOS Y TIPO DE PROBLEMA
% -------------------------------------------------------------------------
TLEN = 19;             % TLEN = 13: análisis controlado por desplazamientos
                       %        14: análisis controlado por fuerzas
% ------------------------------------------------------------------------- 
% DEFINICIÓN DEL NÚMERO DE PSEUDO-TIEMPOS E INCREMENTOS DE
% CARGA/DESPLAZAMIENTO
% ------------------------------------------------------------------------- 
% LAM = [0:0.5:1]';  % Etapa 1
LAM = [0:0.5:2,2.1:0.1:2.9,2.91:0.01:3.26,3.262]';  % Etapa 1

                       % vector de factor de mayoración de cargas lambda
NPSE = size(LAM,1);    % número de pasos de carga
% ------------------------------------------------------------------------- 
% DEFINICIÓN DE PARÁMETROS PARA EL ESQUEMA DE SOLUCIÓN ITERATIVO
% -------------------------------------------------------------------------
TOLE = 1e-5;           % tolerancia para criterio de convergencia
NMIT = 50;             % número máximo de iteraciones
MTNL = 2;              % MTNL = 0: Solución mediante el método de 
                       %           Newton-Raphson modificado KT0
                       %        1: Solución mediante el método de 
                       %           Newton-Raphson modificado KT1
                       %        2: Solución mediante el método de 
                       %           Newton-Raphson convencional
% ------------------------------------------------------------------------- 
% DEFINICIÓN DE PRESENTACIÓN DE RESULTADOS
% -------------------------------------------------------------------------
PRO = 2;               % PRO = 0: Presentación de resultados promedio en los 
                       %          nudos.
                       %       1: Presentación de resultados en el interior
                       %          de los elementos.
                       %       2: Presentación de resultados para varias
                       %          categorías de material.
                       
                       