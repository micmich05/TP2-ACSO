def comparar_archivos(path1, path2):
    """
    Compara dos archivos de texto carácter a carácter.
    
    Parámetros:
        path1 (str): Ruta al primer archivo.
        path2 (str): Ruta al segundo archivo.
    
    Imprime:
        La línea y posición del carácter donde existen diferencias.
    """
    try:
        # Abrir ambos archivos con codificación utf-8
        with open(path1, 'r', encoding='utf-8') as f1, open(path2, 'r', encoding='utf-8') as f2:
            # Obtener todas las líneas de cada archivo
            lineas1 = f1.readlines()
            lineas2 = f2.readlines()

        # Determinar la cantidad máxima de líneas a comparar
        total_lineas = max(len(lineas1), len(lineas2))

        for i in range(total_lineas):
            # Obtener la línea correspondiente, o una cadena vacía si el archivo ya terminó
            linea1 = lineas1[i].rstrip('\n') if i < len(lineas1) else ""
            linea2 = lineas2[i].rstrip('\n') if i < len(lineas2) else ""

            # Determinar el máximo número de caracteres en la línea actual
            total_caracteres = max(len(linea1), len(linea2))

            for j in range(total_caracteres):
                # Obtener el carácter o una cadena vacía en caso de que la línea no llegue a esa posición
                char1 = linea1[j] if j < len(linea1) else ""
                char2 = linea2[j] if j < len(linea2) else ""
                
                if char1 != char2:
                    print(f"Diferencia en línea {i + 1}, posición {j + 1}: '{char1}' vs '{char2}'")
    except FileNotFoundError as fnf_error:
        print(f"Error: {fnf_error}")
    except Exception as e:
        print(f"Ocurrió un error: {e}")

# Ejemplo de uso:
comparar_archivos("valen.txt", "ej1/salida.propia.ej1.txt")
