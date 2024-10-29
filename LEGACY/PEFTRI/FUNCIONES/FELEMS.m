% Vector de fuerzas de superficie del elemento finito tridimensional
%
function [FEL] = FELEMS(TIPE,XYE,XYC,ELA,FDE)
  % Entrada:  TIPE:   id del tipo de elemento finito
  %           XYE():  coordenadas de los nudos del elemento
  %           XYC():  coordenadas de los nudos de la cara cargada
  %           ELA():  id de los nudos del elemento (conectividades)
  %           FDE():  presiones y ident sistema coord global o local
  %                 = [ IELE NUDI NUDJ NUDK PREX PREY PREZ GLOC ]
  % Salida:   FEL():  vector de fuerzas de superficie del elemento
  
  switch TIPE
  case 301 % elemento 3D tetrahédrico lineal
    FEL = FTETRS(XYE,XYC,ELA,FDE);
  case 302 % elemento 3D hexahédrico bilineal
    % pendiente
  otherwise
    % pendiente
  end
 
end

% ---------------------------------------------------------------------
% Vector de fuerzas de superficie del elemento finito tetraédrico
function [FEL] = FTETRS(XYE,XYC,ELA,FDE)
  % Entrada:  XYE():  coordenadas de los nudos del elemento
  %           XYC():  coordenadas de los nudos de la cara cargada
  %           ELA():  id de los nudos del elemento (conectividades)
  %           FDE():  presiones y ident sistema coord global o local
  %                 = [ IELE NUDI NUDJ NUDK PREX PREY PREZ GLOC ] para GLOC=0
  %                 = [ IELE NUDI NUDJ NUDK    0 PREN    0 GLOC ] para GLOC=1
  %                 = [ IELE NUDI NUDJ NUDK GAWA HEWA    0 GLOC ] para GLOC=2
  % Salida:   FEL():  vector de fuerzas de superficie del elemento
  
  % parámetros generales
  NDIM = 3; TIPE = 301;
  [NUEL,NUCA,DUMM] = PBNUEL(TIPE);  % nudos del elemento y de la cara
  FEL = zeros(NDIM*NUEL,1);
  
  % factor de nudo que hace parte de la cara cargada
  FAC = zeros(NUEL,1);
  for INUD=1:NUEL
    for ICAR=1:NUCA
      if ELA(1,INUD)==FDE(1,ICAR+1)
        FAC(INUD) = 1;
      end % endif
    end % endfor ICAR
    if FAC(INUD)==0; NUDL=INUD; end % orden del nudo que no es parte de la cara
  end % endfor INUD
  
  % área de la cara cargada (triángulo en el espacio)
  % vectores entre el nudo inicial de la cara y los otros nudos que la conforman
  VIJ = [(XYC(2,1)-XYC(1,1))  (XYC(2,2)-XYC(1,2)) (XYC(2,3)-XYC(1,3))];
  VIK = [(XYC(3,1)-XYC(1,1))  (XYC(3,2)-XYC(1,2)) (XYC(3,3)-XYC(1,3))];
  VNR = cross(VIJ,VIK); % vector normal a la cara
  NVNR = norm(VNR); % norma del vector normal a la cara
  AREA = NVNR/2; % área de la cara
  PRW = zeros(1,3); % componentes de presión en sis coord global
  
  if FDE(8)==2 % presión hidráulica con respecto al eje y.
    GAWA = FDE(5); % peso específico del agua
    HEWA = FDE(6); % posición de la capa de agua con respecto a y
    YPRO = (XYC(1,2)+XYC(2,2)+XYC(3,2))/3; % posición promedio de la cara en y
    if YPRO<=HEWA
      PRWA = GAWA*(HEWA-YPRO); % presión hidráulica en la posición promedio y
    else
      PRWA = 0; % no hay presión hidráulica por encima de la capa de agua
    end % endif
  end % endif
  
  if FDE(8)==1 || FDE(8)==2 % presión normal a la cara
    % calcula un vector unitario normal a la cara que entra al elemento finito
    % cuando se aplica una presión uniforme normal a la cara
    VNR = (1/NVNR).*VNR; % vector unitario normal a la cara
    % vector entre el nudo inicial de la cara y el nudo que no pertenece a ella
    VIL = [(XYE(NUDL,1)-XYC(1,1))  (XYE(NUDL,2)-XYC(1,2)) (XYE(NUDL,3)-XYC(1,3))];
    NVIL = norm(VIL); % norma del vector anterior
    VIL = (1/NVIL).*VIL; % vector unitario entre nud ini de cara y el nud que no pertenece
    DPOS = dot(VNR, VIL); % producto punto entre VNR y VIL
    if DPOS<0; VNR=-VNR; end % asegura que VIL entra en la cara del elemento
    % presión normal a la cara (positiva cuando entra al elemento)
    if FDE(8)==1; PRWN = FDE(6); end % directamente definida en la entrada de datos
    if FDE(8)==2; PRWN = PRWA  ; end % calculada como presión hidráulica
    % componentes de la carga en el sistema coord global
    PRW(1,1:3) = PRWN.*VNR(1,1:3); % componentes de la presión en sis coord global
  end % endif
  
  if FDE(8)==0 % presión en sistema global
    PRW(1,1:3) = FDE(1,5:7);  % componentes de la presión en sis coord global
  end % endif
  
  % vector de fuerza equivalente
  for INUD=1:NUEL
      FEL(3*INUD-2,1) = FAC(INUD)*PRW(1,1)*AREA/NUCA;
      FEL(3*INUD-1,1) = FAC(INUD)*PRW(1,2)*AREA/NUCA;
      FEL(3*INUD,1)   = FAC(INUD)*PRW(1,3)*AREA/NUCA;
  end % endfor INUD

end