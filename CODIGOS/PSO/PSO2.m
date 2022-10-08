% Carlos Roberto Avendaño Quinteros 17192
%Particle Swarm Optimization.
clc;
clear;
close all;
%% Obstaculos

%% Inicializacion, definicion de parametros y de variables
% -----------------Limites---------------------------------------------
limposx=5;
limposy=5;
limposz=5;
limnegx=-5;
limnegy=-5;
limnegz=-5;
%----------------------------------------------------------------------
x = 0;
y = 0;
z = 0;
%------------------------POSICION OBJETIVO---------------------------------
XP=1;
YP=-2;
ZP=4;
%--------------------------------------------------------------------------
%----------------------funcion objetivo------------------------------------
Costo = []
costo = 1*((x-XP)^2)+1*((y-YP)^2)+1*((z-ZP)^2);
%--------------------------------------------------------------------------
Particulas = 100; %No particulas.
%--------------------Factor de aceleracion--------------------------------- 
C1 = 2.05;
C2 = 2.05;
Inertia = 0.1;
f_v = 0.02;
%--------------------------------------------------------------------------
iteraciones = 500;  %cantidad de iteraciones
%------------------- Inicializamos ----------------------------------------
% inicializar poblacion
Poblacion = [];
for n = 1:1:Particulas
    Poblacion = [Poblacion; randi([limnegx limposx]),randi([limnegy limposy]),randi([limnegz limposz])];
    %Poblacion = [8,9,1;9,6,1;3,5,10;10,2,10;10,5,8]
end 
%Poblacion = [8,9,1;9,6,1;3,5,10;10,2,10;10,5,8]
P = Poblacion;  % se crea la matriz de todas las posiciones
% velocidad inicio de cada particula
V = [];
V = Poblacion*0.0001;
%--------------------------------------------------------------------------
Current_P = []; % posicion actual
Current_P = Poblacion + V;
P = [P; Current_P];
for n = 1:1:Particulas
    x = Current_P(n,1);
    y = Current_P(n,2);
    z = Current_P(n,3);
    Costo=[Costo; 1*((x-XP)^2)+1*((y-YP)^2)+1*((z-ZP)^2)];
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
%         vx = Inertia*V(n,1)+C1*1*(P_Best_pos(n,1)-Current_P(n,1))+C2*1*(P_Best_pos(POS_GB,1)-Current_P(n,1));
%         vy = Inertia*V(n,2)+C1*1*(P_Best_pos(n,2)-Current_P(n,2))+C2*1*(P_Best_pos(POS_GB,2)-Current_P(n,2));
%         vz = Inertia*V(n,3)+C1*1*(P_Best_pos(n,3)-Current_P(n,3))+C2*1*(P_Best_pos(POS_GB,3)-Current_P(n,3));
        V(n,:) = f_v*[vx,vy,vz];
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
    Costo=[Costo; 1*((x-XP)^2)+1*((y-YP)^2)+1*((z-ZP)^2)];
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
    Costo_fin=[Costo_fin; 1*((x-XP)^2)+1*((y-YP)^2)+1*((z-ZP)^2)];
end 

PROMEDIO = mean(Costo_fin);
PROMEDIOX= mean(Current_P(:,1));
PROMEDIOY= mean(Current_P(:,2));
PROMEDIOZ= mean(Current_P(:,3));

if PROMEDIO < 0.1
    break;
end
   disp(PROMEDIO); 
   
   
       %% Grafica del enjambre
     
clf    
titulo = ['Minimo X: ',num2str(PROMEDIOX),' ','Minimo Y: ' , num2str(PROMEDIOY),' ','Minimo Z: ' , num2str(PROMEDIOZ)];


plot3(Current_P(:, 1), Current_P(:, 2), Current_P(:, 3),'o','LineWidth',1,'MarkerSize',9,'MarkerEdgeColor','b','MarkerFaceColor',[0,1,1]); 
TITULO=title(titulo);
axis([-8 8 -8 8 -8 8]);
xlabel('x');
ylabel('y');
zlabel('z');
grid();
pause(.1);

particula = string((1:Particulas)'); 
Xt = P(:,1);
Yt = P(:,2);
Zt = P(:,3);
tabla = table( Xt, Yt, Zt)
    
end 

disp('Posicion final');
disp(Current_P);


%% TRAYECTORIA POR PARTICULA
 P1 = [];
%  P2 = [];P3 = [];P4 = [];P5 = [];
for n = 1:5:size(tabla,1)

    P1 = [P1; tabla.Xt(n),tabla.Yt(n),tabla.Zt(n)];
%     P2 = [P2; tabla.Xt(n+1),tabla.Yt(n+1),tabla.Zt(n+1)];
%     P3 = [P3; tabla.Xt(n+2),tabla.Yt(n+2),tabla.Zt(n+2)];
%     P4 = [P4; tabla.Xt(n+3),tabla.Yt(n+3),tabla.Zt(n+3)];
%     P5 = [P5; tabla.Xt(n+4),tabla.Yt(n+4),tabla.Zt(n+4)];

end



%% Suavizado 25 puntos maximo.
% P1_OP =[]
% p =0;
% sizep= size(P,1)/25;
% sizep = round(sizep);
% contar =0;
% for n=1:sizep:size(P,1)-sizep
%     
%     if contar ==0
%         P1_OP = [P1_OP; P1(1,1),P1(1,2),P1(1,3)];
%     end
%     px = mean([P1(n,1),P1(n+sizep,1)]);
%     py = mean([P1(n,2),P1(n+sizep,2)]);
%     pz = mean([P1(n,3),P1(n+sizep,3)]);
%     
%     P1_OP = [P1_OP; px,py,pz];
%     
%     contar = contar +1;
%     if contar ==25
%         P1_OP = [P1_OP; Current_P(1,1),Current_P(1,2),Current_P(1,3)];
%         break;
%     end
% end

% ME QUEDE EN SUAVIZAR LA SEÑAL


%% MAPA TRAYECTORIAS
close all;
figure;
contar =0;
for m = 1:Particulas:size(tabla,1)-Particulas
    
    %plot3([P1_OP(m,1);P1_OP(m+Particulas,1)],[P1_OP(m,2);P1_OP(m+Particulas,2)],[P1_OP(m,3);P1_OP(m+Particulas,3)],'k')
    plot3([tabla.Xt(m);tabla.Xt(m+Particulas)],[tabla.Yt(m);tabla.Yt(m+Particulas)],[tabla.Zt(m);tabla.Zt(m+Particulas)],'k')
    hold on;
    
end 

plot3(Current_P(1,1),Current_P(1,2),Current_P(1,3),'o','LineWidth',1,'MarkerSize',9,'MarkerEdgeColor','b','MarkerFaceColor',[0,1,1])
hold on;
plot3(P1(1,1),P1(1,2),P1(1,3),'o','LineWidth',1,'MarkerSize',9,'MarkerEdgeColor','k','MarkerFaceColor',[1,0,0])
grid;

xlabel('x')
ylabel('y')
zlabel('z')




% FALTA HACER QUE LAS TRAYECTORIAS SE VEAN LIMPIAS, SE PUEDE APRECIAR QUE
% CURRENT_P son la posicion final de las particulas y estamos modelando con
% la ultima particula.










