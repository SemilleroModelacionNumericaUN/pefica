# Matriz constitutiva para material lineal elástico bidimensional
function DELEME(CAE, TIPR)
    # Entrada:
    # CAE:   tabla de propiedades del material y de los elementos
    # TIPR:  código del tipo de problema:
    # Salida:
    # MTX:   matriz constitutiva para material lineal elástico bidimensional

    if TIPR in (20, 21)
        MTX = DELA2D(CAE, TIPR)
    elseif TIPR in (22, 23)
        MTX = DEOR2D(TIPR)
    elseif TIPR == 30
        # pendiente
    else
        error("Error. DELEME: código de tipo de problema incorrecto")
    end

    return MTX
end

# ------------------------------------------------------------------------
# Matriz constitutiva para material lineal elástico bidimensional isotrópico
function DELA2D(CAE, TIPR)
    # Entrada:
    # CAE:   tabla de propiedades del material y de los elementos
    # TIPR:  código del tipo de problema: 
    #        20: cond. plana de esfuerzos, 21: cond. plana de deformaciones
    # Salida:
    # MTX:   matriz constitutiva para material lineal elástico bidimensional

    # Propiedades del material
    EYOU = CAE[1]  # Módulo de Young
    POIS = CAE[2]  # Relación de Poisson

    # Inicializar la matriz D
    MTX = zeros(3, 3)

    if TIPR == 20  # Cond. plana de esfuerzos
        MTX[1, 1] = EYOU / (1 - POIS^2)
        MTX[1, 2] = POIS * EYOU / (1 - POIS^2)
        MTX[2, 1] = MTX[1, 2]
        MTX[2, 2] = MTX[1, 1]
        MTX[3, 3] = 0.5 * (1 - POIS) * (EYOU / (1 - POIS^2))
    elseif TIPR == 21  # Cond. plana de deformaciones
        MTX[1, 1] = (1 - POIS) * EYOU / ((1 + POIS) * (1 - 2 * POIS))
        MTX[1, 2] = POIS * EYOU / ((1 + POIS) * (1 - 2 * POIS))
        MTX[2, 1] = MTX[1, 2]
        MTX[2, 2] = MTX[1, 1]
        MTX[3, 3] = 0.5 * (1 - POIS) * (EYOU / (1 - POIS^2))
    else
        error("Error. DELA2D: código de tipo de problema incorrecto")
    end

    return MTX
end

# ------------------------------------------------------------------------
# Matriz constitutiva para material lineal elástico bidimensional ortotrópico
function DEOR2D(TIPR)
    # Entrada:
    # MAE:   tabla de propiedades del material y de los elementos
    # TIPR:  código del tipo de problema:
    #        22: cond. plana de esfuerzos, 23: cond. plana de deformaciones
    # Salida:
    # MTX:   matriz constitutiva para material lineal elástico bidimensional

    # Propiedades del material
    EYOX = 10000  # Módulo de elasticidad en x
    EYOY = 1000   # Módulo de elasticidad en y
    POXY = 0.04   # Relación de Poisson xy

    # Inicializar la matriz D
    MTX = zeros(3, 3)

    if TIPR == 22  # Cond. plana de esfuerzos
        POYX = POXY * EYOX / EYOY  # Relación de Poisson yx
        GEXY = 1 / (((1 + POYX) / EYOX) + ((1 + POXY) / EYOY))  # Módulo de elasticidad a cortante
        FACT = 1 / (1 - POXY * POYX)
        MTX = FACT * [EYOX       POYX * EYOX    0;
                      POXY * EYOY   EYOY        0;
                      0             0      (1 / FACT) * GEXY]
    elseif TIPR == 23  # Cond. plana de deformaciones
        # Pendiente de implementar
    else
        error("Error. DEOR2D: código de tipo de problema incorrecto")
    end

    return MTX
end
