En el presente folder se encuentran los archivos .m de matlab para correr el código de particle swarm optimization. 
En el archivo PSO2.m se encuentra el codigo principal encargado de correr el algoritmo.
En el archivo GENERAR_P se encuentra el .m encargado de inicializar la cantidad de particulas y sus posiciones iniciales.
El archivo Delimitador.m es el encargado de agarrar las trayectorias finales y convertirlas en arrays de maximo 30 puntos por limitaciones de memoria del dron.
El archivo fitness.m es el encargado de devolver el valor de la funcion de costo de cada particula para llegar a la referencia establecida.
El archivo penal.m es el encargado de que si las particulas se acercan demasiado a las particulas de obstaculos las haga esquivarlas.
El archivo distancia.m es el encargado de ver cual particula es la mas cercana al punto inicial del dron para agarrar su trayectoria.
