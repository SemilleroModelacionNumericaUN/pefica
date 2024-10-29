# Extraer un vector VEL() para el elemento IELE a partir de un vector del
# sólido VGL() según la numeración de los GL dada en la tabla de incidencias INC()
function EXTRAV(VGL, INC, IELE, NGLE)
    # Entradas:
    # VGL:   vector del sólido (por ejemplo desplazamientos nodales)
    # INC:   tabla de incidencias
    # IELE:  identificador del elemento
    # NGLE:  número de grados de libertad asociados al elemento
    #        si NGLE = 0, se modifica al número de columnas de INC
    #
    # Salidas:
    # VEL:   vector del elemento IELE

    NGLT = size(VGL, 1)  # Número de grados de libertad de la malla
    NELE, NGLM = size(INC)  # Número de elementos y de GL máximo por elemento

    # Control de error
    if IELE > NELE || IELE <= 0
        error("EXTRAV: $IELE es un número incorrecto del elemento")
    end

    if NGLE > NGLM
        error("EXTRAV: $NGLE es un número incorrecto de grados de libertad por elemento")
    end

    if NGLE == 0
        NGLE = NGLM
    end  # Número de GL por elemento utilizado

    # Procedimiento
    VEL = zeros(NGLE)
    for IGLE in 1:NGLE
        if INC[IELE, IGLE] != 0 && INC[IELE, IGLE] <= NGLT
            VEL[IGLE] = VGL[INC[IELE, IGLE]]
        end
    end

    return VEL
end
