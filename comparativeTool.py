def comparar_archivos(path1, path2, max_diferencias=None):
    """
    Compara dos archivos de texto línea por línea y muestra las primeras N diferencias.
    
    Parámetros:
        path1 (str): Ruta al primer archivo.
        path2 (str): Ruta al segundo archivo.
        max_diferencias (int, opcional): Número máximo de diferencias a mostrar. Si es None, muestra todas.
    
    Imprime:
        Las diferencias encontradas entre los archivos, hasta un máximo de N diferencias.
    """
    try:
        # Abrir ambos archivos con codificación utf-8
        with open(path1, 'r', encoding='utf-8') as f1, open(path2, 'r', encoding='utf-8') as f2:
            # Obtener todas las líneas de cada archivo
            lineas1 = f1.readlines()
            lineas2 = f2.readlines()

        # Determinar la cantidad máxima de líneas a comparar
        total_lineas = max(len(lineas1), len(lineas2))
        diferencias_encontradas = 0

        for i in range(total_lineas):
            # Obtener la línea correspondiente, o una cadena vacía si el archivo ya terminó
            linea1 = lineas1[i].rstrip('\n') if i < len(lineas1) else ""
            linea2 = lineas2[i].rstrip('\n') if i < len(lineas2) else ""

            # Comparar las líneas completas
            if linea1 != linea2:
                print(f"Diferencia en línea {i + 1}:")
                print(f"Archivo 1: {linea1}")
                print(f"Archivo 2: {linea2}")
                print("-" * 50)
                diferencias_encontradas += 1

                # Detenerse si se alcanza el máximo de diferencias permitidas
                if max_diferencias is not None and diferencias_encontradas >= max_diferencias:
                    print(f"Se alcanzó el límite de {max_diferencias} diferencias.")
                    break
    except FileNotFoundError as fnf_error:
        print(f"Error: {fnf_error}")
    except Exception as e:
        print(f"Ocurrió un error: {e}")

# Ejemplo de uso:
comparar_archivos("ej1/pettazi_assembly_my_bomb.txt", "bomb56/michanie_assembly_my_bomb.txt", max_diferencias=500)