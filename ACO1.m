% Algoritmo de planificaci√≥n de trayectorias y evasi√≥n de obst√°culos
% Carlos AvendaÒo
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
rho       = 0.5;
hormigas  = 50;
iteraciones=2000;
gamma     = 1;
Q         = 1.2;
nodoinit  =1;
nodofinish=64;
death=0;
%% CREAR GRAFO

grid = 4;   % elegir entre 3 y 4
[G,Datos,Posiciones]=graph_grid(grid);
FEROMONA = Datos.Eta;
ENDNODES= Datos.EndNodes;

Nodo_actual = nodoinit; 
Nodo_anterior = 0;
for ANT  = 1:1:hormigas
    disp('HORMIGA');
    disp(ANT);
for iter = 1:1:iteraciones

%% Posibles rutas a partir del nodo presente 
% ----------LIMPIEZA DE VARIABLES PARA ITERACION NUEVA---------------------
CAMINOS = [];
PESO = [];
TAO = [];
No  = [];
No_global = [];
Contador = 0;
SUM = [];
sum = 0;
P= [];
cumsum = [];
cusu = 1;
eleccion = rand;
WINNER = [];
%--------------------------------------------------------------------------

for b = 1:1:size(ENDNODES,1)

                if (ENDNODES(b,1) == Nodo_actual) & (ENDNODES(b,2) ~= Nodo_anterior)  % ver mejor el proximo nodo
                  
   
                            CAMINOS = [CAMINOS; ENDNODES(b,:) ];
                            PESO= [PESO;Datos.Weight(b)];
                            TAO = [TAO; FEROMONA(b)];
                            Contador = Contador+1;
                            No = [No; Contador];
                            No_global = [No_global;b];

                end

                if (ENDNODES(b,2) == Nodo_actual) & (ENDNODES(b,1) ~= Nodo_anterior)


                            CAMINOS = [CAMINOS; ENDNODES(b,2),ENDNODES(b,1)  ];
                            PESO= [PESO;Datos.Weight(b)];
                            TAO = [TAO; FEROMONA(b)];
                            Contador = Contador+1;
                            No = [No; Contador];
                            No_global = [No_global;b];


                end

end



%% calculando probabilidades

for n = 1:1:size(CAMINOS,1)
    NIJ = 1/(PESO(n));
    SUM = [SUM;TAO(n)*NIJ];
    
    
end 

for n = 1:1:size(SUM,1)
    sum = sum+SUM(n);
end


for n = 1:1:size(CAMINOS,1)
    
nij = 1/(PESO(n));
tau = TAO(n);

P = [P;(((tau)^(alpha))*((nij)^(beta)))/(sum)];
end


for n = 1:1:size(CAMINOS,1)
cusu = cusu- P(n);
cumsum = [cumsum;cusu];
end

RESULTS = table(No_global,No,CAMINOS,cumsum,TAO,PESO);

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

% PENDIENTE DE VER SI QUITAR
%NUMERO_GLOBAL = RESULTS.No_global(WINNER(1));
%ENDNODES(NUMERO_GLOBAL,:) = [];

%% TRAYECTORIA 

PESO_TRAYECTORIA = [PESO_TRAYECTORIA; RESULTS.PESO(WINNER(1))];
TRAYECTORIA_HORMIGA = [TRAYECTORIA_HORMIGA; RESULTS.CAMINOS(WINNER(1),:) ]; 

Nodo_actual = WINNER(3); 
Nodo_anterior = WINNER(2);

if Nodo_actual == nodofinish 
    break;
end


 if (iter == iteraciones) & (Nodo_actual ~= nodofinish)                    % CHEQUEAR SI CONVERGIO
     disp('hormiga sin converger');
     enable = 0;
     death = death+1;
     break; 
     
 end 
end % --------------------------------- fin iteracion -----------------------------------------------------------
%% EVAPORACION DE LA FEROMONA Y AGREGAR FEROMONA A CAMINO ELEGIDO
Nodo_actual  =nodoinit;
Nodo_anterior = 0;
nodofinish=64;
EVAPORATE = (1-rho);

if(enable == 1)
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
%********************************************
NODO = [];
TAO_SIMU=[];
Weight_SIMU=[];
Posiciones_SIMU=[];
Name_SIMU=[];
nod = 0;

