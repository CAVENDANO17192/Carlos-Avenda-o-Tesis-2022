function [nodo_init] = distancia(Posiciones,dron)
dist=0;
dist_par=[];
posicion = 0;
valor = 0;
for n = 1:1:size(Posiciones,1)
    dist=sqrt(((dron(1,1)-Posiciones.X(n,1))^2)+((dron(2,1)-Posiciones.Y(n,1))^2)+((dron(3,1)-Posiciones.Z(n,1))^2));
    dist_par=[dist_par;dist];
end

[valor,nodo_init]=min(dist_par);


end