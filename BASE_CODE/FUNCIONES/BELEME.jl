# Matriz B de un elemento finito
function BELEME(XYE, XYP, TIPE)
    # Entrada:
    # XYE:   tabla de coordenadas globales de los nudos del elemento.
    # XYP:   tabla de coordenadas naturales del punto donde se evalúa B
    # TIPE:  código del tipo de elemento
    # Salida:
    # MTX:   matriz B del elemento

    if TIPE == 201
        MTX = BTRIEL(XYE)
    elseif TIPE == 202
        MTX = BCUDEL(XYE, XYP)
    elseif TIPE == 203
        # escribir aquí
    elseif TIPE == 204
        # escribir aquí
    else
        error("BELEME: Tipo incorrecto de elemento finito")
    end

    return MTX
end

# ------------------------------------------------------------------------
# Matriz B de un elemento triangular lineal
function BTRIEL(XYE)
    # Entrada:
    # XYE: tabla de coordenadas de los nudos
    # Salida:
    # MTX: matriz B del elemento finito

    TIPE = 201
    AREA = PBAVEL(XYE, TIPE)  # función auxiliar para calcular el área
    # Diferencias entre coordenadas
    B = [XYE[2, 2] - XYE[3, 2], XYE[3, 2] - XYE[1, 2], XYE[1, 2] - XYE[2, 2]]
    C = [XYE[3, 1] - XYE[2, 1], XYE[1, 1] - XYE[3, 1], XYE[2, 1] - XYE[1, 1]]

    # Matriz B
    MTX = zeros(3, 6)
    MTX = [B[1] 0 B[2] 0 B[3] 0;
           0 C[1] 0 C[2] 0 C[3];
           C[1] B[1] C[2] B[2] C[3] B[3]] / (2 * AREA)

    return MTX
end

# ------------------------------------------------------------------------
# Matriz B de un elemento cuadrilateral bilineal
function BCUDEL(XYE, XYP)
    # Entrada:
    # XYE: tabla de coordenadas de los nudos
    # XYP: tabla de coordenadas naturales del punto donde se evalúa B
    # Salida:
    # BEL: matriz B del elemento finito

    BEL = zeros(3, 8)  # Definir dimensiones de la matriz B
    DNN = zeros(2, 4)  # Matriz de derivadas naturales
    DNG = zeros(2, 4)  # Matriz de derivadas generales

    # Coordenadas naturales en el punto a evaluar
    PXIH = XYP[1]
    PETA = XYP[2]

    # Derivadas de las funciones de forma con respecto a las coordenadas naturales
    DNN[1, 1] = -0.25 * (1 - PETA)
    DNN[1, 2] = 0.25 * (1 - PETA)
    DNN[1, 3] = 0.25 * (1 + PETA)
    DNN[1, 4] = -0.25 * (1 + PETA)

    DNN[2, 1] = -0.25 * (1 - PXIH)
    DNN[2, 2] = -0.25 * (1 + PXIH)
    DNN[2, 3] = 0.25 * (1 + PXIH)
    DNN[2, 4] = 0.25 * (1 - PXIH)

    # Matriz Jacobiana y su determinante
    JAC = DNN * XYE
    DJAC = JAC[1, 1] * JAC[2, 2] - JAC[1, 2] * JAC[2, 1]
    DJAI = 1 / DJAC

    # Matriz de operadores diferenciales (respecto a x-y)
    for INUD in 1:4
        DNG[1, INUD] = DJAI * (JAC[2, 2] * DNN[1, INUD] - JAC[1, 2] * DNN[2, INUD])
        DNG[2, INUD] = DJAI * (-JAC[2, 1] * DNN[1, INUD] + JAC[1, 1] * DNN[2, INUD])

        ICOL = 2 * INUD - 1
        BEL[1, ICOL] = DNG[1, INUD]
        BEL[2, ICOL + 1] = DNG[2, INUD]
        BEL[3, ICOL] = DNG[2, INUD]
        BEL[3, ICOL + 1] = DNG[1, INUD]
    end

    return BEL
end
