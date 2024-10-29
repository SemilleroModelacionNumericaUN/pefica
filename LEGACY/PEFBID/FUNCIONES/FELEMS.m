% -----------------------------------------------------------------------------
% Vector de fuerzas de superficie del elemento finito
% Entrada:  CAE():  propiedades del catergoría del elemento
%           LLAD:   longitud del lado cargado del elemento
%           NLA():  vector identificador del lado como se describe en PBLADO
%           VLA():  vector normal al lado cargado entrante al ef
%           FDE():  presiones y ident sistema coord global o local
%                 = [ IELE NUDI NUDJ PREX PREY GLOC ]
%                   Si GLOC=0: [ IELE NUDI NUDJ PREX PREY 0 ]
%                   PREX,PREY son las componentes de la presión en las direc
%                   x y y en sistema coordenado global.
%                   Si GLOC=1: [ IELE NUDI NUDJ PREN PRET 1 ]
%                   PREN,PRET son las componentes de la presión en las direc
%                   normal (x-local) y tangencial (y-local). La direc x-local
%                   es normal al lado cargado y es positiva entrando al 
%                   elemento finito. La direc y-local es paralela al lado con
%                   carga conservando un sis coor derecho entre x-local, 
%                   y-local y z (saliendo de la pantalla).
%                   Si GLOC=2: [ IELE NUDI NUDJ PREI PREJ 2 ]
%                   PREI,PREJ son las presiones normales en los nudos I y J,
%                   positivas entrando al elemento finto, calculadas previamente
%                   en LEGMSH, a partir de los parámetros GAWA y HEWA.
%                   
%                 
% Salida:   FEL():  vector de fuerzas de superficie del elemento  
% -----------------------------------------------------------------------------
function [FEL] = FELEMS(CAE,LLAD,NLA,VLA,FDE)

  TESP = CAE(4);  % espesor del elemento
  TIPE = CAE(5);  % código del tipo de elemento

  switch TIPE
    case 201 % elemento 2D triangular lineal
      [FEL] = FTRIES(3,TESP,LLAD,NLA,VLA,FDE);
    case 202 % elemento 2D cuadrilateral bilineal
      [FEL] = FTRIES(4,TESP,LLAD,NLA,VLA,FDE);
    case 203 % elemento 2D triangular cuadrático
      % pendiente
    case 204 % elemento 2D cuadrilateral bicuadrático
      % pendiente
    otherwise
      error('FELEMS. Tipo incorrecto de elemento finito');
  end
 
end


% ------------------------------------------------------------------------
% Vector de fuerzas de superficie del elemento triangular lineal o
% cuadrilateral bilineal
function [FEL] = FTRIES(NNUE,TESP,LLAD,NLA,VNR,FDE)
  % Entrada:  NNUE:   número de nudos del elemento
  %           TESP:   espesor del elemento
  %           LLAD:   longitud del lado cargado del elemento
  %           NLA():  vector identificador del lado como se describe en PBLADO
  %           VNR():  vector normal al lado cargado entrando al elemento
  %           FDE():  presiones y ident sistema coord global o local
  %                 = [ IELE NUDI NUDJ PREX PREY GLOC ]
  % Salida:   FEL():  vector de fuerzas de superficie del elemento  
  
  NGLN = 2;  % número de GL por nudo
  FEL = zeros(NNUE*NGLN,1); % definición de tamaño del vec del fuerzas de superficie
  
  if FDE(6)==0 % presiones uniformes dadas en sistem coord global
    
    NLA=abs(NLA);
    for INUE = 1:NNUE
        FEL(2*INUE-1,1) = NLA(1,INUE)*FDE(4)*TESP*LLAD/2;
        FEL(2*INUE  ,1) = NLA(1,INUE)*FDE(5)*TESP*LLAD/2;
    end % endfor
  
  elseif FDE(6)==1  % presiones uniformes dadas en sistem coord local
    
    NLA=abs(NLA);
    for INUE = 1:NNUE
        FEL(2*INUE-1,1) = (NLA(1,INUE)*TESP*LLAD/2)*...
                          (FDE(4)*VNR(1)-FDE(5)*VNR(2));
        FEL(2*INUE  ,1) = (NLA(1,INUE)*TESP*LLAD/2)*...
                          (FDE(4)*VNR(2)+FDE(5)*VNR(1));
    end % endfor
  
  elseif FDE(6)==2  % presión de variación lineal normal al lado
    
    % en dirección normal a lado
    PREI=FDE(4); % presión en el extremo inicial
    PREJ=FDE(5); % presión en el extremo final
    FUEI=TESP*LLAD*(2*PREI+PREJ)/6;  % fuerza equivalente en el extremo inicial
    FUEJ=TESP*LLAD*(PREI+2*PREJ)/6;  % fuerza equivalente en el extremo final
    % en sistema global
    FUXI=FUEI*VNR(1); % fuerza equivalente en el extremo inicial en direc-x
    FUYI=FUEI*VNR(2); % fuerza equivalente en el extremo inicial en direc-y
    FUXJ=FUEJ*VNR(1); % fuerza equivalente en el extremo final en direc-x
    FUYJ=FUEJ*VNR(2); % fuerza equivalente en el extremo final en direc-y

    for INUE = 1:NNUE
      if NLA(1,INUE)==1
        % nudo inicial del lado cargado
        FEL(2*INUE-1,1) = abs(NLA(1,INUE))*FUXI;
        FEL(2*INUE  ,1) = abs(NLA(1,INUE))*FUYI;
      elseif NLA(1,INUE)==-1
        % nudo final del lado cargado
        FEL(2*INUE-1,1) = abs(NLA(1,INUE))*FUXJ;
        FEL(2*INUE  ,1) = abs(NLA(1,INUE))*FUYJ;
      end % endif
    end % endfor
    
  end % endif
  
end

