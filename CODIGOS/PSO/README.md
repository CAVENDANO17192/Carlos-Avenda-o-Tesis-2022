

1. PSO2
    - Código principal encargado de correr el algoritmo.
2. GENERAR_P
    - Encargado de inicializar la cantidad de particulas y sus posiciones iniciales.
3. Delimitador
    - Encargado de agarrar las trayectorias finales y convertirlas en arrays de maximo 30 puntos por limitaciones de memoria del dron.
4. fitness
    - Encargado de devolver el valor de la funcion de costo de cada particula para llegar a la referencia establecida.
5. penal
    - Encargado de que si las particulas se acercan demasiado a las particulas de obstaculos las haga esquivarlas.
6. distancia
    - Encargado de ver cual particula es la mas cercana al punto inicial del dron para agarrar su trayectoria.
