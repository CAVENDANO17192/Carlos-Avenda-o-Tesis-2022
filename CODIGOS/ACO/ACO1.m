% Algoritmo de planificación de trayectorias y evasión de obstáculos
% Carlos Avenda�o
% 11/08/2022
clc
clear
close all;
%% Posicion inicial del dron
dron = [0.01;0.15;0.465];

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
% alpha     = 0.7;
% beta      = 1.2;
% rho       = 0.3;
% Q         = 0.7;
alpha     = 0.6;
beta      = 0.5;
rho       = 0.1;
Q         = 0.5;
hormigas  = 200;
iteraciones=2500;
gamma     = 1;

nodofinish=64;
EVAPORATE = (1-rho);
death=0;
%% CREAR GRAFO

grid = 4;  
[G,Datos,Posiciones]=graph_grid(grid,4,3,1.65); %(grid,xmax,ymax,zmax) 
                                                    %verificar que los limites x,y,z generen la misma cantidad de
                                                    %elementos en reshape
                                                
FEROMONA = Datos.Eta;
ENDNODES= Datos.EndNodes;

[nodoinit] = distancia(Posiciones,dron)

Nodo_actual = nodoinit; 
Nodo_anterior = 0;

%% TODAS LAS TRAYECTORIAS

figure (1);
H = plot(G, 'XData', G.Nodes.X, 'YData', G.Nodes.Y,'ZData',G.Nodes.Z, 'NodeColor', 'k');
title('TRAYECTORIA HORMIGA');


%% -------------------- OBSTACULOS----------------------------------------

OBSTACULO = 1;

switch OBSTACULO
    
   
    case 1
        obs1 = 59;
        obs2 = 43;
        obs3 = 27;
        obs4 = 11;
    case 2 
        obs1 = 0;
        obs2 = 0;
        obs3 = 0;
        obs4 = 0;


end 

%-------------------------------------------------------------------------

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

    if (ENDNODES(b,1) ~= obs1) & (ENDNODES(b,2) ~= obs1) & (ENDNODES(b,1) ~= obs2) & (ENDNODES(b,2) ~= obs2)...
            & (ENDNODES(b,1) ~= obs3) & (ENDNODES(b,2) ~= obs3)& (ENDNODES(b,1) ~= obs4) & (ENDNODES(b,2) ~= obs4)
                if (ENDNODES(b,1) == Nodo_actual) && (ENDNODES(b,2) ~= Nodo_anterior)   % ver mejor el proximo nodo
                  
   
                            CAMINOS = [CAMINOS; ENDNODES(b,:) ];
                            PESO= [PESO;Datos.Weight(b)];
                            TAO = [TAO; FEROMONA(b)];
                            Contador = Contador+1;
                            No = [No; Contador];
                            No_global = [No_global;b];

                end

                if (ENDNODES(b,2) == Nodo_actual) && (ENDNODES(b,1) ~= Nodo_anterior) 


                            CAMINOS = [CAMINOS; ENDNODES(b,2),ENDNODES(b,1)  ];
                            PESO= [PESO;Datos.Weight(b)];
                            TAO = [TAO; FEROMONA(b)];
                            Contador = Contador+1;
                            No = [No; Contador];
                            No_global = [No_global;b];


                end
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
%nodofinish=60;


if(enable == 1)
FEROMONA = FEROMONA * EVAPORATE; % FEROMONA EVAPORADA
for eva = 1:1:size(NO_feromona_POS,1)
FEROMONA(NO_feromona_POS(eva)) = FEROMONA(NO_feromona_POS(eva))+Q;
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


end
enable = 1;

disp('optimo');
disp(OPTIMO);

% ------- GUARDAR VARIBALES SIMU----------
PESO_TRAYECT = [];
NO_fermon = [];
PESO_TRAYECT = PESO_TRAYECTORIA;
NO_fermon = NO_feromona_POS;
%-------- RESETEAR VARIABLES ---------------
PESO_TRAYECTORIA = [];
TRAYECTORIA_HORMIGA = [];
NO_feromona_POS = [];
RESULTS = [];
%-------------------------------------------
end
% ----------------------- fin hormiga ---------------------------------











% -------------MOSTRAR TRAYECTORIA-----------------------------------------
%********************************************
NODO = [];
TAO_SIMU=[];
Weight_SIMU=[];
Posiciones_SIMU=[];
Name_SIMU=[];
nod = 0;



for n = 1:1:size(TRAYECTORIA_OPTIMA,1)          
    
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
    
    TAO_SIMU = [TAO_SIMU; FEROMONA(NO_fermon(n))]; 
    Weight_SIMU = [Weight_SIMU;PESO_TRAYECT(n)]; 
end 


NODO = sort(NODO);

for m = 1:1:size(NODO,1)
for n = 1:1:size(Posiciones,1) 
    
if NODO(m) == str2num(Posiciones.Name(n))
Posiciones_SIMU = [Posiciones_SIMU; Posiciones.X(n), Posiciones.Y(n), Posiciones.Z(n)];
end

end 
end 


%------------------------------------------------------------------------
Name_SIMU = Posiciones.Name;
Xsim=Posiciones(:,2);
Ysim=Posiciones(:,3);
Zsim=Posiciones(:,4);
EndNodes = TRAYECTORIA_OPTIMA;
DATASIMU = table(EndNodes,Weight_SIMU, TAO_SIMU);
POS_SIMU = table(string(Name_SIMU),Xsim, Ysim, Zsim);
Gsim = graph(DATASIMU, POS_SIMU);                       
grafosimu = simplify(Gsim);
figure(2);
A = plot(grafosimu, 'XData', grafosimu.Nodes.Xsim.X, 'YData', grafosimu.Nodes.Ysim.Y,'ZData',grafosimu.Nodes.Zsim.Z, 'NodeColor', 'k');
hold on;
if obs1 ~= 0
plot3(Posiciones.X(obs1),Posiciones.Y(obs1),Posiciones.Z(obs1),'o','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor',[0,1,0]);
hold on;
plot3(Posiciones.X(obs2),Posiciones.Y(obs2),Posiciones.Z(obs2),'o','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor',[0,1,0]);
hold on;
plot3(Posiciones.X(obs3),Posiciones.Y(obs3),Posiciones.Z(obs3),'o','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor',[0,1,0]);
hold on;
plot3(Posiciones.X(obs4),Posiciones.Y(obs4),Posiciones.Z(obs4),'o','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','k','MarkerFaceColor',[0,1,0]);
end



for n = 1:1:size(Posiciones_SIMU,1)
    fprintf('%1.2f, %1.2f, %1.2f,\n',Posiciones_SIMU(n,1),Posiciones_SIMU(n,2),Posiciones_SIMU(n,3))
end 
