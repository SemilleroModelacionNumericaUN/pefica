function SELECT_FILE(ruta_datos)

    res_archivo_seleccionado = ""

    # Función principal para mostrar la lista de archivos y permitir la selección
    # Obtener una lista de archivos en la carpeta DATOS
    archivos = readdir(ruta_datos)
    
    # Mostrar los archivos en una lista
    println("\nArchivos en la carpeta '$ruta_datos':")
    println("===================")
    println("ID - NOMBRE ARCHIVO")
    println("===================")
    for (i, archivo) in enumerate(archivos)
        println("$i - $archivo")
    end

    println("")

    # Solicitar al usuario que seleccione un archivo por ID
    println("Selecciona un archivo ingresando su ID:")
    entrada_id_archivo = readline() ## dato ingresado texto

    # Validar la entrada
    try
        id_seleccionado = parse(Int, entrada_id_archivo)  # Convertir la entrada a un entero
        if id_seleccionado < 1 || id_seleccionado > length(archivos)
            println("Error: ID '$entrada_id_archivo' fuera de rango.")
        else
            archivo_seleccionado = archivos[id_seleccionado]
            res_archivo_seleccionado = archivo_seleccionado
        end
    catch e
        println("Error: '$entrada_id_archivo' no es un número válido.")
    end

    return res_archivo_seleccionado  # Devuelve resultado
end