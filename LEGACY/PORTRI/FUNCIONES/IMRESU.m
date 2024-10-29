% imprimir resultados en la ventana de comandos
function IMRESU(NNUD,ENNU,UXY,FXY,SRE,ERE)
% entrada:  NNUD: número de nudos de la malla
%           ENNU: 0: eval en PG, 1: eval en nudos, 2: eval en centro
%           UXY:  tabla de desplazamientos en los nudos
%           FXY:  tabla de fuerzas en los nudos
%           SRE:  tabla de los esfuerzos en los elementos
%           ERE:  tabla de las deformaciones en los elementos
    fprintf('\nDesplazamientos en los nudos \n');
    fprintf('  INUD          UX          UY \n');
    TEM = [1:NNUD;UXY'];
    fprintf('%6i %+10.4e %+10.4e \n',TEM);
    
    fprintf('\nReacciones en los nudos \n');
    fprintf('  INUD          FX          FY \n');
    TEM = [1:NNUD;FXY'];
    fprintf('%6i %+10.4e %+10.4e \n',TEM);
    
    fprintf('\nEsfuerzos en los elementos \n');
    if ENNU==0; TEVA='IGAU'; end; % evaluada en los puntos de Gauss
    if ENNU==1; TEVA='INUD'; end; % evaluada en los nudos
    if ENNU==2; TEVA='CENT'; end; % evaluada en el centro del elemento
    fprintf('  IELE   %s        STXX        STYY        STXY        ',TEVA);
    fprintf('STP1        STP2        STP3        STVM \n');
    TEM = SRE.'; % transponer tabla
    fprintf('%6i %6i %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e \n',TEM);

    fprintf('\nDeformaciones en elementos \n');
    fprintf('  IELE   %s        EPXX        EPYY        EPXY        ',TEVA);
    fprintf('EPP1        EPP2        EPP3 \n');
    TEM = ERE.'; % transponer tabla
    fprintf('%6i %6i %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e %+10.4e \n',TEM);

end