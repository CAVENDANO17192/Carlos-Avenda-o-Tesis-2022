% Algoritmo de planificación de trayectorias y evasión de obstáculos
% Carlos Avenda�o
% 11/08/2022
clc
clear
%% INICIALIZACION DE VARIABLES
PESO_TRAYECTORIA = [];
TRAYECTORIA_HORMIGA = [];
NO_feromona_POS = [];
TRAYECTORIAS = [];
PASOS = [];
OPTIMO= 100000000000000000000000;
TRAYECTORIA_OPTIMA = [];
%% ESTABLECIENDO PARAMETROS
enable    = 1;
alpha     = 1;
beta      = 1;
rho       = 0;
hormigas  = 1;
iteraciones=1000;
gamma     = 1;
Q         = 1.1;
nodoinit  =1;
nodofinish=64;
%% CREAR GRAFO

grid = 4;   % elegir entre 3 y 4
[G,Datos,Posiciones]=graph_grid(grid);
%h = plot(G, 'XData', G.Nodes.X+0.5, 'YData', G.Nodes.Y+0.5,'ZData',G.Nodes.Z+0.5, 'NodeColor', 'k' );
% hold on;
FEROMONA = Datos.Eta;
Nodo_actual = nodoinit; 
Nodo_anterior = 0;
for ANT  = 1:1:hormigas
    disp('HORMIGA');
    disp(ANT);
for iter = 1:1:iteraciones

%% Posibles rutas a partir del nodo presente 

CAMINOS = [];
PESO = [];
TAO = [];
No  = [];
No_global = [];
Contador = 0;


for b = 1:1:size(Datos.EndNodes,1)

                if (Datos.EndNodes(b,1) == Nodo_actual) & (Datos.EndNodes(b,2) ~= Nodo_anterior)  % ver mejor el proximo nodo
                  
%                         if enable == 1    
                            CAMINOS = [CAMINOS; Datos.EndNodes(b,:) ];
                            PESO= [PESO;Datos.Weight(b)];
                            TAO = [TAO; FEROMONA(b)];
                            Contador = Contador+1;
                            No = [No; Contador];
                            No_global = [No_global;b];
%                         end 
                end

                if (Datos.EndNodes(b,2) == Nodo_actual) & (Datos.EndNodes(b,1) ~= Nodo_anterior)

%                         if enable == 1
                            CAMINOS = [CAMINOS; Datos.EndNodes(b,2),Datos.EndNodes(b,1)  ];
                            PESO= [PESO;Datos.Weight(b)];
                            TAO = [TAO; FEROMONA(b)];
                            Contador = Contador+1;
                            No = [No; Contador];
                            No_global = [No_global;b];
%                         end 

                end
%       enable = 1;
end

 
 

%% calculando probabilidades
SUM = [];
for n = 1:1:size(CAMINOS,1)
    NIJ = 1/(PESO(n));
    SUM = [SUM;TAO(n)*NIJ];
    
    
end 
sum = 0;
for n = 1:1:size(SUM,1)
    sum = sum+SUM(n);
end

P= [];
for n = 1:1:size(CAMINOS,1)
    
nij = 1/(PESO(n));
tau = TAO(n);

P = [P;(((tau)^(alpha))*((nij)^(beta)))/(sum)];
end

cumsum = [];
cusu = 1;
for n = 1:1:size(CAMINOS,1)

cusu = cusu- P(n);
cumsum = [cumsum;cusu];
end

RESULTS = table(No_global,No,CAMINOS,cumsum,TAO,PESO);
eleccion = rand;
WINNER = [];
for n = size(RESULTS.No,1):-1:0
    if n == size(RESULTS.No,1)
       if (0 <= eleccion) & (eleccion <= cumsum(n,1))
           WINNER = [n, CAMINOS(n,:)];
           NO_feromona_POS = [NO_feromona_POS;RESULTS.No_global(n)];

       end
    end
    
    if n~=0 & n~=size(RESULTS.No,1)
        if (cumsum(n,1)>= eleccion) & (eleccion > cumsum(n+1,1))
            WINNER = [n+1, CAMINOS(n+1,:)];
            NO_feromona_POS = [NO_feromona_POS;RESULTS.No_global(n)];

        end
    end
    
    if n==0
        if (cumsum(1,1) <= eleccion) & (eleccion <= 1)
            WINNER = [1, CAMINOS(1,:)];
            NO_feromona_POS = [NO_feromona_POS;RESULTS.No_global(size(RESULTS.No,1))];

        end
    end
    
end



%% TRAYECTORIA 

PESO_TRAYECTORIA = [PESO_TRAYECTORIA; RESULTS.PESO(WINNER(1))];
TRAYECTORIA_HORMIGA = [TRAYECTORIA_HORMIGA; RESULTS.CAMINOS(WINNER(1),:) ]; 

