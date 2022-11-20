function [VER_PAR] = distancia(Poblacion,dron)
dist=0;
dist_par=[];
posicion = 0;
valor = 0;
for n = 1:1:size(Poblacion,1)
    dist=sqrt(((dron(1,1)-Poblacion(n,1))^2)+((dron(2,1)-Poblacion(n,2))^2)+((dron(3,1)-Poblacion(n,3))^2));
    dist_par=[dist_par;dist];
end

[valor,VER_PAR]=min(dist_par);


end