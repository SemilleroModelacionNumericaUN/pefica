% Vector de fuerzas de superficie del elemento finito
function [FEL] = FELEMS(CAE,LLAD,NLA,VLA,FDE)
  % Entrada:  CAE():  propiedades del catergoría del elemento
  %           LLAD:   longitud del lado cargado del elemento
  %           NLA():  vector identificador del lado como se describe en PBLADO
  %           VLA():  vector unitario direccional del lado
  %           FDE():  presiones y ident sistema coord global o local
  %                 = [ IELE NUDI NUDJ PREX PREY GLOC ]
  % Salida:   FEL():  vector de fuerzas de superficie del elemento  

  TESP = CAE(4);  % espesor del elemento
  TIPE = CAE(5);  % código del tipo de elemento

  switch TIPE
    case 201 % elemento 2D triangular lineal
      [FEL] = FTRIES(3,TESP,LLAD,NLA,VLA,FDE);
    case 202 % elemento 2D cuadrilateral bilineal
      [FEL] = FTRIES(4,TESP,LLAD,NLA,VLA,FDE);
    case 301 % elemento 3D tetrahédrico lineal
      % pendiente
    case 302 % elemento 3D hexahédrico bilineal
      % pendiente
    otherwise
      % pendiente
  end
 
end


% ------------------------------------------------------------------------
% Vector de fuerzas de superficie del elemento triangular lineal o
% cuadrilateral bilineal
function [FEL] = FTRIES(NNUE,TESP,LLAD,NLA,VLA,FDE)
  % Entrada:  NNUE:   número de nudos del elemento
  %           TESP:   espesor del elemento
  %           LLAD:   longitud del lado cargado del elemento
  %           NLA():  vector identificador del lado como se describe en PBLADO
  %           VLA():  vector unitario direccional del lado
  %           FDE():  presiones y ident sistema coord global o local
  %                 = [ IELE NUDI NUDJ PREX PREY GLOC ]
  % Salida:   FEL():  vector de fuerzas de superficie del elemento  
  
  NGLN = 2;  % número de GL por nudo
  FEL = zeros(NNUE*NGLN,1); % definición de tamaño del vec del fuerzas de superficie
  
  if FDE(6) == 0 % presiones dadas en sistem coord global
    for INUE = 1:NNUE
        FEL(2*INUE-1,1) = NLA(1,INUE)*FDE(4)*TESP*LLAD/2;
        FEL(2*INUE  ,1) = NLA(1,INUE)*FDE(5)*TESP*LLAD/2;
    end % endfor
  else  % presiones dadas en sistem coord local
    for INUE = 1:NNUE
        FEL(2*INUE-1,1) = (NLA(1,INUE)*TESP*LLAD/2)*...
                          (FDE(4)*VLA(1)-FDE(5)*VLA(2));
        FEL(2*INUE  ,1) = (NLA(1,INUE)*TESP*LLAD/2)*...
                          (FDE(4)*VLA(2)+FDE(5)*VLA(1));
    end % endfor
  end % endif
  
end

