% ------------------------------------------------------------------------------
% PEFICA-Octave Archivo de datos de entrada
% para solo un tipo de elemento finito
% ------------------------------------------------------------------------------
% notas importantes:
% 1. En PEFiCA la numeración de los nudos y los elementos debe ser consecutiva 
%    desde el número uno. Para asegurar esto utilice la instrucción Collapse 
%    de GiD, ubicada en el menú Mesh > Edit Mesh > Collapse > Mesh.
% 2. Las condiciones de borde aplicadas sobre lineas se sobrescriben cuando se 
%    definen más de una vez. Las condiciones de borde aplicadas en puntos
%	 se sobrescriben cuando se definen más de una vez. Las condiciones de
%    borde aplicadas en nudos se sobrescriben a las condiciones de borde
%    aplicadas sobre lineas, pero no viceversa.
% 3. Las fuerzas distribuidas sobre líneas se sobrescriben cuando se definen
%	 más de una vez. Las fuerzas puntuales sobre puntos se sobrescriben cuando 
%    se definen más de una vez. 
%    
*intformat "%i"
% datos generales
NELE = *nelem;    % número de elementos
NNUD = *npoin;    % número de nudos
NNUE = *nnode;    % número máximo de nudos por elemento
*if(ndime==2)
*if(nnode==3)
NGAU = 1;    % número máximo de puntos de Gauss por elemento
*elseif(nnode==4)
NGAU = 4;    % número máximo de puntos de Gauss por elemento
*endif
*endif
NDIM = *ndime;    % número de dimensiones
NCAT = *nmats;    % número de categorias de elementos
*if(strcmp(GenData(Tipo_problema_(TIPR)),"plano_esfuerzos")==0)
TIPR = 20;   % código del tipo de problema:
*else
TIPR = 21;   % código del tipo de problema:
*endif
             % 20: plano de esfuerzos, 21: plano de deformaciones
*if(strcmp(GenData(Presentacion_esfuerzos_(ENNU)),"en_puntos_gauss")==0)
ENNU = 0;    % tipo de evaluación de esfuerzos/deformaciones en el elemento
*elseif(strcmp(GenData(Presentacion_esfuerzos_(ENNU)),"en_nudos")==0)			 
ENNU = 1;    % tipo de evaluación de esfuerzos/deformaciones en el elemento
*elseif(strcmp(GenData(Presentacion_esfuerzos_(ENNU)),"en_centro")==0)
ENNU = 2;    % tipo de evaluación de esfuerzos/deformaciones en el elemento
*endif
             % 0: eval en PG, 1: eval en los nudos, 2: eval en centro del elemen
*if(strcmp(GenData(Impresion_resultados_(IMPR)),"en_ventana_y_gid")==0)			 
IMPR = 3;    % tipo de impresión de los resultados
*elseif(strcmp(GenData(Impresion_resultados_(IMPR)),"en_gid")==0)
IMPR = 2;    % tipo de impresión de los resultados
*elseif(strcmp(GenData(Impresion_resultados_(IMPR)),"en_ventana")==0)
IMPR = 1;    % tipo de impresión de los resultados
*elseif(strcmp(GenData(Impresion_resultados_(IMPR)),"ninguno")==0)
IMPR = 0;    % tipo de impresión de los resultados
*endif
             % 0: ninguno, 1: en ventana de comandos, 2: en GiD, 3: en VC y GiD

% tabla de categoría y conectividades de los elementos: ELE()
% incluye: categoría ICAT, primer nudo NUDI, segundo nudo NUDJ, tercer nudo NUDK
% cuarto nudo NUDL (en cuadrilaterales)
% ELE = [ ICAT NUDI NUDJ NUDK NUDL ] % IELE
ELE = [ ...
*Set var zero=0
*loop elems
*if(ElemsNum<=nelem)
*if(elemsnnode==3)
*if(nnode==4)
*format " %6i %6i %6i %6i %6i %6i"
*if(loopvar==nelem)
*elemsmat *ElemsConec(1) *ElemsConec(2) *ElemsConec(3) *zero ]; % *loopvar
*else
*elemsmat *ElemsConec(1) *ElemsConec(2) *ElemsConec(3) *zero ;  % *loopvar
*endif
*elseif(nnode==3)
*format " %6i %6i %6i %6i %6i"
*if(loopvar==nelem)
*elemsmat *ElemsConec(1) *ElemsConec(2) *ElemsConec(3) ]; % *loopvar
*else
*elemsmat *ElemsConec(1) *ElemsConec(2) *ElemsConec(3) ;  % *loopvar
*endif
*endif
*elseif(nnode==4)
*format " %6i %6i %6i %6i %6i %6i"
*if(loopvar==nelem)
*elemsmat *ElemsConec(1) *ElemsConec(2) *ElemsConec(3) *ElemsConec(4) ]; % *loopvar
*else
*elemsmat *ElemsConec(1) *ElemsConec(2) *ElemsConec(3) *ElemsConec(4) ;  % *loopvar
*endif
*else
error(‘el elemento escogido no ha sido implementado’);
*endif
*else
error(‘el número del elemento es máyor al máximo. Utilice en GiD: Mesh > Edit Mesh > Collapse > Mesh’); 
*endif
*end elems

