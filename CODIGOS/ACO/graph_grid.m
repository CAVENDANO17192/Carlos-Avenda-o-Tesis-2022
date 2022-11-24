% Mundo positivo a partir de 1
% Solo funciona con cuadrados
% parámetros:
% grid es un número entero mayor a 1. Se genera un grafo de grid x grid
% La salida es el grafo para implementar el ACO.
%function [grafo] = graph_grid(grid)
function [grafo,Datos,Posiciones] = graph_grid(grid,xmax,ymax,zmax)



%grid = 4 max
x_lim_pos = 4;
y_lim_pos = 3;
z_lim_pos = 1.65;

x_lim_neg = 0;
y_lim_neg = 0;
z_lim_neg = 0.60;

grid_x = x_lim_pos - x_lim_neg + 1;
grid_y = y_lim_pos - y_lim_neg + 1;
grid_z = z_lim_pos - z_lim_neg + 1;




    [X1, Y1, Z1] = meshgrid(x_lim_neg:((x_lim_pos-x_lim_neg)/(4-1)):x_lim_pos, y_lim_neg:((y_lim_pos-y_lim_neg)/(4-1)):y_lim_pos, z_lim_neg:((z_lim_pos-z_lim_neg)/(4-1)):z_lim_pos);

n = size(X1,1)*size(Y1,1)*size(Z1,1);

Coords = [reshape(X1, [n, 1]),reshape(Y1, [n, 1]),  reshape(Z1, [n, 1])];

