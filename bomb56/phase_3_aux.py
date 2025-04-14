def soluciones_validas(path_palabras):
    """
    Recibe la ruta de un archivo de texto con palabras ordenadas alfabéticamente,
    realiza una búsqueda binaria simulada sobre cada palabra para determinar 
    cuántas iteraciones toma encontrarla. Retorna una lista de todas las (palabra, iteraciones)
    que cumplan con las restricciones:
      - La palabra se encuentra en 7..10 iteraciones (ambos inclusive).
      - Dicho número de iteraciones coincide exactamente con el entero pasado por parámetro 
        en una llamada hipotética (es decir, la 'solución' es (palabra, iteraciones)).
    """

    # 1. Leer todas las palabras del archivo en una lista, asumiendo que el archivo
    #    ya está ordenado alfabéticamente (sin espacios ni saltos extra).
    with open(path_palabras, 'r', encoding='utf-8') as f:
        palabras = [line.strip() for line in f if line.strip()]

    soluciones = []

    # 2. Para cada palabra en la lista, simulamos una búsqueda binaria
    #    para saber en cuántas iteraciones la encontraríamos.
    for idx, objetivo in enumerate(palabras):
        # Realizamos la búsqueda binaria sobre la MISMA lista 'palabras'
        # asumiendo que 'objetivo' es el target a encontrar.
        izquierda = 0
        derecha = len(palabras) - 1
        iteraciones = 0
        encontrado = False

        while izquierda <= derecha:
            iteraciones += 1  # Contamos la iteración

            # Si superamos las 11 iteraciones, cortamos (explota).
            if iteraciones > 11:
                break

            medio = (izquierda + derecha) // 2
            palabra_medio = palabras[medio]

            if palabra_medio == objetivo:
                # Encontramos la palabra
                encontrado = True
                break
            elif palabra_medio < objetivo:
                izquierda = medio + 1
            else:
                derecha = medio - 1

        # 3. Verificamos las condiciones:
        #   - Se encontró la palabra y no pasamos de 11 iteraciones
        #   - Se usaron al menos 6 iteraciones
        #   - Para que la palabra sea una "solución posible", el entero asociado
        #     (en la lógica de la fase) debería ser EXACTAMENTE 'iteraciones'.
        if encontrado and 7<= iteraciones <= 10:
            soluciones.append((objetivo, iteraciones))

    return soluciones

#Ejemplo de uso:
path = "/Users/micolmichanie/Documents/TP2-ACSO/bomb56/palabras.txt"
resultado = soluciones_validas(path)
print(resultado)
