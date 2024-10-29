# -------------------------------------------------------------------------
# Dorian L. Linero S., Martín Estrada M. & Diego A. Garzón A. - Miguel A. Urrea M.
# Universidad Nacional de Colombia
# Facultad de Ingeniería
# Todos los derechos reservados, 2022
function PEFICA(ADAT::String, TLEC::String="10")
    # presentación inicial en pantalla
    println("----------------------------------------------------------------- ")
    println("       PEFICA 3.0. Universidad Nacional de Colombia 2020          ")
    println("----------------------------------------------------------------- ")
    println("PEFBID/PEFICA: Análisis bidimensional elástico lineal")
    println("escriba PEFICA <nombre archivo datos .m o .msh> <opciones lectura>")
    println("el parámetro <opciones lectura> puede ser igual a: ")
    println("=04: lectura de .m de GiD y escritura malla en TikZ")
    println("=05: lectura de .m de GiD y escritura definida por IMPR.")
    println("     Si IMPR=2 se escriben resultados en .gid.res y gid.msh de GiD")
    println("=06: lectura de .m de GiD y escritura resultados en .gid.res y")
    println("     gid.msh de GiD, y en ventana de comandos")
    println("=07: lectura de .m de GiD y escritura resultados en .pos de GMSH")
    println("     esfuerzos y deformaciones promedio en nudos PRO=0")
    println("=08: lectura de .m de GiD y escritura resultados en .pos de GMSH")
    println("     esfuerzos y deformaciones en el interior de elementos PRO=1")
    println("=10: lectura datos de .msh de GMSH y escritura resultados en")
    println("     .pos de GMSH esfuerzos y deformaciones promedio en nudos")
    println("     para una categoría de material y espesor PRO=0")
    println("=11: lectura datos de .msh de GMSH y escritura resultados en .pos de")
    println("     GMSH, esfuerzos y deformaciones en el interior de elementos PRO=1")
    println("=12: lectura datos de .msh de GMSH y escritura resultados en")
    println("     .pos de GMSH esfuerzos y deformaciones promedio en nudos")
    println("     para varias categorías de material y espesor PRO=2.")
    println("     Adicionalmente se imprime en la ventana las reacciones.")
    println("=17: lectura datos de .msh de GMSH y escritura resultado .gid.res")
    println("     y gid.msh de GiD")
    println("=1900: lectura datos de .msh de GMSH y escritura malla en TikZ")
    println("=20,21,22: lectura datos de .geo de GMSH, generación de malla y del")
    println("     archivo .msh realizada de forma remota por GMSH, y escritura de")
    println("     resultados en archivo .pos de GMSH, calculando como 10,11,12")
    println("Si <opciones lectura> se omite adquiere un valor de 10.")
    println("------------------------------------------------------------------")

    # control de ausencia de argumentos
    if isempty(ADAT)
        println("PEFICA. La función requiere <nombre archivo datos>.")
        return
    end

    if isempty(TLEC)
        TLEC = "10"
        println("PEFICA. La función tomará por defecto a <opciones lectura>=10.")
    end

    ADAD = joinpath("./DATOS", ADAT)
    TLEN = parse(Int, TLEC)

    println("Control")

    # adicionar carpetas y tomar tiempo inicial
    #if !("./FUNCIONES" in LOAD_PATH)
    #    push!(LOAD_PATH, "./FUNCIONES")
    #end
    #if !("./DATOS" in LOAD_PATH)
    #    push!(LOAD_PATH, "./DATOS")
    #end
    include("./FUNCIONES/IMTIEM.jl")
    joinpath("./DATOS")

    println("Control2")
    
    #include("F:/Users/57313/Documents/Documentos/Programas/PEFICAjl/PEFICA30/PEFBID/FUNCIONES/IMTIEM.jl")
    TINT = IMTIEM("Inicio de ejecución del programa \n", 0)
   
    # lectura de archivo de entrada de datos
    if TLEN < 10
        # opción de lectura de entrada de datos de archivo .m (de GiD o escrito direc)
        TINI = IMTIEM("Lectura de datos de entrada de archivo .m ", 0)
        include(ADAT)
        if TLEN == 6
            IMPR = 3
        elseif TLEN == 7 || TLEN == 8
            IMPR = 5
            PRO = TLEN - 7
            ENNU = 1
            SUP = ELE[:, 1]
        elseif TLEN == 4
            IMPR = 4
        end
    else
        # opción de creación de la malla en GMSH en un archivo .msh de forma remota 
        if TLEN >= 20
            println("Ejecución de líneas de comando de GMSH desde PEFiCA")
            run(`gmsh ./DATOS/$ADAT.geo -2 -format msh2`)
            PRO = TLEN - 20
        end

        # opción de lectura de entrada de datos de archivo .msh de GMSH
        TINI = IMTIEM("Lectura de datos de entrada de archivo .msh de GMSH ", 0)
        NNUD, NELE, NNUE, NGAU, NDIM, NCAT, TIPR, ENNU, IMPR, XYZ, ELE, ETY, CAT, UCO, FUN, FDI, SUP = LEGMSH(ADAD)

        # convertir despl conoc de formato B a formato A
        TEM = ORVEBA(UCO, TLEN, NDIM, 0)
        UCO = TEM

        # convertir FUN de formato B a formato A
        TEM = ORVEBA(FUN, TLEN, NDIM, 1)
        FUN = TEM

        if TLEN == 10 || TLEN == 11 || TLEN == 12
            PRO = TLEN - 10
        elseif TLEN == 17
            ENNU = 0
            IMPR = 2
        elseif TLEN == 19
            IMPR = 4
        end
    end

    ELE = convert(Array{Int64, 2}, ELE)
    if TIPR == 20 || TIPR == 21
        PMAT = 3
        PELE = 4
        PCAT = PMAT + PELE
        NCOM = 3
    elseif TIPR == 22 || TIPR == 23
        PMAT = 3
        PELE = 4
        PCAT = PMAT + PELE
        NCOM = 3
    else
        error("PEFiCA. Tipo incorrecto de problema")
    end

    TFIN = IMTIEM("", TINI)
    TINI = IMTIEM("Grados de libertad de nudos y elementos ", 0)

    # A partir de la tabla de desplazamientos conocidos de algunos nudos UCO()
    # se crea la tabla de GL por nudo MGL(), el subvector de desplazamientos 
    # conocidos UBB() y se obtiene el número de GL por nudo NGLN y el número de
    # GL conocidos NGLC.
    MGL, UBB, NGLN, NGLC = NGLUCO(UCO, NNUD)
    NGLT = NNUD * NGLN
    NGLD = NGLT - NGLC

    # Se crea la tabla de GLs por elemento o matriz de incidencias
    INC = NGLELE(ELE, MGL)
    TFIN = IMTIEM("", TINI)

    # indicador de parámetros de la malla
    println("Malla de $NNUD nudos, $NELE elementos y $NGLT GLs")

    TINI = IMTIEM("Matriz de rigidez del solido ", 0)
    KGS = zeros(NGLT, NGLT)

    for IELE in 1:NELE
        CAE = [CAT[ELE[IELE, 1], 1:4]..., float(ETY[IELE, 1:2])..., NGAU]
        NUEL = ETY[IELE, 2]
        XYE = XYZ[ELE[IELE, 2:NUEL + 1], 1:NDIM]
        KEL = KELEME(TIPR, XYE, CAE)

        NKEL = size(KEL, 1)
        for IKEL in 1:NKEL
            for JKEL in 1:NKEL
                if INC[IELE, IKEL] != 0 && INC[IELE, JKEL] != 0
                    KGS[INC[IELE, IKEL], INC[IELE, JKEL]] += KEL[IKEL, JKEL]
                end
            end
        end
    end

    # submatrices de rigidez del sólido
    KAA = KGS[1:NGLD, 1:NGLD]
    KAB = KGS[1:NGLD, NGLD+1:NGLT]
    KBA = KGS[NGLD+1:NGLT, 1:NGLD]
    KBB = KGS[NGLD+1:NGLT, NGLD+1:NGLT]
    TFIN = IMTIEM("", TINI)

    TINI = IMTIEM("Vectores de fuerzas en los nudos del solido ", 0)
    FGC = zeros(NGLT)
    GAMT = sum(CAT[:, 3])

    if GAMT != 0
        for IELE in 1:NELE
            CAE = [CAT[ELE[IELE, 1], 1:4]..., float(ETY[IELE, 1:2])..., NGAU]
            NUEL = ETY[IELE, 2]
            XYE = XYZ[ELE[IELE, 2:NUEL + 1], 1:NDIM]
            FEL = FELEMC(XYE, CAE)

            NFEL = size(FEL, 1)
            for IFEL in 1:NFEL
                if INC[IELE, IFEL] != 0
                    FGC[INC[IELE, IFEL]] += FEL[IFEL]
                end
            end
        end
    end

    NFDI = size(FDI, 1)
    FGS = zeros(NGLT)

    for IFDI in 1:NFDI
        if FDI[IFDI, 1] != 0
            FDE = FDI[IFDI, :]
            ICAT = ELE[FDI[IFDI, 1], 1]
            IELE = FDI[IFDI, 1]
            CAE = [CAT[ELE[IELE, 1], 1:4]..., float(ETY[IELE, 1:2])..., NGAU]
            NLA, LLAD, VNR = PBLADO(XYZ, ELE, FDE)
            FEL = FELEMS(CAE, LLAD, NLA, VNR, FDE)

            NFEL = size(FEL, 1)
            for IFEL in 1:NFEL
                if INC[IELE, IFEL] != 0
                    FGS[INC[IELE, IFEL]] += FEL[IFEL]
                end
            end
        end
    end

    TEM = ORTAEX(FUN, NNUD)
    FGN = ORTAVE(TEM, MGL)

    FGT = FGC + FGS + FGN
    FAA = FGT[1:NGLD]

    FGX = ORVETA(FGT, MGL)
    TFIN = IMTIEM("", TINI)

    TINI = IMTIEM("Desplazamientos y fuerzas totales en los nudos del solido ", 0)
    UAA = KAA \ (FAA - KAB * UBB)
    UTO = [UAA; UBB]
    UXY = ORVETA(UTO, MGL)

    FBB = KBA * UAA + KBB * UBB
    FTO = [FAA; FBB]
    FXY = ORVETA(FTO, MGL)

    FGE = FGC + FGS
    FGB = FGE[NGLD+1:NGLT]
    FNB = FBB - FGB
    FNA = zeros(NGLD)
    FNT = [FNA; FNB]
    FNX = ORVETA(FNT, MGL)

    if TLEN == 12 || IMPR == 3
        IMTBXY(FNX, "\nReacciones)\n", "  INUD          FX          FY\n")
    end

    TFIN = IMTIEM("", TINI)

    TINI = IMTIEM("Deformaciones y esfuerzos en cada elemento ", 0)

    if ENNU == 0; NEVA = NGAU; end
    if ENNU == 1; NEVA = NNUE; end
    if ENNU == 2; NEVA = NNUE; end
    EVA = PBPGAU(NEVA, NDIM, ENNU)

    SRE = zeros(NELE * NEVA, NCOM + 6)
    ERE = zeros(NELE * NEVA, NCOM + 5)
    IRES = 0

    for IELE in 1:NELE
        NUEL = ETY[IELE, 2]
        NGLE = NUEL * NGLN
        UEL = EXTRAV(UTO, INC, IELE, NGLE)
        TIPE = ETY[IELE, 1]
        XYE = XYZ[ELE[IELE, 2:NUEL + 1], 1:NDIM]
        CAE = [CAT[ELE[IELE, 1], 1:4]..., float(ETY[IELE, 1:2])..., NGAU]
        DEL = DELEME(CAE, TIPR)
        POIS = CAE[2]

        for IEVA in 1:NEVA
            XYP = EVA[IEVA, 1:2]
            BEL = BELEME(XYE, XYP, TIPE)
            EPE = BEL * UEL
            STE = DEL * EPE
            SPR, STVM = TRPRIN(STE, POIS, TIPR, 0)
            EPR, DUMY = TRPRIN(EPE, POIS, TIPR, 1)

            IRES += 1
            SRE[IRES, 1] = IELE
            ERE[IRES, 1] = IELE

            if ENNU == 0
                SRE[IRES, 2] = IEVA
                ERE[IRES, 2] = IEVA
            elseif ENNU == 1
                SRE[IRES, 2] = ELE[IELE, IEVA + 1]
                ERE[IRES, 2] = ELE[IELE, IEVA + 1]
            elseif ENNU == 2
                SRE[IRES, 2] = 0
                ERE[IRES, 2] = 0
            end

            for ICOM in 1:NCOM
                SRE[IRES, ICOM + 2] = STE[ICOM]
                ERE[IRES, ICOM + 2] = EPE[ICOM]
            end

            for JCOM in 1:3
                SRE[IRES, JCOM + NCOM + 2] = SPR[JCOM]
                ERE[IRES, JCOM + NCOM + 2] = EPR[JCOM]
            end

            SRE[IRES, NCOM + 6] = STVM
        end
    end

    TFIN = IMTIEM("", TINI)

    if IMPR == 1 || IMPR == 3
        TINI = IMTIEM("Presentación de resultados en ventana de comandos ", 0)
        IMRESU(NNUD, ENNU, UXY, FNX, SRE, ERE)
        TFIN = IMTIEM("", TINI)
    end

    if IMPR == 2 || IMPR == 3
        TINI = IMTIEM("Impresión de resultados en GiD (.gid.msh y .gid.res) ", 0)
        ADAD = "./DATOS/" * ADAT
        IMGIDM(ADAD, NNUD, NELE, NNUE, XYZ, ELE)
        IMGIDR(ADAD, NNUD, NELE, NNUE, NGAU, UXY, FXY, SRE, ERE)
        TFIN = IMTIEM("", TINI)
    end

    if IMPR == 4
        TINI = IMTIEM("Dibujar geometría en Tikz LaTeX ", 0)
        ADAD = "./DATOS/" * ADAT
        TIPN = 0
        IMTIKZ(ADAD, NNUD, NELE, NNUE, XYZ, ELE, UCO, FUN, TIPN)
        TFIN = IMTIEM("", TINI)
    end

    if IMPR == 5
        TINI = IMTIEM("Presentación de resultados en GMSH (.pos y .pos.opt) ", 0)
        ADAD = "./DATOS/" * ADAT
        IMGMSH(ADAD, NNUD, NELE, NNUE, NGAU, NCAT, XYZ, ELE, SUP, UXY, FGX, FNX, SRE, ERE, PRO, UCO)
        TFIN = IMTIEM("", TINI)
    end

    if TLEN >= 20
        run(`gmsh ./DATOS/$ADAT.pos`)
    end

    TFIN = IMTIEM("Tiempo total de ejecución del programa ", TINT)
end
