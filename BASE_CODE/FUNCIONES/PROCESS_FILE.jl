function PROCESS_FILE(carpeta, archivo)
    secciones = Dict{String, Vector{String}}()  # Diccionario para almacenar secciones dinámicas
    seccion_actual = ""  # Variable para rastrear la sección actual

    ruta_datos = joinpath(@__DIR__, "../$carpeta/$archivo")

    # Abrir el archivo
    open(ruta_datos) do archivo
        for linea in eachline(archivo)
            linea = strip(linea)  # Quitar espacios en blanco
            
            # Detectar etiquetas de apertura (que empiezan con "$" y no son de cierre)
            if startswith(linea, "\$")
                if startswith(linea, "\$End")
                    seccion_actual = ""  # Fin de la sección actual
                else
                    seccion_actual = replace(linea, '$' => "") # Iniciar una nueva sección
                    secciones[seccion_actual] = String[]  # Crear una lista vacía para esta sección
                end
            # Si estamos dentro de una sección, agregar las líneas correspondientes
            elseif seccion_actual != ""
                push!(secciones[seccion_actual], linea)  # Agregar línea a la sección actual
            end
        end
    end

    return secciones
end