Nodo_actual = WINNER(3); 
Nodo_anterior = WINNER(2);

if Nodo_actual == nodofinish 
    break;
end

end % --------------------------------- fin iteracion -----------------------------------------------------------
%% EVAPORACION DE LA FEROMONA Y AGREGAR FEROMONA A CAMINO ELEGIDO
Nodo_actual  =nodoinit;
Nodo_anterior = 0;
nodofinish=64;
EVAPORATE = (1-rho);


FEROMONA = FEROMONA * EVAPORATE; % FEROMONA EVAPORADA
for eva = 1:1:size(NO_feromona_POS,1)
FEROMONA(NO_feromona_POS(eva)) = FEROMONA(NO_feromona_POS(eva))*Q;
end 
%NO_feromona_POS = [];

%% VERIFICAR COSTO
PESO_TOTAL = 0;
for n = 1:1:size(PESO_TRAYECTORIA,1)
    PESO_TOTAL = PESO_TOTAL + PESO_TRAYECTORIA(n);
end 
disp('peso total');
disp(PESO_TOTAL);
if PESO_TOTAL < OPTIMO
    TRAYECTORIA_OPTIMA = [];
    OPTIMO = PESO_TOTAL;
    TRAYECTORIA_OPTIMA = [TRAYECTORIA_HORMIGA];
end

% ME QUEDE EN VER LA SIMULACION  
% -------------MOSTRAR TRAYECTORIA-----------------------------------------

NODO = [];
TAO_SIMU=[];
Weight_SIMU=[];
Posiciones_SIMU=[];
Name_SIMU=[];
h = plot(G, 'XData', G.Nodes.X+0.5, 'YData', G.Nodes.Y+0.5,'ZData',G.Nodes.Z+0.5, 'NodeColor', 'k' );
hold on;
for n = 1:1:size(TRAYECTORIA_OPTIMA,1)
    NODO = [NODO; TRAYECTORIA_OPTIMA(n,1)]
    if n == size(TRAYECTORIA_OPTIMA,1)
        NODO = [NODO;nodofinish];
        
    end
    TAO_SIMU = [TAO_SIMU; FEROMONA(NO_feromona_POS(n))];
    Weight_SIMU = [Weight_SIMU;PESO_TRAYECTORIA(n)];
end 
% ERROR CUANDO NODOS PASAN POR MAS DE UNA VEZ POR EL MISMO NODO ENTONCES
% SIZE (NODO) > Posiciones = ERROR  SERIA DE VER COMO QUITAR NODOS DE LA
% MATRIZ DONDE SE PUEDEN ELEGIR
for n = 1:1:size(NODO,1)
Posiciones_SIMU = [Posiciones_SIMU; Posiciones.X(n), Posiciones.Y(n), Posiciones.Z(n)];
end 
Name_SIMU = num2str(NODO);
Xsim=Posiciones_SIMU(:,1);
Ysim=Posiciones_SIMU(:,2);
Zsim=Posiciones_SIMU(:,3);

DATASIMU = table(TRAYECTORIA_OPTIMA,Weight_SIMU, TAO_SIMU)
POS_SIMU = table(Name_SIMU,Xsim, Ysim, Zsim)
Gsim = graph(DATASIMU, POS_SIMU);
grafosimu = simplify(Gsim)
%  A = plot(grafosimu, 'XData', grafosimu.Nodes.X, 'YData', COORDS(:,2)+0.5,'ZData',COORDS(:,3)+0.5, 'NodeColor', 'r' );
% h = plot(G, 'XData', G.Nodes.X+0.5, 'YData', G.Nodes.Y+0.5,'ZData',G.Nodes.Z+0.5, 'NodeColor', 'k' );
 % ENDNODES SIMULACION = TRAYECTORIA_OPTIMA *
% Weight = *
% TAO = USAR NO_feromona_POS para jalar el numero de FEROMONA[] *
% POSICIONES ---> usar NODO para encontrar los datos X Y Z del nodo

% A = plot(G, 'XData', COORDS(:,1)+0.5, 'YData', COORDS(:,2)+0.5,'ZData',COORDS(:,3)+0.5, 'NodeColor', 'r' );
%-----------------------------------------------------------------------

disp('optimo');
disp(OPTIMO);
PESO_TRAYECTORIA = [];
TRAYECTORIA_HORMIGA = [];
NO_feromona_POS = [];
RESULTS = [];
% VER SI RESETEAR VARIABLES AL INICIO




end
% ----------------------- fin hormiga ---------------------------------




% ME QUEDE EN HACER UNA SIMULACION PARA PONER LA TRAYECTORIA OPTIMA
