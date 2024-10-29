# Vector de fuerzas equivalentes a la acción del peso específico
# del material en un elemento finito
function FELEMC(XYE, CAE)
    # Entrada:
    # XYE:   coordenadas de los nudos del elemento
    # CAE:   propiedades de la categoría del elemento
    # Salida:
    # FEL:   matriz de rigidez del elemento

    GAMM = CAE[3]   # Peso específico del material
    TESP = CAE[4]   # Espesor del elemento
    TIPE = CAE[5]   # Código del tipo de elemento

    if TIPE == 201
        AREA = PBAVEL(XYE, TIPE)   # Área del elemento
        VOLU = AREA * TESP         # Volumen del elemento
        FEL = FTRIEC(3, VOLU, GAMM)
    elseif TIPE == 202
        FEL = FCUDEC(XYE, CAE)
    elseif TIPE == 203
        # pendiente
        error("FELEMC: elemento triangular cuadrático pendiente")
    elseif TIPE == 204
        # pendiente
        error("FELEMC: elemento cuadrilateral bicuadrático pendiente")
    else
        error("FELEMC: Tipo incorrecto de elemento finito")
    end

    return FEL
end

# ------------------------------------------------------------------------
# Vector de fuerzas equivalentes a la acción del peso específico
# del material para un elemento triangular lineal
function FTRIEC(NNUE, VOLU, GAMM)
    # Entrada:
    # NNUE:  número de nudos del elemento
    # VOLU:  volumen del elemento
    # GAMM:  peso específico del material, que representa la componente
    #        de la fuerza de cuerpo en dirección -y
    # Salida:
    # FEL:   vector de fuerzas de cuerpo del elemento

    NGLN = 2  # Número de grados de libertad por nudo en problemas bidimensionales
    FEL = zeros(NNUE * NGLN)  # Definir tamaño del vector FEL()

    for INUE in 1:NNUE
        FEL[2 * INUE] = -VOLU * GAMM / NNUE
    end

    return FEL
end

# ------------------------------------------------------------------------
# Vector de fuerzas equivalentes a la acción del peso específico
# del material para un elemento cuadrilateral bilineal
function FCUDEC(XYE, CAE)
    # Entrada:
    # XYE:   tabla de coordenadas de los nudos del elemento
    # CAE:   tabla de propiedades del material y del elemento
    # Salida:
    # FEL:   vector de fuerza equivalente

    GAMM = CAE[3]  # Peso específico del material
    TESP = CAE[4]  # Espesor del elemento
    NGAU = CAE[7]  # Número de puntos de Gauss del elemento
    NDIM = 2       # Número de dimensiones del elemento
    ENNU = 0       # Ubicación de evaluación: 0 para puntos de Gauss

    GAU = PBPGAU(NGAU, NDIM, ENNU)  # Tabla de ponderaciones y ubicaciones de PGs
    FEL = zeros(8)  # Definir tamaño del vector de fuerzas equivalente

    FCB = [0, -GAMM, 0, -GAMM, 0, -GAMM, 0, -GAMM]  # Fuerzas de cuerpo aplicadas en dirección -y

    for IGAU in 1:NGAU
        PXIH = GAU[IGAU, 1]  # Coordenada xi
        PETA = GAU[IGAU, 2]  # Coordenada eta
        PWPW = GAU[IGAU, 3]  # Ponderación W_xi * W_eta

        # Derivadas de las funciones de forma con respecto a las coordenadas naturales xi - eta
        DNN = [-0.25 * (1 - PETA), 0.25 * (1 - PETA), 0.25 * (1 + PETA), -0.25 * (1 + PETA);
               -0.25 * (1 - PXIH), -0.25 * (1 + PXIH), 0.25 * (1 + PXIH), 0.25 * (1 - PXIH)]
        
        # Matriz Jacobiana y su determinante
        JAC = DNN * XYE
        DJAC = det(JAC)

        # Matriz de funciones de forma
        NEL = [0.25 * (1 - PXIH) * (1 - PETA), 0, 0.25 * (1 + PXIH) * (1 - PETA), 0,
               0.25 * (1 + PXIH) * (1 + PETA), 0, 0.25 * (1 - PXIH) * (1 + PETA), 0;
               0, 0.25 * (1 - PXIH) * (1 - PETA), 0, 0.25 * (1 + PXIH) * (1 - PETA),
               0, 0.25 * (1 + PXIH) * (1 + PETA), 0, 0.25 * (1 - PXIH) * (1 + PETA)]
        
        # Factor del vector de fuerzas
        FGAU = PWPW * TESP * DJAC
        FPG = FGAU * (NEL' * FCB)

        # Sumar factores del vector de fuerzas en cada PG
        FEL += FPG
    end

    return FEL
end