% tabla de coordenadas de los nudos: XYZ()
% incluye: coord. x: XNUD, coord. y: YNUD
% XYZ = [ XNUD YNUD ] % INUD
XYZ = [ ...
*loop nodes
*format " %+15.6e  %+15.6e "
*if(NodesNum==npoin)
*NodesCoord(1) *NodesCoord(2) ]; % *loopvar
*else
*NodesCoord(1) *NodesCoord(2) ;  % *loopvar
*endif
*end nodes

% tabla de categorias de los elementos: CAT()
% incluye tipos de material y tipo de elemento
% propiedades del material: módulo de Young :EYOU, relación de Poisson: POIS,
%                           peso específico GAMM.
% propiedades del elemento: espesor: TESP,
%                           tipo: TIPE, num. nudos: NUEL, puntos Gauss: PGAU
% CAT = [ EYOU POIS GAMM TESP TIPE NUEL PGAU ] % ICAT
CAT = [ ...
*if(ndime==2)
*if(nnode==3)
*loop materials
*format " %+12.4e %+12.4e %+12.4e %+12.4e %6i"
*if(matnum() == nmats)
*MatProp(1) *MatProp(2) *MatProp(3) *MatProp(4) 201 *nnode 1 ]; % *matnum()
*else
*MatProp(1) *MatProp(2) *MatProp(3) *MatProp(4) 201 *nnode 1 ;  % *matnum()
*endif
*end materials
*elseif(nnode==4)
*loop materials
*format " %+12.4e %+12.4e %+12.4e %+12.4e %2i"
*if(matnum() == nmats)
*MatProp(1) *MatProp(2) *MatProp(3) *MatProp(4) 202 *nnode 4 ]; % *matnum()
*else
*MatProp(1) *MatProp(2) *MatProp(3) *MatProp(4) 202 *nnode 4 ;  % *matnum()
*endif
*end materials
*endif
*endif

% tabla de desplazamientos conocidos: UCO()
% incluye número del nudo INUD, indicador si el desplazamiento es conocido o no,
% y valor del desplazamiento conocido. Si el nudo en la tabla se repite
% se considera la condición de borde presentada
% en la primera fila asociada a dicho nudo.
% Indicador del desplazamiento en x: DCUX, vale 0:desconocido 1:conocido;
% indicador del desplazamiento en y: DCUY, vale 0:desconocido 1:conocido;
% valor del desplazamiento conocido en x: VAUX,
% valor del desplazamiento conocido en y: VAUY.
% VAUX no será leída si el desplazamiento es desconocido, es decir DCUX=0,
% VAUY no será leída si el desplazamiento es desconocido, es decir DCUY=0.
% UCO = [ INUD DCUX DCUY VAUX VAUY ]
UCO = [ ...
*Set Cond Line-Constraints *nodes
*Add Cond Point-Constraints *nodes  
*loop nodes *OnlyInCond
*format "%5i %1i %1i %f %f"
*NodesNum *cond(1,int) *cond(3,int) *cond(2,real) *cond(4,real) ;...
*end
];

% tabla de fuerzas aplicadas en los nudos de la malla. Incluye número del
% nudo INUD, valor de la fuerza en dirección x FUNX y valor de la fuerza
% en dirección y FUNY.
% FUN = [ INUD FUNX FUNY ]
*Set Cond Point-Load *nodes
*if(CondNumEntities>0)
FUN = [ ...
*loop nodes *OnlyInCond
*format "%5i %12.4e %12.4e"
*NodesNum *cond(1) *cond(2) ;...
*end
];
*else
FUN = zeros(1,3); % No hay fuerzas aplicadas en los nudos
*endif

% tabla de fuerzas uniformes distribuidas que se aplican en las caras
% de los elementos. Incluye número identificador del elemento en giD IELE,
% número de los nudos inicial y final de la cara cargada NUDI y NUDJ, 
% valor de la presión en dirección x y en dirección y, PREX y PREY, 
% indicador del sistema % coord de la carga GLOC: =0: global, =1: local.
% FDI = [ IELE NUDI NUDJ PREX PREY GLOC ]
*Set Cond Face-Load    *elems  *CanRepeat
*if(CondNumEntities>0)
FDI = [ ...
*loop elems *OnlyInCond
*format "%6i %6i %6i %+12.4e %+12.4e"
*if(strcmp(cond(1),"GLOBAL")==0)
*elemsnum() *globalnodes(1) *globalnodes(2) *cond(2) *cond(3) 0 ;...
*else
*elemsnum() *globalnodes(1) *globalnodes(2) *cond(2) *cond(3) 1 ;...
*endif
*end
];
*else
FDI = zeros(1,6); % No hay cargas distribuidas en los elementos
*endif



