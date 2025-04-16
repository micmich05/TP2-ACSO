def soluciones_validas(path_palabras):
    
    """
    Recibe la ruta de un archivo de texto con palabras ordenadas alfabéticamente,
    realiza una búsqueda binaria simulada sobre cada palabra para determinar 
    cuántas iteraciones toma encontrarla. Retorna una lista de todas las (palabra, iteraciones)
    que cumplan con las restricciones:
      - La palabra se encuentra en 7..11 iteraciones (ambos inclusive).
    Se imprimen las palabras que cumplen con la condición de ser "soluciones posibles".
    """

    with open(path_palabras, 'r', encoding='utf-8') as f:
        palabras = [line.strip() for line in f if line.strip()]

    soluciones = []

    for _, objetivo in enumerate(palabras):

        izquierda = 0
        derecha = len(palabras) - 1
        iteraciones = 0
        encontrado = False

        while izquierda <= derecha:
            iteraciones += 1  

            if iteraciones > 11:
                break

            medio = (izquierda + derecha) // 2
            palabra_medio = palabras[medio]

            if palabra_medio == objetivo:
                encontrado = True
                break
            elif palabra_medio < objetivo:
                izquierda = medio + 1
            else:
                derecha = medio - 1

        if encontrado and 7<= iteraciones <= 11:
            soluciones.append((objetivo, iteraciones))

    return soluciones

#Ejemplo de uso:
path = "/Users/micolmichanie/Documents/TP2-ACSO/bomb56/palabras.txt"
resultado = soluciones_validas(path)
print(resultado)
