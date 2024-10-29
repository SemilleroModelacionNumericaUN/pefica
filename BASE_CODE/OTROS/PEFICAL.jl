# PEFiCA: Programa de elementos finitos a código abierto. Versión 2.0
#
# Análisis elástico lineal para problemas en condición plana de esfuerzos y deformaciones
# mediante el método de los elementos finitos. Considera deformaciones infinitesimales y 
# utiliza elementos finitos triangulares lineales y cuadrilaterales bilineales.

#module PEFICA

using Printf

# Función principal de PEFICA
function PEFICA(ADAT, TLEC=10)
    # Presentación inicial en pantalla
    println("-----------------------------------------------------------------")
    println("       PEFICA 2.0. Universidad Nacional de Colombia 2020          ")
    println("-----------------------------------------------------------------")
    println("PEFBID/PEFICA: Analisis bidimensional elastico lineal")
    println("Escriba PEFICA <nombre archivo datos .m o .msh> <opciones lectura>")
    println("El parámetro <opciones lectura> puede ser igual a:")
    println("=04: Lectura de .m de GiD y escritura malla en TikZ")
    println("=05: Lectura de .m de GiD y escritura definida por IMPR.")
    println("     Si IMPR=2 se escriben resultados en .gid.res y gid.msh de GiD")
    println("=06: Lectura de .m de GiD y escritura resultados en .gid.res y")
    println("     gid.msh de GiD, y en ventana de comandos")
    println("=07: Lectura de .m de GiD y escritura resultados en .pos de GMSH")
    println("     Esfuerzos y deformaciones promedio en nudos PRO=0")
    println("=08: Lectura de .m de GiD y escritura resultados en .pos de GMSH")
    println("     Esfuerzos y deformaciones en el interior de elementos PRO=1")
    println("=10: Lectura datos de .msh de GMSH y escritura resultados en")
    println("     .pos de GMSH esfuerzos y deformaciones promedio en nudos")
    println("     para una categoría de material y espesor PRO=0")
    println("=11: Lectura datos de .msh de GMSH y escritura resultados en .pos de")
    println("     GMSH, esfuerzos y deformaciones en el interior de elementos PRO=1")
    println("------------------------------------------------------------------")
    
    # Validar argumentos
    if ADAT == ""
        println("PEFICA. La función requiere <nombre archivo datos>.")
        return
    end

    # Parámetros iniciales
    ADAD = "./DATOS/$(ADAT)"
    TLEN = parse(Int, TLEC)

    # Agregar directorios
    push!(LOAD_PATH, "./FUNCIONES")
    push!(LOAD_PATH, "./DATOS")

    # Lectura de datos según el tipo de archivo
    if TLEN < 10
        println("Lectura de datos de entrada de archivo .m")
        include(ADAT)
        if TLEN == 6
            IMPR = 3
        elseif TLEN == 7 || TLEN == 8
            IMPR = 5
            PRO = TLEN - 7
            ENNU = 1
        elseif TLEN == 4
            IMPR = 4
        end
    else
        if TLEN >= 20
            println("Ejecución de líneas de comando de GMSH desde PEFiCA")
            run(`gmsh ./DATOS/$ADAT.geo -2 -format msh2`)
            PRO = TLEN - 20
        end
        println("Lectura de datos de entrada de archivo .msh de GMSH")
        # Llamar función para leer .msh (ejemplo, puedes ajustar)
        [NNUD, NELE, NNUE, NGAU, NDIM, NCAT, TIPR, ENNU, IMPR, XYZ, ELE, ETY, CAT, UCO, FUN, FDI, SUP] = LEGMSH(ADAD)
    end

    # Tipo de problema
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

    # Grados de libertad y matriz de rigidez
    println("Matriz de rigidez del sólido")
    KGS = zeros(Float64, NGLT, NGLT)
    
    for IELE in 1:NELE
        # Obtener propiedades del elemento
        CAE = [CAT[ELE[IELE, 1], 1:4]; ETY[IELE, 1:2]; NGAU]
        NUEL = ETY[IELE, 2]
        XYE = XYZ[ELE[IELE, 2:NUEL+1], 1:NDIM]
        # Llamar función para calcular KEL
        # KEL = KELEME(TIPR, XYE, CAE)
        # Ensamblaje de KEL en KGS
        NKEL = size(KEL, 1)
        for IKEL in 1:NKEL
            for JKEL in 1:NKEL
                if INC[IELE, IKEL] != 0 && INC[IELE, JKEL] != 0
                    KGS[INC[IELE, IKEL], INC[IELE, JKEL]] += KEL[IKEL, JKEL]
                end
            end
        end
    end

    # Otras partes del código (vectores de fuerzas, solución del sistema, etc.)
    # ...
    
    println("Tiempo total de ejecución del programa: $(TFIN)")
end

end # Fin del módulo
