% Carlos Roberto Avendaño Quinteros 17192
%Particle Swarm Optimization.
clc;
clear;
close all;

%% posicion inicial del dron
dron = [0.01;0.15;0.465];
%desea ver todas las trayectorias? todas = ((si = 1), (no = 0))
todas= 1;
%% Inicializacion, definicion de parametros y de variables
% -----------------Limites---------------------------------------------
limposx=4;
limposy=3;
limposz=1.65;
limnegx=0;
limnegy=0;
limnegz=0.60;
%----------------------------------------------------------------------
x = 0;
y = 0;
z = 0;
%------------------------POSICION OBJETIVO---------------------------------
XP=1;
YP=3;
ZP=1;
%------------------------POSICION OBSTACULO--------------------------------
Xobs=[];
Yobs=[];
Zobs=[];
nobs=3;
Xobs=[2.6667,2.6667,2.6667];
Yobs=[2,2,2];
Zobs= [0.6,1.00,1.5];
%-----------------------EVADIR OBSTACULOS----------------------------------
tol1 = 0.50;
evadir = 0.01;
u1x=0;u2x=0;u3x=0;
u1y=0;u2y=0;u3y=0;
u1z=0;u2z=0;u3z=0;
error = 0.000001;
%--------------------------------------------------------------------------
Trayectoria_final=[];
%----------------------funcion objetivo------------------------------------
Costo = [];
%costo = 1*((x-XP)^2)+1*((y-YP)^2)+1*((z-ZP)^2);
%--------------------------------------------------------------------------
Particulas = 512; %No particulas.  (8 en 8) (125)^1/3
%--------------------Factor de aceleracion--------------------------------- 
C1 = 2.05;
C2 = 2.05;
Inertia = 0.1;
f_v = 0.02;
%--------------------------------------------------------------------------
iteraciones = 100000000000000;  %cantidad de iteraciones
%------------------- Inicializamos ----------------------------------------
% inicializar poblacion

Poblacion = GENERAR_P(limposx,limposy,limposz,limnegx,limnegy,limnegz,Particulas);

[VER_PAR] = distancia(Poblacion,dron);
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
    costo = fitness(x,XP,y,YP,z,ZP);
    Costo=[Costo; costo];
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


%-------------------VELOCIDADES Y POSICIONES-------------------------------



    for n = 1:1:Particulas
        vx = Inertia*V(n,1)+C1*rand()*(P_Best_pos(n,1)-Current_P(n,1))+C2*rand()*(P_Best_pos(POS_GB,1)-Current_P(n,1));
        vy = Inertia*V(n,2)+C1*rand()*(P_Best_pos(n,2)-Current_P(n,2))+C2*rand()*(P_Best_pos(POS_GB,2)-Current_P(n,2));
        vz = Inertia*V(n,3)+C1*rand()*(P_Best_pos(n,3)-Current_P(n,3))+C2*rand()*(P_Best_pos(POS_GB,3)-Current_P(n,3));
        V(n,:) = f_v*[vx,vy,vz];
    end 
    
px = 0;
py = 0;
pz = 0;
    for n = 1:1:Particulas
        [u1x,u2x,u3x,u1y,u2y,u3y,u1z,u2z,u3z]=penal(nobs,Current_P(n,1),Current_P(n,2),Current_P(n,3),Xobs,Yobs,Zobs,tol1,evadir);
        px = Current_P(n,1)+V(n,1)+(u1x+u2x+u3x);
        py = Current_P(n,2)+V(n,2)+(u1y+u2y+u3y);
        pz = Current_P(n,3)+V(n,3)+(u1z+u2z+u3z);
        Current_P(n,:) = [px,py,pz];
    end 
P = [P;Current_P];
%-----------------------EVALUAR COSTO--------------------------------------
    
minimo_iter = 0;    
POS_mi = 0;
Costo=[];   
for n = 1:1:Particulas
    x = Current_P(n,1);
    y = Current_P(n,2);
    z = Current_P(n,3);
    costo = fitness(x,XP,y,YP,z,ZP);
    Costo=[Costo; costo];
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
    costo = fitness(x,XP,y,YP,z,ZP);
    Costo_fin=[Costo_fin; costo];
end 

PROMEDIO = mean(Costo_fin);
PROMEDIOX= mean(Current_P(:,1));
PROMEDIOY= mean(Current_P(:,2));
PROMEDIOZ= mean(Current_P(:,3));

if PROMEDIO < error
     fprintf('El porcentaje de error es %1.9f',PROMEDIO);
    break;
end
    
   

    
end 

%% ------------    Suavizado de 30 puntos máximo. -------------------------


[Pob]=Delimitador(P,Particulas);

%Pob = P;


