function [Pob]=Delimitador(P,Particulas)
Pob = [];
conteo = 0;
for n = 1:(Particulas*8):size(P,1)

if conteo~= 40
    Pob = [Pob;P(n:n+Particulas-1,:) ];
end

if conteo == 40
    Pob = [Pob;P(end,:) ];
    break;
end 

conteo = conteo + 1;
end 



end