for n = 1:1:size(TRAYECTORIA_OPTIMA,1)          % evitr poner nodos n
    
    if n ~= 1
    for m = 1:1:size(NODO,1)
        if TRAYECTORIA_OPTIMA(n,1) == NODO(m)
            nod= 1;
        end 
    end 
    end 
    
    if n == 1
        NODO = [NODO; TRAYECTORIA_OPTIMA(n,1)];
    end 
    
    if (nod ~= 1) & (n ~=1)
        NODO = [NODO; TRAYECTORIA_OPTIMA(n,1)];
    end 
    nod = 0;
    if n == size(TRAYECTORIA_OPTIMA,1)
        NODO = [NODO;nodofinish];  
    end
    
    TAO_SIMU = [TAO_SIMU; FEROMONA(NO_feromona_POS(n))];
    Weight_SIMU = [Weight_SIMU;PESO_TRAYECTORIA(n)];
end 

NODO = sort(NODO);
%******************************************
% ERROR CUANDO NODOS PASAN POR MAS DE UNA VEZ POR EL MISMO NODO ENTONCES
% SIZE (NODO) > Posiciones = ERROR  SERIA DE VER COMO QUITAR NODOS DE LA
% MATRIZ DONDE SE PUEDEN ELEGIR// SE ENCONTRO COMO IR QUITANDO ELEMENTOS DE
% LA MATRIZ PARA EVITAR IR POR NODOS YA ELEGIDOS ( VER DOCUMENTACION)
%***********************************************************************

% SE DEBE DE UTILIZAR EL TAMA—O DE LOS NODOS PARA QUE SE PUEDAN REPETIR
% POSICIONES
for m = 1:1:size(NODO,1)
for n = 1:1:size(Posiciones,1) 
    
if NODO(m) == str2num(Posiciones.Name(n))
Posiciones_SIMU = [Posiciones_SIMU; Posiciones.X(n), Posiciones.Y(n), Posiciones.Z(n)];
end

end 
end 
if (ANT == hormigas)
Name_SIMU = Posiciones.Name;
Xsim=Posiciones(:,2);
Ysim=Posiciones(:,3);
Zsim=Posiciones(:,4);
EndNodes = TRAYECTORIA_OPTIMA;
DATASIMU = table(EndNodes,Weight_SIMU, TAO_SIMU);
POS_SIMU = table(string(Name_SIMU),Xsim, Ysim, Zsim);
Gsim = graph(DATASIMU, POS_SIMU);                       % saca error de que EndNodes es menor que 64.
grafosimu = simplify(Gsim);
figure(2);
A = plot(grafosimu, 'XData', grafosimu.Nodes.Xsim.X+0.5, 'YData', grafosimu.Nodes.Ysim.Y+0.5,'ZData',grafosimu.Nodes.Zsim.Z+0.5, 'NodeColor', 'k');
end 
%***************************************    % Probar cla para borrar el grafo anterior.  
% figure(2);
%   A = plot(grafosimu, 'XData', grafosimu.Nodes.Xsim+0.5, 'YData', grafosimu.Nodes.Ysim+0.5,'ZData',grafosimu.Nodes.Zsim+0.5, 'NodeColor', 'r' );
% h = plot(G, 'XData', G.Nodes.X+0.5, 'YData', G.Nodes.Y+0.5,'ZData',G.Nodes.Z+0.5, 'NodeColor', 'k' );
 % ENDNODES SIMULACION = TRAYECTORIA_OPTIMA *
% Weight = *
% TAO = USAR NO_feromona_POS para jalar el numero de FEROMONA[] *
% POSICIONES ---> usar NODO para encontrar los datos X Y Z del nodo

% A = plot(G, 'XData', COORDS(:,1)+0.5, 'YData', COORDS(:,2)+0.5,'ZData',COORDS(:,3)+0.5, 'NodeColor', 'r' );
%-----------------------------------------------------------------------

disp('optimo');
disp(OPTIMO);

figure (1);
% subplot(1,2,2);
H = plot(G, 'XData', G.Nodes.X+0.5, 'YData', G.Nodes.Y+0.5,'ZData',G.Nodes.Z+0.5, 'NodeColor', 'k');
title('TRAYECTORIA HORMIGA');
% subplot(1,2,1);
% h = plot(G, 'XData', G.Nodes.X+0.5, 'YData', G.Nodes.Y+0.5,'ZData',G.Nodes.Z+0.5, 'NodeColor', 'k' );
% title('TRAYECTORIA OPTIMA');

%-------- RESETEAR VARIABLES ---------------
PESO_TRAYECTORIA = [];
TRAYECTORIA_HORMIGA = [];
NO_feromona_POS = [];
RESULTS = [];
%-------------------------------------------




end
enable = 1;
end
% ----------------------- fin hormiga ---------------------------------



% PARA VER SIMULACION PRIMERO SOLUCIONAR ERROR LINEA 201
% ME QUEDE EN HACER UNA SIMULACION PARA PONER LA TRAYECTORIA OPTIMA