%--------------------------------------------------------------------------
particula = string((1:Particulas)');

Xt = Pob(:,1);
Yt = Pob(:,2);
Zt = Pob(:,3);
tabla = table( Xt, Yt, Zt);

%% ANIMACION DEL ENJAMBRE
figure(1); 

for n = 0:Particulas:size(P,1)-1
clf;  
if(nobs==3)
plot3(Xobs,Yobs,Zobs,'o','LineWidth',1,'MarkerSize',9,'MarkerEdgeColor','k','MarkerFaceColor',[0,1,0])
end
if(nobs==2)
plot3(Xobs(1:2),Yobs(1:2),Zobs(1:2),'o','LineWidth',1,'MarkerSize',9,'MarkerEdgeColor','k','MarkerFaceColor',[0,1,0])
end
if(nobs==1)
plot3(Xobs(1),Yobs(1),Zobs(1),'o','LineWidth',1,'MarkerSize',9,'MarkerEdgeColor','k','MarkerFaceColor',[0,1,0])
end
hold on;
titulo = ['Minimo X: ',num2str(mean(P((1+n:Particulas+n), 1))),' ','Minimo Y: ' , num2str(mean(P((1+n:Particulas+n), 2))),' ','Minimo Z: ' , num2str(mean(P((1+n:Particulas+n), 3)))];
plot3(P((1+n:Particulas+n), 1), P((1+n:Particulas+n), 2), P((1+n:Particulas+n), 3),'o','LineWidth',1,'MarkerSize',9,'MarkerEdgeColor','b','MarkerFaceColor',[0,1,1]); 

TITULO=title(titulo);
axis([limnegx limposx limnegy limposy  limnegz limposz]);
xlabel('x');
ylabel('y');
zlabel('z');
grid();
drawnow limitrate

end







%% MAPA TRAYECTORIAS
% close all;
figure(2);
plot3(0,0,0);
hold on;
%%
contador = 0;
for m = 0:Particulas:size(tabla,1)-Particulas
    m
    contador = contador+1
    %plot3([P1_OP(m,1);P1_OP(m+Particulas,1)],[P1_OP(m,2);P1_OP(m+Particulas,2)],[P1_OP(m,3);P1_OP(m+Particulas,3)],'k')
    if m ~= size(tabla,1)-Particulas
    plot3([tabla.Xt(m+VER_PAR);tabla.Xt(m+Particulas+VER_PAR)],[tabla.Yt(m+VER_PAR);tabla.Yt(m+Particulas+VER_PAR)],[tabla.Zt(m+VER_PAR);tabla.Zt(m+Particulas+VER_PAR)],'k','LineWidth',1)
    else 
    
    end
    hold on;
    Trayectoria_final=[Trayectoria_final;tabla.Xt(m+VER_PAR),tabla.Yt(m+VER_PAR),tabla.Zt(m+VER_PAR)]

end 
%%
plot3(Pob(VER_PAR,1),Pob(VER_PAR,2),Pob(VER_PAR,3),'o','LineWidth',1,'MarkerSize',9,'MarkerEdgeColor','b','MarkerFaceColor',[0,1,1])
hold on;
plot3(XP,YP,ZP,'o','LineWidth',1,'MarkerSize',15,'MarkerEdgeColor','k','MarkerFaceColor',[1,0,0])
hold on;
if(nobs==3)
plot3(Xobs,Yobs,Zobs,'o','LineWidth',1,'MarkerSize',9,'MarkerEdgeColor','k','MarkerFaceColor',[0,1,0])
end
if(nobs==2)
plot3(Xobs(1:2),Yobs(1:2),Zobs(1:2),'o','LineWidth',1,'MarkerSize',9,'MarkerEdgeColor','k','MarkerFaceColor',[0,1,0])
end
if(nobs==1)
plot3(Xobs(1),Yobs(1),Zobs(1),'o','LineWidth',1,'MarkerSize',9,'MarkerEdgeColor','k','MarkerFaceColor',[0,1,0])
end
hold on;
grid;
xlabel('x')
ylabel('y')
zlabel('z')


if(todas==1)
figure(3);
plot3(0,0,0);
hold on;
plot3(Pob(1:Particulas,1),Pob(1:Particulas,2),Pob(1:Particulas,3),'o','LineWidth',1,'MarkerSize',9,'MarkerEdgeColor','b','MarkerFaceColor',[0,1,1]);
hold on;
axis([limnegx limposx limnegy limposy  limnegz limposz]);
xlabel('x');
ylabel('y');
zlabel('z');
grid();
drawnow limitrate
hold on;
for n = 0:1:Particulas-1
for m = 1:Particulas:size(tabla,1)-Particulas
    
    %plot3([P1_OP(m,1);P1_OP(m+Particulas,1)],[P1_OP(m,2);P1_OP(m+Particulas,2)],[P1_OP(m,3);P1_OP(m+Particulas,3)],'k')
    plot3([tabla.Xt(m+n);tabla.Xt(m+Particulas+n)],[tabla.Yt(m+n);tabla.Yt(m+Particulas+n)],[tabla.Zt(m+n);tabla.Zt(m+Particulas+n)],'k','LineWidth',0.5)
    hold on;
    
end 
end
plot3(Pob(1,1),Pob(1,2),Pob(1,3),'o','LineWidth',1,'MarkerSize',9,'MarkerEdgeColor','b','MarkerFaceColor',[0,1,1])
hold on;
plot3(XP,YP,ZP,'o','LineWidth',1,'MarkerSize',15,'MarkerEdgeColor','k','MarkerFaceColor',[1,0,0])
hold on;
if(nobs==3)
plot3(Xobs,Yobs,Zobs,'o','LineWidth',1,'MarkerSize',9,'MarkerEdgeColor','k','MarkerFaceColor',[0,1,0])
end
if(nobs==2)
plot3(Xobs(1:2),Yobs(1:2),Zobs(1:2),'o','LineWidth',1,'MarkerSize',9,'MarkerEdgeColor','k','MarkerFaceColor',[0,1,0])
end
if(nobs==1)
plot3(Xobs(1),Yobs(1),Zobs(1),'o','LineWidth',1,'MarkerSize',9,'MarkerEdgeColor','k','MarkerFaceColor',[0,1,0])
end
hold on;
grid;
xlabel('x')
ylabel('y')
zlabel('z')

end

for n = 1:1:size(Trayectoria_final,1)
    fprintf('%1.3f, %1.3f, %1.3f,\n',Trayectoria_final(n,1),Trayectoria_final(n,2),Trayectoria_final(n,3))
end 