Name = string((1:n)');

EndNodes = [];
Weight = [];
Eta = [];

     
X = Coords(:, 1);
Y = Coords(:, 2);
Z = Coords(:, 3);

%------------------------------------------------------------

%4x4x4

if grid == 4
% eje 1
for nivel = 0:16:48
for columna = 0:4:12 % cambiar en factor del tamaño del grid
for fila  = 1:1:3

    res1 = fila+columna+nivel
    res2 = res1 +1
    EndNodes= [EndNodes; res1,res2]
    Weight=[Weight;1];
   
end
end
end

%eje 2
for nivel = 0:16:48
for columna = 1:1:4   
for fila = 0:4:8
 
    res1 = fila+columna+nivel
    res2 = res1 + 4 
    EndNodes = [EndNodes; res1, res2]
    Weight=[Weight;1];
end
end
end

% eje 3
for nivel = 0:4:12
for fila = 0:1:3 
for columna = 1:16:33 
  
    res1 = fila+columna+nivel
    res2 = res1 + 16 
    EndNodes = [EndNodes; res1, res2];
    Weight=[Weight;1];
end
end
end
end 

% % diagonal  para 4x4x4
 if grid == 4
for nivel = 0:16:32
for columna= 0:1:3
for fila = 0:4:8
    res1 = 1 + fila + columna + nivel
    res2 = 21 + fila+ columna + nivel
    EndNodes = [EndNodes; res1, res2];
    Weight=[Weight;sqrt(2)];
end
end
end

for nivel = 0:16:32
for columna= 0:1:3
for fila = 0:4:8
    res1 = 5 + fila + columna + nivel
    res2 = 17 + fila+ columna + nivel
    EndNodes = [EndNodes; res1, res2];
    Weight=[Weight;sqrt(2)];
end
end
end


for nivel = 0:16:32
for columna= 0:4:12
for fila = 0:1:2
    res1 = 1 + fila + columna + nivel
    res2 = 18 + fila+ columna + nivel
    EndNodes = [EndNodes; res1, res2];
    Weight=[Weight;sqrt(2)];
end
end
end

for nivel = 0:16:32
for columna= 0:4:12
for fila = 0:1:2
    res1 = 2 + fila + columna + nivel
    res2 = 17 + fila+ columna + nivel
    EndNodes = [EndNodes; res1, res2];
    Weight=[Weight;sqrt(2)];
end
end
end


for nivel = 0:4:8
for columna= 0:16:48
for fila = 0:1:2
    res1 = 1 + fila + columna + nivel
    res2 = 6 + fila+ columna + nivel
    EndNodes = [EndNodes; res1, res2];
    Weight=[Weight;sqrt(2)];
end
end
end

for nivel = 0:4:8
for columna= 0:16:48
for fila = 0:1:2
    res1 = 2 + fila + columna + nivel
    res2 = 5 + fila+ columna + nivel
    EndNodes = [EndNodes; res1, res2];
    Weight=[Weight;sqrt(2)];
end
end
end

% diagonales largas
for nivel = 0:1:2
for columna = 0:16:32
for fila= 0:4:8
for or = 0:1:1
    res1 = 1 + or + fila + columna + nivel
    res2 = 22 - or + fila + columna + nivel
    res3 = 5 + or+ fila + columna + nivel
    res4 = 18 - or + fila+ columna +  nivel
    EndNodes = [EndNodes; res1, res2; res3, res4];
    Weight=[Weight;sqrt(3);sqrt(3)];
end
end
end
end

 end

%--------------------------------------------------------------------------
% matriz 3x3x3
if grid == 3
% eje 1
for nivel = 0:9:18
for columna = 0:3:6 % cambiar en factor del tamaño del grid
for fila  = 0:1:1

    res1 = 1 + (1*fila) + columna + nivel ;
    res2 = res1 +1;
    EndNodes= [EndNodes; res1,res2];
    Weight=[Weight;1];
   
end
end
end

%eje 2
for nivel = 0:9:18
for fila = 0:1:2   
for columna = 0:1:1
    res1 = 1 + (3*columna) + fila  +nivel;
    res2 = res1 + 3 ;
    EndNodes = [EndNodes; res1, res2];
    Weight=[Weight;1];
end
end
end

% eje 3
for nivel = 0:1:2
for fila = 0:3:6   
for columna = 0:1:1
    
    res1 = 1 + (9*columna) + fila + nivel;
    res2 = res1 + 9 ;
    EndNodes = [EndNodes; res1, res2];
    Weight=[Weight;1];
end
end
end
end 

% diagonal  para 3x3x3
if grid == 3
for nivel = 0:9:9
for columna= 0:1:2
for fila = 0:3:3
    res1 = 1 + fila + columna + nivel
    res2 = 13 + fila+ columna + nivel
    EndNodes = [EndNodes; res1, res2];
    Weight=[Weight;sqrt(2)];
end
end
end


for nivel = 0:9:9
for columna= 0:1:2
for fila = 0:3:3
    res1 = 4 + fila + columna + nivel
    res2 = 10 + fila+ columna + nivel
    EndNodes = [EndNodes; res1, res2];
    Weight=[Weight;sqrt(2)];
end
end
end


for nivel = 0:9:9
for columna= 0:3:6
for fila = 0:1:1
    res1 = 1 + fila + columna + nivel
    res2 = 11 + fila+ columna + nivel
    EndNodes = [EndNodes; res1, res2];
    Weight=[Weight;sqrt(2)];
end
end
end

for nivel = 0:9:9
for columna= 0:3:6
for fila = 0:1:1
    res1 = 2 + fila + columna + nivel
    res2 = 10 + fila+ columna + nivel
    EndNodes = [EndNodes; res1, res2];
    Weight=[Weight;sqrt(2)];
end
end
end


for nivel = 0:1:1
for columna= 0:9:18
for fila = 0:3:3
    res1 = 1 + fila + columna + nivel
    res2 = 5 + fila+ columna + nivel
    EndNodes = [EndNodes; res1, res2];
    Weight=[Weight;sqrt(2)];
end
end
end

for nivel = 0:1:1
for columna= 0:9:18
for fila = 0:3:3
    res1 = 2 + fila + columna + nivel
    res2 = 4 + fila+ columna + nivel
    EndNodes = [EndNodes; res1, res2];
    Weight=[Weight;sqrt(2)];
end
end
end

end
%--------------------------------------------------------------------------
% EndNodes = [];
% 
% EndNodes = [ones(360,1),ones(360,1)];

Eta =      2*[ones(size(EndNodes,1),1)];
Datos = table(EndNodes,Weight, Eta)
Posiciones = table(Name, X, Y, Z)
G = graph(Datos, Posiciones);


grafo = simplify(G);
%h = plot(grafo, 'XData', grafo.Nodes.X+0.5, 'YData', grafo.Nodes.Y+0.5,'ZData',grafo.Nodes.Z+0.5, 'NodeColor', 'k' ); 






