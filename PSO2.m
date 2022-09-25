% Carlos Roberto Avendaño Quinteros 17192
%Particle Swarm Optimization.
clc;
clear;
close all;
%% Inicializacion, definicion de parametros y de variables
% -----------------Limites---------------------------------------------
limposx=50;
limposy=50;
limposz=50;
limnegx=0;
limnegy=0;
limnegz=0;
%----------------------------------------------------------------------
x = 0;
y = 0;
z = 0;
%----------------------funcion objetivo------------------------------------
Costo = []
costo = 10*((x-1)^2)+20*((y-1)^2)+30*((z-1)^2);
%--------------------------------------------------------------------------
Particulas = 1000; %No particulas.
%--------------------Factor de aceleracion--------------------------------- 
C1 = 2;
C2 = 2;
Inertia = 0.9
%--------------------------------------------------------------------------
iteraciones = 50000000  %cantidad de iteraciones
%------------------- Inicializamos ----------------------------------------
% inicializar poblacion
Poblacion = [];
for n = 1:1:Particulas
    Poblacion = [Poblacion; randi([limnegx limposx]),randi([limnegy limposy]),randi([limnegz limposz])];
end 
P = Poblacion;  % se crea la matriz de todas las posiciones
% velocidad inicio de cada particula
V = [];
V = Poblacion*0.1;
%--------------------------------------------------------------------------
Current_P = []; % posicion actual
Current_P = Poblacion + V;
P = [P; Current_P];
for n = 1:1:Particulas
    x = Current_P(n,1);
    y = Current_P(n,2);
    z = Current_P(n,3);
    Costo=[Costo; 10*((x-1)^2)+20*((y-1)^2)+30*((z-1)^2)];
end 
[Global_Best,POS_GB]=min(Costo);
P_Best_pos =[];
P_Best = [];
P_Best = Costo;         % valor de costo de los mejores locales
P_Best_pos = Current_P; % posicion de los mejores locales

%----------------------------fin inicializacion ---------------------------

%--------------- inicio de iteraciones ------------------------------------

for iter = 1:1:iteraciones
%----------                 Actualizacion                   --------------
% ---------Determinar Velocidad y posicion de cada particula--------------


vx = 0;
vy = 0;
vz = 0;
    for n = 1:1:Particulas
        vx = Inertia*V(n,1)+C1*rand()*(P_Best_pos(n,1)-Current_P(n,1))+C2*rand()*(P_Best_pos(POS_GB,1)-Current_P(n,1));
        vy = Inertia*V(n,2)+C1*rand()*(P_Best_pos(n,2)-Current_P(n,2))+C2*rand()*(P_Best_pos(POS_GB,2)-Current_P(n,2));
        vz = Inertia*V(n,3)+C1*rand()*(P_Best_pos(n,3)-Current_P(n,3))+C2*rand()*(P_Best_pos(POS_GB,3)-Current_P(n,3));
        V(n,:) = [vx,vy,vz];
    end 
px = 0;
py = 0;
pz = 0;
    for n = 1:1:Particulas
        px = Current_P(n,1)+V(n,1);
        py = Current_P(n,2)+V(n,2);
        pz = Current_P(n,3)+V(n,3);
        Current_P(n,:) = [px,py,pz];
    end 
P = [P;Current_P];
%-------------------------------------------------------------------------
    % EVALUAR COSTO
minimo_iter = 0;    
POS_mi = 0;
Costo=[];   
for n = 1:1:Particulas
    x = Current_P(n,1);
    y = Current_P(n,2);
    z = Current_P(n,3);
    Costo=[Costo; 10*((x-1)^2)+20*((y-1)^2)+30*((z-1)^2)];
end 
[minimo_iter,POS_mi]=min(Costo);
    
% Evaluar la existencia de un nuevo global best y Pbest

if minimo_iter < Global_Best
   Global_Best = minimo_iter;  
   POS_GB = POS_mi;
end 

for n = 1:1:Particulas    
    if Costo(n) < P_Best(n)
        P_Best(n) = Costo(n);
        P_Best_pos(n,:) = [Current_P(n,:)];
    end 
end     
    
    
% EVALUAR SI SE LLEGO A LA META
Costo_fin = [];
for n = 1:1:Particulas
    x = Current_P(n,1);
    y = Current_P(n,2);
    z = Current_P(n,3);
    Costo_fin=[Costo_fin; 10*((x-1)^2)+20*((y-1)^2)+30*((z-1)^2)];
end 

PROMEDIO = mean(Costo_fin);
    
if PROMEDIO == 0
    break;
end
   disp(PROMEDIO); 

    
end 


disp(Current_P);




























