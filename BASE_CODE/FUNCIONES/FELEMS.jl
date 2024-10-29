# -----------------------------------------------------------------------------
# Vector de fuerzas de superficie del elemento finito
# Entrada:
#   CAE:   propiedades de la categoría del elemento
#   LLAD:  longitud del lado cargado del elemento
#   NLA:   vector identificador del lado como se describe en PBLADO
#   VLA:   vector normal al lado cargado entrando al elemento finito
#   FDE:   presiones y identificador de sistema de coordenadas global o local
#          = [ IELE NUDI NUDJ PREX PREY GLOC ]
# Salida:
#   FEL:   vector de fuerzas de superficie del elemento
function FELEMS(CAE, LLAD, NLA, VLA, FDE)
    TESP = CAE[4]  # espesor del elemento
    TIPE = CAE[5]  # código del tipo de elemento

    if TIPE == 201
        FEL = FTRIES(3, TESP, LLAD, NLA, VLA, FDE)
    elseif TIPE == 202
        FEL = FTRIES(4, TESP, LLAD, NLA, VLA, FDE)
    elseif TIPE == 203
        error("FELEMS: elemento triangular cuadrático pendiente")
    elseif TIPE == 204
        error("FELEMS: elemento cuadrilateral bicuadrático pendiente")
    else
        error("FELEMS: Tipo incorrecto de elemento finito")
    end

    return FEL
end

# -----------------------------------------------------------------------------
# Vector de fuerzas de superficie del elemento triangular lineal o
# cuadrilateral bilineal
function FTRIES(NNUE, TESP, LLAD, NLA, VNR, FDE)
    # Entrada:
    #   NNUE:  número de nudos del elemento
    #   TESP:  espesor del elemento
    #   LLAD:  longitud del lado cargado del elemento
    #   NLA:   vector identificador del lado como se describe en PBLADO
    #   VNR:   vector normal al lado cargado entrando al elemento
    #   FDE:   presiones y sistema de coordenadas global o local
    # Salida:
    #   FEL:   vector de fuerzas de superficie del elemento

    NGLN = 2  # número de grados de libertad por nudo
    FEL = zeros(NNUE * NGLN)  # definir tamaño del vector de fuerzas de superficie

    if FDE[6] == 0  # presiones uniformes en sistema de coordenadas global
        NLA = abs.(NLA)
        for INUE in 1:NNUE
            FEL[2 * INUE - 1] = NLA[1, INUE] * FDE[4] * TESP * LLAD / 2
            FEL[2 * INUE] = NLA[1, INUE] * FDE[5] * TESP * LLAD / 2
        end

    elseif FDE[6] == 1  # presiones uniformes en sistema de coordenadas local
        NLA = abs.(NLA)
        for INUE in 1:NNUE
            FEL[2 * INUE - 1] = (NLA[1, INUE] * TESP * LLAD / 2) * (FDE[4] * VNR[1] - FDE[5] * VNR[2])
            FEL[2 * INUE] = (NLA[1, INUE] * TESP * LLAD / 2) * (FDE[4] * VNR[2] + FDE[5] * VNR[1])
        end

    elseif FDE[6] == 2  # presión de variación lineal normal al lado
        # Presión en los extremos
        PREI = FDE[4]  # presión en el extremo inicial
        PREJ = FDE[5]  # presión en el extremo final
        FUEI = TESP * LLAD * (2 * PREI + PREJ) / 6  # fuerza equivalente en el extremo inicial
        FUEJ = TESP * LLAD * (PREI + 2 * PREJ) / 6  # fuerza equivalente en el extremo final

        # Fuerzas equivalentes en sistema de coordenadas global
        FUXI = FUEI * VNR[1]  # componente en dirección-x
        FUYI = FUEI * VNR[2]  # componente en dirección-y
        FUXJ = FUEJ * VNR[1]  # componente en dirección-x
        FUYJ = FUEJ * VNR[2]  # componente en dirección-y

        for INUE in 1:NNUE
            if NLA[1, INUE] == 1
                # nudo inicial del lado cargado
                FEL[2 * INUE - 1] = abs(NLA[1, INUE]) * FUXI
                FEL[2 * INUE] = abs(NLA[1, INUE]) * FUYI
            elseif NLA[1, INUE] == -1
                # nudo final del lado cargado
                FEL[2 * INUE - 1] = abs(NLA[1, INUE]) * FUXJ
                FEL[2 * INUE] = abs(NLA[1, INUE]) * FUYJ
            end
        end
    end

    return FEL
end
