using Printf
using Base.Filesystem

include("FUNCIONES/UTILITIES.jl")  
include("FUNCIONES/PRINT_TITLE.jl")  
include("FUNCIONES/SELECT_FILE.jl")
include("FUNCIONES/PROCESS_FILE.jl")

# -------------------------------------------------------------------------
# Dorian L. Linero S., Martín Estrada M. & Diego A. Garzón A. - Miguel A. Urrea M.
# Universidad Nacional de Colombia
# Facultad de Ingeniería
# Todos los derechos reservados, 2022

valor_lectura = ""
archivo_procesamiento = ""

PRINT_TITLE()

# Lista de valores válidos como strings
valores_validos = ["04", "05", "06", "07", "08", "10", "11", "12", "17", "20", "21", "22", "1900"]

# Crear un diccionario
mi_diccionario = Dict(
    "04" => "Lectura de .m de GiD y escritura malla en TikZ",
    "05" => "Lectura de .m de GiD y escritura definida por IMPR. Si IMPR=2 se escriben resultados en .gid.res y gid.msh de GiD",
    "06" => "Lectura de .m de GiD y escritura resultados en .gid.res y gid.msh de GiD, y en ventana de comandos",
    "07" => "Lectura de .m de GiD y escritura resultados en .pos de GMSH esfuerzos y deformaciones promedio en nudos PRO=0",
    "08" => "Lectura de .m de GiD y escritura resultados en .pos de GMSH esfuerzos y deformaciones en el interior de elementos PRO=1", 
    "10" => "Lectura datos de .msh de GMSH y escritura resultados en .pos de GMSH esfuerzos y deformaciones promedio en nudos para una categoría de material y espesor PRO=0", 
    "11" => "Lectura datos de .msh de GMSH y escritura resultados en .pos de GMSH, esfuerzos y deformaciones en el interior de elementos PRO=1", 
    "12" => "Lectura datos de .msh de GMSH y escritura resultados en .pos de GMSH esfuerzos y deformaciones promedio en nudos para varias categorías de material y espesor PRO=2. Adicionalmente se imprime en la ventana las reacciones.", 
    "17" => "Lectura datos de .msh de GMSH y escritura resultado .gid.res y gid.msh de GiD", 
    "20" => "Lectura datos de .geo de GMSH, generación de malla y del archivo .msh realizada de forma remota por GMSH, y escritura de resultados en archivo .pos de GMSH, calculando como 10,11,12", 
    "21" => "Lectura datos de .geo de GMSH, generación de malla y del archivo .msh realizada de forma remota por GMSH, y escritura de resultados en archivo .pos de GMSH, calculando como 10,11,12", 
    "22" => "Lectura datos de .geo de GMSH, generación de malla y del archivo .msh realizada de forma remota por GMSH, y escritura de resultados en archivo .pos de GMSH, calculando como 10,11,12", 
    "1900" => "Lectura datos de .msh de GMSH y escritura malla en TikZ"
)

println("######################### OPCIONES DE LECTURA #########################\n")
for (clave) in valores_validos
    println("($clave) ", mi_diccionario[clave])
end
println("---------------------------------------------------------------------\n")
println("Ingrese la opción de lectura (Si el valor se omite\nadquiere un valor por defecto de 10):")

#println("escriba PEFICA <nombre archivo datos .m o .msh> <opciones lectura>")
#println("el parámetro <opciones lectura> puede ser igual a: ")

# Captura la entrada del usuario
entrada = readline()

# Validación: comprobar si la entrada es vacía o pertenece a los valores válidos
if entrada == ""  # Si la entrada está vacía
    CLEAN_CONSOLE()
    PRINT_TITLE()
    println("\nOpción de lectura vacío. La función tomará por defecto la opción de lectura (10)")

    valor_lectura = "10"
    println("\nOpción de lectura seleccionada:\n($valor_lectura) ", mi_diccionario[valor_lectura])
    
    archivo_procesamiento = SELECT_FILE("DATOS")
elseif entrada in valores_validos  # Si la entrada está en la lista de valores válidos
    CLEAN_CONSOLE()
    PRINT_TITLE()

    valor_lectura = entrada
    println("\nOpción de lectura seleccionada:\n($valor_lectura) ", mi_diccionario[valor_lectura])
    
    archivo_procesamiento = SELECT_FILE("DATOS")
else
    println("\nError: '$entrada' no es un valor válido\n")
end

if archivo_procesamiento != ""
    CLEAN_CONSOLE()
    PRINT_TITLE()
    println("\nOpción de lectura seleccionada:\n\n($valor_lectura) ", mi_diccionario[valor_lectura])

    println("\nArchivo seleccionado:\n\n$archivo_procesamiento")
    secciones = PROCESS_FILE("DATOS", archivo_procesamiento)
        
    println("\nSecciones detectadas en el archivo\n")
    
    # Imprimir las secciones procesadas (solo para mostrar cómo se capturaron)
    for (clave, contenido) in secciones
        println("Sección: $clave")
        #=
        println("Contenido:")
        for linea in contenido
            println(linea)
        end
        =#
    end

    println("\nVersión del archivo leido ", secciones["MeshFormat"][1], "\n")

    println(secciones["PhysicalNames"])
    for i in 2:length(secciones["PhysicalNames"])
        println(secciones["PhysicalNames"][i])
    end
    println(length(secciones["PhysicalNames"]))

    # Crear un array vacío para almacenar los arrays resultantes
    arrays_dinamicos = []
    array_inicial = secciones["PhysicalNames"]
    # Iterar sobre cada elemento del array inicial
    for elemento in array_inicial
        # Dividir el string en un array según los espacios
        array_dividido = split(elemento)
        
        # Agregar el array dividido a arrays_dinamicos
        push!(arrays_dinamicos, array_dividido)
    end

    # Imprimir el resultado
    println(arrays_dinamicos)
end

while true
    sleep(1)  # Pausa indefinida; el programa seguirá corriendo hasta que cierres la ventana manualmente
end