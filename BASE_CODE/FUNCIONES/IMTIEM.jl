using Dates  # Necesario para manejar el tiempo

function IMTIEM(TEXT::String, TINI::Union{Int, Vector{DateTime}})
    # entrada:
    # TEXT: texto que se desea imprimir
    # TINI: tiempo inicial del grupo de instrucciones (0 para iniciar el conteo)
    # salida:
    # TFIN: tiempo al comienzo del grupo de instrucciones si TINI=0
    #       tiempo al final del grupo de instrucciones si TINI no es 0

    if TINI == 0
        # Imprimir el texto del comienzo de un grupo de instrucciones
        println(TEXT)
        # Retornar el tiempo al comienzo de las instrucciones
        return now()  # Retorna el tiempo actual
    else
        # Calcular el tiempo empleado entre el comienzo y el final de las instrucciones
        TFIN = now()  # Tiempo al final de las instrucciones
        elapsed_time = (TFIN - TINI).value # Tiempo transcurrido en segundos
        println("$TEXT ($elapsed_time seg.)")
        return elapsed_time
    end
end