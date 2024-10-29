function LEGMSH(ADAD::String)
    # notas importantes acerca de la generación de la malla en GMSH
    # ...

    # valores definidos algunos parámetros generales para GMSH
    NDIM = 2    # dimensiones del problema
    IMPR = 5    # tipo de impresión de los resultados =5: en GMSH.
    # valores por defecto de algunos parámetros generales para GMSH
    TIPR = 20   # tipo de problema por defecto: 20:plano de esfuerzos, 21 plano de deformac.
    NGAU = 4    # número de puntos de Gauss en elementos cuadrilaterales por defecto
    NNUE = 4    # número máximo de nudos por elemento por defecto
    ENNU = 1    # tipo de eval de esf/defor en el elemento por defecto. 1: eval en los nudos

    # lectura del archivo .msh
    GMSH = ADAD * ".msh"  # nombre archivo GMSH de datos
    FLID = open(GMSH) do file
        nothing
    end
    if FLID == nothing
        println("\n")
        error("... El archivo $ADAD.msh no existe")
    end

    TEMP = read(GMSH, String)    # arreglo tipo texto que contiene el archivo .msh por caracter
    AMSH = split(TEMP, '\n')     # arreglo tipo texto que contiene el archivo .msh por línea
    NLIN = length(AMSH)          # número de líneas del archivo .msh
    println("\n... $NLIN líneas del archivo .msh leidas y guardadas en un arreglo")

    # bloque de formato
    # ------------------------------------------------------------------------------
    if AMSH[1] == "\$MeshFormat"
        VERS = parse(Float64, split(AMSH[2])[1]) # versión del archivo .msh
        if VERS > 2.2
            println("\n")
            error("... Version mayor a 2.2 del archivo .msh de GMHS")
        end
    else
        println("\n")
        error("... La palabra clave \$MeshFormat no esta en la linea 1 del archivo .msh")
    end

    # bloque de entidades físicas
    # ------------------------------------------------------------------------------
    if AMSH[4] == "\$PhysicalNames"
        println("\n... inicio de lectura de entidades físicas")
        NFIS = parse(Int, AMSH[5])  # número de entidades físicas
        MFIS = 10  # número máximo de argumentos de cada entidad física
        MCAT = 7   # número máximo de parámetros de cada categoría
        ICAT = 0   # contador de categorías de los EF
        FIS = zeros(Int, NFIS, MFIS)  # tabla de entidades físicas
        CAT = zeros(Int, 1, MCAT) # tabla de categorías de material y espesor de los elementos

        for DFIS in 1:NFIS  # ciclo por línea de entidad física
            ILIN = 5 + DFIS
            TFIS = split(AMSH[ILIN], r"[\s\"]")  # cadena de la entidad física
            NCOM = length(TFIS) - 4  # número de componentes de una entidad física

            IFIS = parse(Int, TFIS[2]) # el identificador de la entidad física es el índice del arreglo
            FIS[IFIS, 2] = parse(Int, TFIS[1]) # tipo de entidad geométrica donde está la entidad física
            PFIS = TFIS[3]  # palabra clave de la entidad física

            # entidad física tipo desplazamiento
            if PFIS == "DISP"
                FIS[IFIS, 3] = 10  # identificador del tipo de entidad física
                for ICOM in 1:NCOM  # ciclo por componentes de la entidad física
                    TEMR = split(TFIS[3 + ICOM], '=')
                    if length(TEMR) < 2
                        println("\n")
                        error("... Linea: $ILIN: lectura incorrecta de la entidad fisica DISP. Elimine los espacios alrededor del =")
                    end
                    if isempty(parse(Float64, TEMR[2]))
                        println("\n")
                        error("... Linea: $ILIN: lectura incorrecta de la entidad fisica DISP. Elimine los espacios alrededor del =")
                    end

                    # desplazamiento conocido en x
                    if TEMR[1] == "UX"
                        FIS[IFIS, 4] = 1  # indicador desplazamiento conocido en x
                        FIS[IFIS, 5] = parse(Float64, TEMR[2])  # valor despl en x
                    end
                    # desplazamiento conocido en y
                    if TEMR[1] == "UY"
                        FIS[IFIS, 6] = 2  # indicador desplazamiento conocido en y
                        FIS[IFIS, 7] = parse(Float64, TEMR[2])  # valor despl en y
                    end
                    # desplazamiento incorrecto
                    if TEMR[1] != "UX" && TEMR[1] != "UY"
                        println("\n")
                        error("... Linea: $ILIN: \"$TEMR[1]\" es un nombre incorrecto de parametro en la entidad fisica DISP.")
                    end
                end
            end

            # entidad física tipo carga puntual
            if PFIS == "LOAD"
                FIS[IFIS, 3] = 20  # identificador del tipo de entidad física
                for ICOM in 1:NCOM  # ciclo por componentes de la entidad física
                    TEMR = split(TFIS[3 + ICOM], '=')
                    if length(TEMR) < 2
                        println("\n")
                        error("... Linea: $ILIN: lectura incorrecta de la entidad fisica LOAD. Elimine los espacios alrededor del =")
                    end
                    if isempty(parse(Float64, TEMR[2]))
                        println("\n")
                        error("... Linea: $ILIN: lectura incorrecta de la entidad fisica LOAD. Elimine los espacios alrededor del =")
                    end

                    # carga conocida en x
                    if TEMR[1] == "FX"
                        FIS[IFIS, 4] = 1  # indicador carga conocida en x
                        FIS[IFIS, 5] = parse(Float64, TEMR[2])  # valor carga en x
                    end
                    # carga conocida en y
                    if TEMR[1] == "FY"
                        FIS[IFIS, 6] = 2  # indicador carga conocida en y
                        FIS[IFIS, 7] = parse(Float64, TEMR[2])  # valor carga en y
                    end
                    # desplazamiento incorrecto
                    if TEMR[1] != "FX" && TEMR[1] != "FY"
                        error("... Linea: $ILIN: \"$TEMR[1]\" es un nombre incorrecto de parametro en la entidad fisica LOAD.")
                    end
                end
            end

            # entidad física tipo carga distribuida o presión
            if PFIS == "PRES"
                FIS[IFIS, 3] = 30  # identificador del tipo de entidad física
                SUMG = 0
                SUML = 0
                SUMW = 0
                for ICOM in 1:NCOM
                    TEMR = split(TFIS[3 + ICOM], '=')
                    if length(TEMR) < 2
                        println("\n")
                        error("... Linea: $ILIN: lectura incorrecta de la entidad fisica PRES. Elimine los espacios alrededor del =")
                    end
                    if isempty(parse(Float64, TEMR[2]))
                        println("\n")
                        error("... Linea: $ILIN: lectura incorrecta de la entidad fisica PRES. Elimine los espacios alrededor del =")
                    end

                    # carga conocida en x
                    if TEMR[1] == "WX"
                        FIS[IFIS, 4] = parse(Float64, TEMR[2])  # valor
                        FIS[IFIS, 6] = 0  # sist coord global
                        SUMG = 1
                    end
                    # carga conocida en y
                    if TEMR[1] == "WY"
                        FIS[IFIS, 5] = parse(Float64, TEMR[2])  # valor
                        FIS[IFIS, 6] = 0  # sist coord global
                        SUMG = 1
                    end
                    # carga conocida normal al lado
                    if TEMR[1] == "WN"
                        FIS[IFIS, 4] = parse(Float64, TEMR[2])  # valor
                        FIS[IFIS, 6] = 1  # sist coord local
                        SUML = 1
                    end
                    # carga conocida tangencial al lado
                    if TEMR[1] == "WT"
                        FIS[IFIS, 5] = parse(Float64, TEMR[2])  # valor
                        FIS[IFIS, 6] = 1  # sist coord local
                        SUML = 1
                    end
                    # peso especifíco del agua
                    if TEMR[1] == "GAWA"
                        FIS[IFIS, 4] = parse(Float64, TEMR[2])  # valor
                        FIS[IFIS, 6] = 2  # presión hidráulica
                        SUMW = 1
                    end
                    # nivel del agua
                    if TEMR[1] == "HEWA"
                        FIS[IFIS, 5] = parse(Float64, TEMR[2])  # valor
                        FIS[IFIS, 6] = 2  # presión hidráulica
                        SUMW = 1
                    end

                    # presión incorrecta
                    if !(TEMR[1] in ["WX", "WY", "WN", "WT", "GAWA", "HEWA"])
                        println("\n")
                        error("... Linea: $ILIN: \"$TEMR[1]\" es un nombre incorrecto de parametro en la entidad fisica PRES.")
                    end
                end

                # control de errores
                SUMT = SUMG + SUML + SUMW
                if SUMT > 1
                    println("\n")
                    error("... Linea: $ILIN: Presiones en sistemas coordenados diferentes en entidad fisica PRES.")
                end
            end

            # entidad física tipo categoría del EF (material y constantes reales)
            if PFIS == "CATE"
                ICAT += 1  # contador de categorias de los EF
                FIS[IFIS, 1] = ICAT  # identificador de la categoría
                FIS[IFIS, 3] = 50  # identificador del tipo de entidad física
                for ICOM in 1:NCOM
                    TEMR = split(TFIS[3 + ICOM], '=')
                    if length(TEMR) < 2
                        println("\n")
                        error("... Linea: $ILIN: lectura incorrecta de la entidad fisica CATE. Elimine los espacios alrededor del =")
                    end
                    if isempty(parse(Float64, TEMR[2]))
                        println("\n")
                        error("... Linea: $ILIN: lectura incorrecta de la entidad fisica CATE. Elimine los espacios alrededor del =")
                    end

                    # módulo de Young
                    if TEMR[1] == "EYOU"
                        FIS[IFIS, 4] = parse(Float64, TEMR[2])  # valor
                    end
                    # relación de Poisson
                    if TEMR[1] == "POIS"
                        FIS[IFIS, 5] = parse(Float64, TEMR[2])  # valor
                    end
                    # peso específico
                    if TEMR[1] == "GAMM"
                        FIS[IFIS, 6] = parse(Float64, TEMR[2])  # valor
                    end
                    # espesor
                    if TEMR[1] == "TESP"
                        FIS[IFIS, 7] = parse(Float64, TEMR[2])  # valor
                    end
                    # tipo de problema: 20=plano de esfuerzos
                    if TEMR[1] == "TIPR"
                        TIPR = parse(Int, TEMR[2])  # valor
                    end
                    # número de puntos de Gauss en elementos cuadrilaterales
                    if TEMR[1] == "NGAU"
                        NGAU = parse(Int, TEMR[2])  # valor
                    end
                    # categoría incorrecta
                    if !(TEMR[1] in ["EYOU", "POIS", "GAMM", "TESP", "TIPR", "NGAU"])
                        println("\n")
                        error("... Linea: $ILIN: \"$TEMR[1]\" es un nombre incorrecto de parametro en la entidad fisica CATE.")
                    end
                end

                # control de errores
                if FIS[IFIS, 4] == 0 || FIS[IFIS, 5] == 0 || FIS[IFIS, 7] == 0
                    println("\n")
                    error("... Linea: $ILIN: EYOU, POIS o TESP de una categoria igual a cero")
                end

                # tabla de categorías de material y espesor de los elementos CAT()
                CAT[ICAT, 1:4] = FIS[IFIS, 4:7]
            end

            # control de error entidad física incorrecta
            if !(PFIS in ["DISP", "LOAD", "PRES", "CATE"])
                println("\n")
                EMSG = "... Linea: $ILIN: \"$PFIS\" es un nombre incorrecto de entidad fisica."
                error(EMSG)
            end
        end
        NCAT = ICAT  # número de categorías de material y espesor
    else
        println("\n")
        error("... La palabra clave \$PhysicalNames no esta en la linea 4 del archivo .msh")
    end

    # bloque de nudos
    # ------------------------------------------------------------------------------
    LIND = 7 + NFIS  # línea inicial del bloque de nudos
    if AMSH[LIND] == "\$Nodes"
        println("\n... inicio de lectura de coordenadas de los nudos")
        NNUD = parse(Int, AMSH[LIND + 1])  # número de nudos
        if NNUD == 0
            println("\n")
            error("... No se ha generado una malla desde la línea $LIND del archivo .msh")
        end
        XYZ = zeros(Float32, NNUD, NDIM)
        for INUD in 1:NNUD
            TEMP = parse.(Float32, split(AMSH[LIND + 1 + INUD]))  # dividir por variables
            XYZ[INUD, 1] = TEMP[2]  # coordenada x
            XYZ[INUD, 2] = TEMP[3]  # coordenada y
        end
    else
        println("\n")
        error("... La palabra clave \$Nodes no esta en la linea $LIND del archivo .msh")
    end

    # bloque de elementos y condiciones de borde tipo punto, línea y superficie
    # ------------------------------------------------------------------------------
    LIET = 10 + NFIS + NNUD  # número de la línea inicial del bloque de elementos y cond de borde
    IUCO = 0  # contador de desplazamientos conocidos por GL
    IFUN = 0  # contador de fuerzas puntuales conocidas por GL
    IFDI = 0  # contador de presiones aplicadas entre dos nudos
    IELE = 0  # contador de elementos finitos definitivos
    CORL = 0  # contador de correcciones de elementos con nudos en sentido horario

    if AMSH[LIET] == "\$Elements"
        println("\n... inicio de lectura de elementos y cond borde tipo punto, línea y superficie")
        NELT = parse(Int, AMSH[LIET + 1])  # número de elementos punto, línea y superficie
        if NELT == 0
            println("\n")
            error("... No se ha generado una malla desde la línea $LIET del archivo .msh")
        end

        MENU = 10  # número máximo de elementos asociados a un mismo nudo
        ELT = zeros(Int, 1, NNUE + 5)  # declaración inicial con el número máx de columnas
        ELE = zeros(Int, 1, NNUE + 1)  # declaración inicial tabla de elementos definitivos
        ETY = zeros(Int, 1, 2)  # declaración inicial tabla de tipo y número de nudos de cada elemento
        UCO = zeros(Int, 1, 3)  # declaración inicial tabla de desplazamientos conocidos
        FUN = zeros(Int, 1, 3)  # declaración inicial tabla de fuerzas puntuales conocidas
        FDI = zeros(Int, 1, 6)  # declaración inicial tabla de fuerzas distribuidas por und de área
        YNU = zeros(Int, 2)  # declaración de altura de la cota de agua
        NUE = zeros(Int, NNUD, MENU)  # declaración tabla de elementos asociados a cada nudo
        SUP = zeros(Int, 1)  # declaración inicial de tabla de id de superficies asociadas a los elementos

        for IELT in 1:NELT
            TEMP = parse.(Int, split(AMSH[LIET + 1 + IELT]))  # dividir por variables
            NTEM = length(TEMP)
            ELT[1:NTEM] = TEMP[1:NTEM]  # tabla de elementos temporales

            # crear tabla de desplazamientos conocidos en formato B: UCO()
            if FIS[ELT[4], 3] == 10
                # desplazamiento conocido definido en un elemento temporal de nudo
                if ELT[2] == 15
                    # desplazamiento conocido en x
                    if FIS[ELT[4], 4] != 0
                        IUCO += 1  # contador de desplazamientos conocidos por GL
                        UCO[IUCO, 1] = ELT[6]  # identificador del nudo
                        UCO[IUCO, 2:3] = FIS[ELT[4], 4:5]  # indicador y valor del desplaz conocido en x
                    end
                    # desplazamiento conocido en y
                    if FIS[ELT[4], 6] != 0
                        IUCO += 1  # contador de desplazamientos conocidos por GL
                        UCO[IUCO, 1] = ELT[6]  # identificador del nudo
                        UCO[IUCO, 2:3] = FIS[ELT[4], 6:7]  # indicador y valor del desplazamiento conocido en y
                    end
                end

                # desplazamiento conocido definido en un elemento temporal de línea
                if ELT[2] == 1
                    # desplazamiento conocido en x
                    if FIS[ELT[4], 4] != 0
                        for INUD in 1:2  # ciclo por nudo del elemento línea
                            IUCO += 1  # contador de desplazamientos conocidos por GL
                            UCO[IUCO, 1] = ELT[5 + INUD]  # identificador del nudo
                            UCO[IUCO, 2:3] = FIS[ELT[4], 4:5]  # indicador y valor del desplazamiento conocido en x
                        end
                    end
                    # desplazamiento conocido en y
                    if FIS[ELT[4], 6] != 0
                        for INUD in 1:2  # ciclo por nudo del elemento línea
                            IUCO += 1  # contador de desplazamientos conocidos por GL
                            UCO[IUCO, 1] = ELT[5 + INUD]  # identificador del nudo
                            UCO[IUCO, 2:3] = FIS[ELT[4], 6:7]  # indicador y valor del desplazamiento conocido en y
                        end
                    end
                end
            end

            # crear tabla de fuerzas puntuales conocidas en formato B: FUN()
            if FIS[ELT[4], 3] == 20
                # fuerza puntual conocida definida en un elemento temporal de nudo
                if ELT[2] == 15
                    # fuerza puntual conocida en x
                    if FIS[ELT[4], 4] != 0
                        IFUN += 1  # contador de fuerzas puntuales conocidas por GL
                        FUN[IFUN, 1] = ELT[6]  # identificador del nudo
                        FUN[IFUN, 2:3] = FIS[ELT[4], 4:5]  # indicador y valor de la fuerza conocida en x
                    end
                    # fuerza puntual conocida en y
                    if FIS[ELT[4], 6] != 0
                        IFUN += 1  # contador de fuerzas puntuales conocidas por GL
                        FUN[IFUN, 1] = ELT[6]  # identificador del nudo
                        FUN[IFUN, 2:3] = FIS[ELT[4], 6:7]  # indicador y valor de la fuerza conocida en y
                    end
                end

                # fuerza puntual conocida definida en un elemento temporal de línea
                if ELT[2] == 1
                    # fuerza puntual conocida en x
                    if FIS[ELT[4], 4] != 0
                        for INUD in 1:2  # ciclo por nudo del elemento línea
                            IFUN += 1  # contador de fuerzas puntuales conocidas por GL
                            FUN[IFUN, 1] = ELT[5 + INUD]  # identificador del nudo
                            UCO[IUCO, 2:3] = FIS[ELT[4], 4:5]  # indicador y valor de la fuerza conocida en x
                        end
                    end
                    # fuerza puntual conocida en y
                    if FIS[ELT[4], 6] != 0
                        for INUD in 1:2  # ciclo por nudo del elemento línea
                            IFUN += 1  # contador de fuerzas puntuales conocidas por GL
                            FUN[IFUN, 1] = ELT[5 + INUD]  # identificador del nudo
                            FUN[IFUN, 2:3] = FIS[ELT[4], 6:7]  # indicador y valor de la fuerza conocida en y
                        end
                    end
                end
            end

            # crear tabla de presiones conocidas: FDI()
            if FIS[ELT[4], 3] == 30
                # presión definida en un elemento temporal de línea
                if ELT[2] == 1
                    IFDI += 1  # contador de presiones aplicadas sobre cara entre dos nudos
                    FDI[IFDI, 2:3] = ELT[6:7]  # nudos que definen la cara con la presión
                    if FIS[ELT[4], 6] != 2
                        # presión uniforme en sistema cood global o local
                        FDI[IFDI, 4:6] = FIS[ELT[4], 4:6]  # parámetros de la presión y tipo
                    else
                        # presión hidráulica
                        FDI[IFDI, 6] = FIS[ELT[4], 6]  # identificador del tipo de presión
                        GAWA = FIS[ELT[4], 4]  # peso específico del agua
                        HEWA = FIS[ELT[4], 5]  # altura de la capa de agua
                        # presión en los nudos i y j del lado a partir de GAWA y HEWA
                        for ITEM in 1:2
                            YNU[ITEM] = XYZ[FDI[IFDI, ITEM + 1], 2]
                            if YNU[ITEM] <= HEWA
                                FDI[IFDI, ITEM + 3] = GAWA * (HEWA - YNU[ITEM])
                            else
                                FDI[IFDI, ITEM + 3] = 0
                            end
                        end
                    end
                end
            end

            # crear tabla de elementos definitivos que conforman la malla: ELE()
            if FIS[ELT[4], 3] == 50
                IELE += 1  # contador de elementos definitivos
                ELE[IELE, 1] = FIS[TEMP[4], 1]  # identificador de la categoría
                ELE[IELE, 2:5] = ELT[6:9]  # identificadores de los nudos del elemento definitivo

                # ETY():  tabla de tipo y número de nudos de cada elemento definitivo
                if ELE[IELE, 5] == 0
                    # elemento triangular lineal
                    ETY[IELE, 1] = 201  # identificador del tipo de elemento
                    ETY[IELE, 2] = 3    # número de nudos del elemento
                else
                    # elemento cuadrilateral bilineal
                    ETY[IELE, 1] = 202  # identificador del tipo de elemento
                    ETY[IELE, 2] = 4    # número de nudos del elemento
                end

                # SUP():  tabla auxilar de identificador de la superficie asociada a los elementos
                SUP[IELE] = ELT[5]

                # NUE():  tabla de elementos asociados a cada nudo
                for INUE in 1:4  # nudos de un elemento
                    INUD = ELE[IELE, 1 + INUE]  # identificador de INUE nudo del elemento
                    if INUD > 0
                        NUE[INUD, 1] += 1  # contador del número de elementos asociados a un nudo
                        NUE[INUD, NUE[INUD, 1] + 1] = IELE
                    end
                end

                # revisión y corrección de conectividades en sentido horario
                if ELE[IELE, 5] == 0
                    # elemento triangular lineal
                    XYE = [XYZ[ELE[IELE, 2], :]; XYZ[ELE[IELE, 3], :]; XYZ[ELE[IELE, 4], :]]
                    AREA =  XYE[1, 1] * XYE[2, 2] + XYE[2, 1] * XYE[3, 2] + XYE[3, 1] * XYE[1, 2] #...
                          - XYE[1, 2] * XYE[2, 1] - XYE[2, 2] * XYE[3, 1] - XYE[3, 2] * XYE[1, 1]
                    AREA /= 2
                    if AREA <= 0.0
                        # cambiar el orden de los nudos
                        ELE[IELE, 2:4] = [ELT[6], ELT[8], ELT[7]]
                        CORL += 1
                    end
                else
                    # elemento cuadrilateral bilineal
                    XYE = [XYZ[ELE[IELE, 2], :]; XYZ[ELE[IELE, 3], :]; XYZ[ELE[IELE, 4], :]; XYZ[ELE[IELE, 5], :]]
                    AREA =  XYE[1, 1] * XYE[2, 2] + XYE[2, 1] * XYE[3, 2] #...
                          + XYE[3, 1] * XYE[4, 2] + XYE[4, 1] * XYE[1, 2] #...
                          - XYE[1, 2] * XYE[2, 1] - XYE[2, 2] * XYE[3, 1] #...
                          - XYE[3, 2] * XYE[4, 1] - XYE[4, 2] * XYE[1, 1]
                    AREA /= 2
                    if AREA <= 0.0
                        # cambiar el orden de los nudos
                        ELE[IELE, 2:5] = [ELT[6], ELT[9], ELT[8], ELT[7]]
                        CORL += 1
                    end
                end

                if CORL > 0
                    println("\n")
                    warning("... Corrección de conectividades, ordenando los nudos en sentido antihorario.")
                end
            end
        end

        # ajustes y definiciones de la tabla ELE()
        NELE = IELE  # número de elementos finitos definitivos
        # reducir última columna cuando los elementos de la malla son triangulares lineales
        SELE = sum(ELE[:, 5])
        if SELE == 0
            ELE = ELE[:, 1:4]
            NNUE = 3  # número máximo de nudos de un elemento
            NGAU = 1  # no aplican puntos de Gauss a elementos triangulares lineales
        end

        # ajustes y control de errores de la tabla UCO()
        # elimina fila de UCO() que contiene un desplaz conocido repetido
        UCO = unique(UCO, dims=1)
        # control de error cuando se impone varias veces un desplazamiento conocido
        # en el mismo GL con valores diferentes
        TEM, UUCO, UTEM = unique(UCO[:, 1:2], dims=1)
        if size(UUCO, 1) < size(UTEM, 1)
            println("\n")
            error("... se impone varias veces un desplazamiento conocido en el mismo GL con valores diferentes.")
        end

        # ajustes y control de errores de la tabla FUN()
        # elimina filas de FUN() que contiene una fuerza puntual conocida repetida
        if FUN[1, 1] != 0  # existencia de un nudo con carga puntual
            FUN = unique(FUN, dims=1)
            # control de error cuando se aplica varias veces una fuerza puntual conocida
            # en el mismo GL con valores diferentes
            TEM, UFUN, UTEM = unique(FUN[:, 1:2], dims=1)
            if size(UFUN, 1) < size(UTEM, 1)
                println("\n")
                error("... se aplica varias veces una fuerza puntual conocida en el mismo GL con valores diferentes.")
            end
        end

        # ajustes y control de errores de la tabla FDI()
        # control de error de FDI() cuando se aplica varias veces una presión conocida
        # del mismo tipo y en la misma línea entre dos nudos
        if FDI[1, 2] != 0 || FDI[1, 3] != 0  # existencia de un lado con presión
            FDR = FDI[:, [2, 3, 6]]
            TEM, UFDR, UTEM = unique(FDR[:, 1:3], dims=1)
            if size(UFDR, 1) < size(UTEM, 1)
                println("\n")
                error("... se aplica varias veces una presión conocida del mismo tipo y en la misma línea entre dos nudos.")
            end

            # incluir número del elemento con lado cargado en la tabla FDI():
            NFDI = size(FDI, 1)
            for IFDI in 1:NFDI
                LAD = FDI[IFDI, 2:3]  # nudos de un lado cargado
                # identificador de los elementos asociados a los nudos del lado cargado
                ELI = NUE[LAD[1], 2:NUE[LAD[1], 1] + 1]  # elementos asociados al nudo i
                ELJ = NUE[LAD[2], 2:NUE[LAD[2], 1] + 1]  # elementos asociados al nudo j
                ELL = intersect(ELI, ELJ)  # elementos asociados al lado entre nudo i y j
                FDI[IFDI, 1] = ELL[1]  # asignar primer elemento cuyo lado está cargado
                if length(ELL) > 1
                    println("\n")
                    warning("... Lado $(LAD[1])-$(LAD[2]) compartido por varios elementos. Se considera presión en elemento $(ELL[1])")
                    FDI[IFDI, 1] = ELL[1]  # asignar el primer elemento cuyo lado está cargado
                end
            end
        end
    else
        println("\n")
        error("... La palabra clave \$Elements no esta en la linea $LIET del archivo .msh")
    end

    println("\n")

    return NNUD, NELE, NNUE, NGAU, NDIM, NCAT, TIPR, ENNU, IMPR, XYZ, ELE, ETY, CAT, UCO, FUN, FDI, SUP
end
