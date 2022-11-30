
# PARTICLE SWARM OPTIMIZATION
<div id="image" align= "center">
  <img src="https://user-images.githubusercontent.com/60333304/204687421-21839e98-cb12-4104-8096-0a9655b005df.gif" width = "500"/>
  </div>

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
    
 ### GUIA DE USUARIO
 
1. Descargar los archivos de Matlab y agruparlos en una carpeta 📁
2. Abrir el archivo PSO2.m siendo este la version 2.0 del algoritmo desarrollado.
3. Definir la posición inicial del dron en la variable 'dron'. 
4. Definir los parametros de los limites positivos y negativos de los 3 ejes (x,y,z)
5. Definir el punto objetivo a donde se quiere que convergan las partículas.
6. Definir los puntos de los nodos obstáculos. 
7. Correr el programa 
8. Recibir resultado en graficas y en el command window los puntos de la trayectoria para webots.

