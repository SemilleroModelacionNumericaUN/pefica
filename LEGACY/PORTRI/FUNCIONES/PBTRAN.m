% matriz de transformación y longitud de un elemento de armadura
% tridimensional
%
function [LONE,TRA] = PBTRAN(XYE,TIPE,VEL)
% entradas: XYE() coordenadas del elemento
%           TIPE  tipo de elemento
%           VEL() vector auxiliar para determinar ejes locales
% salidas:  LONE  longitud del elemento
%           TRA() matriz de transformación
%

  switch TIPE
    case 102 % armadura tridimensional
      % proyecciones de la barra
      for ICOM=1:3
        VEN(ICOM) = XYE(2,ICOM) - XYE(1,ICOM);
      end %endfor
      LONE = norm(VEN); % longitud de la barra
      
      % vector unitario direccional
      VEN = (1/LONE).*VEN;
       
      % matriz de transformación para armadura 3D
      MZE = zeros(1,3);
      TRA = [ VEN, MZE ;
              MZE, VEN ];
    
    case 104 % pórtico tridimensional
        % proyecciones de la barra
        VXL = XYE(2,:) - XYE(1,:);
        LONE = norm(VXL); % longitud de la barra
        % vector unitario en la dirección x-local
        VXL = (1/LONE).*VXL;
        
        % norma del vector auxiliar del plano xy-local leido
        NVEL = norm(VEL);
        
        if NVEL==0
          % suposición del punto auxiliar del plano xy-local
          % como un vector unitario en dirección z-global
          VAU = [0 0 1];
        else
          % vector auxiliar unitario del plano xy-local
          VAU = (1/NVEL).*VEL;
        end
        
        % definición del vector unitario en dirección z-local
        VZL = cross(VXL,VAU);
        NVZL = norm(VZL);
        
        % cambio vector auxiliar en elemento columna 
        % paralelo a z-global.
        if NVZL==0
          % en este caso el vector auxiliar tiene la dirección x-global.
          VAU = [1 0 0];
          % cálculo del vector en dirección z-local
          VZL = cross(VXL,VAU);
          NVZL = norm(VZL);
          if NVZL==0
            % en este caso el vector auxiliar tiene la dirección z-global.
            VAU = [0 0 1];
            % cálculo del vector en dirección z-local
            VZL = cross(VXL,VAU);
            NVZL = norm(VZL);
            fprintf('\n');
            warning('PBTRAN. El vector auxiliar tiene la dirección del eje x-local y se redefine en dirección z-global');
          end %endif  
        end % endif
        % vector unitario en dirección z-local
        VZL = (1/NVZL).*VZL;
        % vector unitario en dirección y-local
        VYL = cross(VZL,VXL);
        
        % matriz de transformación para pórtico 3D
        MZE = zeros(3,3);
        TRV = [ VXL; VYL; VZL];
        
        TRA = [ TRV, MZE, MZE, MZE ;
                MZE, TRV, MZE, MZE ;
                MZE, MZE, TRV, MZE ;
                MZE, MZE, MZE, TRV ];
                
      end % endswitch
              
end % endfunction
